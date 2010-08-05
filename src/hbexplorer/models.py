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

LOG = logging.getLogger(__name__)
JSON = {"Accept":"application/json"}
    
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
    
    def __init__(self, clusterid):
        self.cluster_id = clusterid
        
    def __getData(self, path):
        conn = None
        try:
            conn = httplib.HTTPConnection(self.cluster_id, timeout=30)
            conn.request("GET", url=path, headers=JSON)
            response = conn.getresponse()
            assert(response.status == 200)
            data = response.read()
        except httplib.HTTPException, e:
           raise httplib.HTTPException("HTTP error: %d" % e.code)
        finally:
            if conn: conn.close();
        return data

    def getVersion(self):
        data = self.__getData("/version")
        json_data = json.loads(data)
        return json_data

    def getClusterVersion(self):
        data = self.__getData("/version/cluster")
        json_data = json.loads(data)
        return json_data

    def getClusterStatus(self):
        data = self.__getData("/status/cluster")
        json_data = json.loads(data)
        return json_data

    def getTables(self):
        data = self.__getData(None)
        json_data = json.loads(data)
        return [ table["name"] for table in json_data["table"] ]
    
class TableScanner(object):

    def __init__(self, table_name, cluster_id):
        self.table_name = table_name
        self.cluster_id = cluster_id
        self.at_eot = False
        self.scanner_id = self.__openScanner()
        
    def __openScanner(self):
        header = {"Content-Type": "text/xml"}
        body = "<Scanner batch=\"1\"/>"
        conn = None
        try:
            conn = httplib.HTTPConnection(self.cluster_id, timeout=30)
            conn.request("POST", "/" + self.table_name + "/scanner", body, header)
            response = conn.getresponse()
            assert(response.status == 201)
        except httplib.HTTPException, e:
           raise httplib.HTTPException("HTTP error: %d" % e.code)
        finally:
            if conn: conn.close();
        # POST/PUT call returns a special header, e.g.
        #   Location: http://localhost:8000/content/scanner/12447063229213b1937
        loc = response.getheader("Location")
        scanner_id = loc.rsplit("/", 1)[1]
        LOG.debug("openScanner: ID %s" % scanner_id)
        return scanner_id
            
    def __closeScanner(self, scanner_id):
        conn = None
        try:
            url = "/" + self.table_name + "/scanner/" + self.scanner_id
            LOG.debug("closeScanner: url %s" % url)
            conn = httplib.HTTPConnection(self.cluster_id, timeout=30)
            conn.request("DELETE", url=url, headers=JSON)
            response = conn.getresponse()
            assert(response.status == 200)
        except httplib.HTTPException, e:
           raise httplib.HTTPException("HTTP error: %d" % e.code)
        finally:
            if conn: conn.close();
      
    def __getNextRow(self, scanner_id):
        conn = None
        try:
            url = url="/" + self.table_name + "/scanner/" + self.scanner_id
            LOG.debug("getNextRow: url %s" % url)
            conn = httplib.HTTPConnection(self.cluster_id, timeout=30)
            conn.request("GET", url=url, headers=JSON)
            response = conn.getresponse()
            #assert(response.status == 200)
            if response.status == 204: self.at_eot = True
            data = response.read()
        except httplib.HTTPException, e:
           raise httplib.HTTPException("HTTP error: %d" % e.code)
        finally:
            if conn: conn.close();
        return data
        
    def close(self):
        self.__closeScanner(self.scanner_id)
        
    def next(self):
        return self.__getNextRow(self.scanner_id)
    
    def at_eof(self):
        return self.at_eot