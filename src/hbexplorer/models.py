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
import base64

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

    def __init__(self, table_name, address, startRow=None, endRow=None, batch=1, startTime=None, endTime=None):
        """
        Creates a new instance.
        
        See http://wiki.apache.org/hadoop/Hbase/Stargate for reference:
        <complexType name="Scanner">
            <sequence>
                <element name="column" type="base64Binary" minOccurs="0" maxOccurs="unbounded"></element>
            </sequence>
            <sequence>
                <element name="filter" type="string" minOccurs="0" maxOccurs="1"></element>
            </sequence>
            <attribute name="startRow" type="base64Binary"></attribute>
            <attribute name="endRow" type="base64Binary"></attribute>
            <attribute name="batch" type="int"></attribute>
            <attribute name="startTime" type="int"></attribute>
            <attribute name="endTime" type="int"></attribute>
        </complexType>    
        """
        self.table_name = table_name
        self.address = address
        self.startRow = startRow
        self.endRow = endRow
        self.batch = batch
        self.startTime = startRow
        self.endTime = endTime
        self.at_eot = False
        self.scanner_id = self.__openScanner()
            
    def __createScannerBody(self):
        body = "<Scanner batch=\"" + unicode(self.batch) + "\""
        if self.startRow: body += " startRow=\"" + base64.b64encode(self.startRow) + "\""
        if self.endRow: body += " endRow=\"" + base64.b64encode(self.endRow) + "\""
        if self.startTime: body += " startTime=\"" + unicode(self.startTime) + "\""
        if self.endTime: body += " endTime=\"" + unicode(self.endTime) + "\""
        body += ">"
        return body
    
    def __openScanner(self):
        body = self.__createScannerBody()
        LOG.debug("openScanner: body -> %s" % body)
        url = "/" + self.table_name + "/scanner"
        LOG.debug("openScanner: url -> %s" % url)
        res = doRequest(self.address, method="POST", url=url, headers=MIME_XML, body=body, status=201)
        # POST/PUT call returns a special header, e.g.
        #   Location: http://localhost:8000/content/scanner/12447063229213b1937
        loc = res["headers"]["location"]
        scanner_id = loc.rsplit("/", 1)[1]
        LOG.debug("openScanner: ID -> %s" % scanner_id)
        return scanner_id
            
    def __closeScanner(self, scanner_id):
        url = "/" + self.table_name + "/scanner/" + self.scanner_id
        LOG.debug("closeScanner: url -> %s" % url)
        res = doRequest(self.address, method="DELETE", url=url, headers=ACCEPT_JSON, status=200)
      
    def __getNextRows(self, scanner_id):
        url = url="/" + self.table_name + "/scanner/" + self.scanner_id
        LOG.debug("getNextRow: url -> %s" % url)
        res = doRequest(self.address, url=url, headers=ACCEPT_JSON)
        if res["status"] == 204: self.at_eot = True
        return res["body"]
        
    def close(self):
        self.__closeScanner(self.scanner_id)
        
    def next(self):
        return self.__getNextRows(self.scanner_id)
    
    def at_eof(self):
        return self.at_eot
    
class ClusterAddress(models.Model):
    """
    Holds metadata about all the known clusters.
    """
    owner = models.ForeignKey(User, db_index=True)
    address = models.CharField(max_length=128, unique=True)
    description = models.CharField(max_length=1024)

    class Meta:
        ordering = ["address"]

class SavedScan(models.Model):
    """
    Stores the scans that people have saved or submitted.
    """
    DEFAULT_NEW_SCAN_NAME = 'My saved scan'
    AUTO_DESIGN_SUFFIX = ' (new)'

    owner = models.ForeignKey(User, db_index=True)
    startRow = models.CharField(max_length=1024)
    endRow = models.CharField(max_length=1024)
    batch = models.IntegerField()
    startTime = models.CharField(max_length=16)
    endTime = models.CharField(max_length=16)
    description = models.TextField(max_length=1024)
    # An auto design is a place-holder for things users submit but not saved.
    # We still want to store it as a scan to allow users to save them later.
    is_auto = models.BooleanField(default=False, db_index=True)
    mtime = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-mtime']

    def clone(self):
        """clone() -> A new SavedScan with a deep copy of the same data"""
        scan = SavedScan(type=self.type, owner=self.owner)
        scan.startRow = copy.deepcopy(self.startRow)
        scan.endRow = copy.deepcopy(self.endRow)
        scan.batch = copy.deepcopy(self.batch)
        scan.startTime = copy.deepcopy(self.startTime)
        scan.endTime = copy.deepcopy(self.endTime)
        scan.description = copy.deepcopy(self.decription)
        scan.is_auto = copy.deepcopy(self.is_auto)
        return scan

    @staticmethod
    def get(id, owner=None):
        """
        get(id, owner=None) -> SavedScan object
    
        Checks that the owner matches (when given).
        May raise PopupException (owner mismatch).
        May raise SavedScan.DoesNotExist.
        """
        try:
          scan = SavedScan.objects.get(id=id)
        except SavedScan.DoesNotExist, err:
          msg = 'Cannot retrieve scan id %s' % (id,)
          raise err
    
        if owner is not None and design.owner != owner:
          msg = 'Scan id %s does not belong to user %s' % (id, owner)
          LOG.error(msg)
          raise PopupException(msg)
    
        return scan