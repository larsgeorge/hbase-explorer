#/**
# * Copyright 2007 The Apache Software Foundation
# *
# * Licensed to the Apache Software Foundation (ASF) under one
# * or more contributor license agreements.  See the NOTICE file
# * distributed with this work for additional information
# * regarding copyright ownership.  The ASF licenses this file
# * to you under the Apache License, Version 2.0 (the
# * "License"); you may not use this file except in compliance
# * with the License.  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

import logging

from django.db import models
from django.contrib.auth.models import User
from urlparse import urlparse, urlunparse

import urllib, urllib2, httplib
import json
import socket, exceptions

LOG = logging.getLogger(__name__)
ACCEPT_JSON = {"Accept":"application/json"}
MIME_XML = {"Content-Type": "text/xml"}
    
def doRequest(host=None, method="GET", url=None, headers=None, body=None, timeout=30, status=None):
    """
    Convenience function to make restful HTTP requests.
    """
    conn = None
    try:
        conn = httplib.HTTPConnection(host, timeout=timeout)
        conn.request(method, url, body, headers)
        response = conn.getresponse()
        if status: assert(response.status == status)
        data = response.read()
        if response.length == 0: data = None
    except httplib.HTTPException, e:
       raise httplib.HTTPException("HTTP error: %d" % e.code)
    except socket.error, e:
       raise socket.error("Socket error: %s" % e.message)
    except exceptions.IOError, e:
       raise exceptions.IOError("IO error: %s" % e.message)
    finally:
        if conn: conn.close();
    return {"body":data, "status":response.status, "headers":dict(response.getheaders())}
    
class ClusterAddress(models.Model):
    """
    Holds metadata about all the known clusters.
    """
    owner = models.ForeignKey(User, db_index=True)
    address = models.CharField(max_length=128, unique=True)
    description = models.CharField(max_length=1024)

    class Meta:
        ordering = ["address"]

class ClusterInfo(object):
    
    def __init__(self, address):
        self.address = address
        
    def __getData(self, path):
        res = doRequest(self.address, url=path, headers=ACCEPT_JSON, status=200)
        if "body" in res: return res["body"]
        return None

    def __parse(self, data):
        if not data: return None
        json_data = json.loads(data)
        return json_data
        
    def getVersion(self):
        data = self.__getData("/version")
        return self.__parse(data)

    def getClusterVersion(self):
        data = self.__getData("/version/cluster")
        return self.__parse(data)

    def getClusterStatus(self):
        data = self.__getData("/status/cluster")
        return self.__parse(data)

    def getTables(self):
        data = self.__getData(None)
        json_data = self.__parse(data)
        if not json_data: return None
        return [ table["name"] for table in json_data["table"] ]
    
class TableScanner(object):

    def __init__(self, table_name, address, batch=1):
        self.table_name = table_name
        self.address = address
        self.batch = batch
        self.at_eot = False
        self.scanner_id = self.__openScanner()
        
    def __openScanner(self):
        body = "<Scanner batch=\"" + unicode(self.batch) + "\"/>"
        url = "/" + self.table_name + "/scanner"
        LOG.debug("openScanner: url %s" % url)
        res = doRequest(self.address, method="POST", url=url, headers=MIME_XML, body=body, status=201)
        # POST/PUT call returns a special header, e.g.
        #   Location: http://localhost:8000/content/scanner/12447063229213b1937
        loc = res["headers"]["location"]
        scanner_id = loc.rsplit("/", 1)[1]
        LOG.debug("openScanner: ID %s" % scanner_id)
        return scanner_id
            
    def __closeScanner(self, scanner_id):
        url = "/" + self.table_name + "/scanner/" + self.scanner_id
        LOG.debug("closeScanner: url %s" % url)
        res = doRequest(self.address, method="DELETE", url=url, headers=ACCEPT_JSON, status=200)
      
    def __getNextRows(self, scanner_id):
        url = url="/" + self.table_name + "/scanner/" + self.scanner_id
        LOG.debug("getNextRow: url %s" % url)
        res = doRequest(self.address, url=url, headers=ACCEPT_JSON)
        if res["status"] == 204: self.at_eot = True
        return res["body"]
        
    def close(self):
        self.__closeScanner(self.scanner_id)
        
    def next(self):
        return self.__getNextRows(self.scanner_id)
    
    def at_eof(self):
        return self.at_eot