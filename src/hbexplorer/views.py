#!/usr/bin/env python
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

"""
HBase Explorer application.
"""

import django
from django import forms
from django.contrib.auth.models import User
from desktop.lib.django_util import render, MessageException
from django.core import urlresolvers
from hbexplorer.models import ClusterAddress, ClusterInfo, TableScanner
from hbexplorer.forms import ClusterEntryForm

# List Clusters Window

def list_clusters(request):
    return render('list_clusters.mako', request, dict(clusters=ClusterAddress.objects.all()))

def edit_cluster(request, clusterid=None):
    if clusterid is not None:
        instance = ClusterAddress.objects.get(address=clusterid)
    else:
        instance = None

    if request.method == 'POST':
        form_dict = request.POST.copy()
        form_dict["owner"] = request.user.id
        form = ClusterEntryForm(form_dict, instance=instance)
        #if form.is_valid(): # All validation rules pass
        form.save()
        request.path = urlresolvers.reverse(list_clusters)
        return list_clusters(request)
    else:
        form = ClusterEntryForm(instance=instance)
    return render("edit_cluster.mako", request,
        dict(form=form, action=request.path, clusterid=clusterid))

def delete_cluster(request, clusterid):
    if request.method == 'POST':
        try:
            entry = ClusterAddress.objects.get(address=clusterid)
            entry.delete()
            # Send a flash message saying "deleted"?
            return list_clusters(request)
        except ClusterAddress.DoesNotExist:
            raise MessageException("Entry not found.")
    else:
        return render("confirm.mako", request,
        dict(path=request.path, title="Delete Cluster Entry?"))

# Explore Cluster Window(s)

def edit_scan(request, clusterid, scanid=None, tablename=None):
    return render('edit_scan.mako', request, dict(action=request.path, clusterid=clusterid, scanid=scanid, tablename=tablename))

def list_user_scans(request, clusterid):
    return render('show_cluster_info.mako', request, dict(clusterid=clusterid))

def list_saved_scans(request, clusterid):
    return render('show_cluster_info.mako', request, dict(clusterid=clusterid))

def list_scan_history(request, clusterid):
    return render('show_cluster_info.mako', request, dict(clusterid=clusterid))

def list_tables(request, clusterid):
    cluster_info = ClusterInfo(address=clusterid)
    return render('list_tables.mako', request, dict(clusterid=clusterid, cluster_info=cluster_info))

def execute_scan(request, clusterid, scanid):
    cluster_info = ClusterInfo(address=clusterid)
    return render('show_cluster_info.mako', request, dict(clusterid=clusterid, cluster_info=cluster_info))

def explore_table(request, clusterid, tablename):
    scanner = TableScanner(tablename, clusterid, batch=20)
    rows = scanner.next()
    scanner.close()
    cluster_info = ClusterInfo(address=clusterid)
    return render('explore_table.mako', request, 
                  dict(address=clusterid, tablename=tablename, cluster_info=cluster_info, rows=rows))

def show_cluster_info(request, clusterid):
    cluster_info = ClusterInfo(address=clusterid)
    return render('show_cluster_info.mako', request, dict(clusterid=clusterid, cluster_info=cluster_info))

