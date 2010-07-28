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
import threading
from django import forms
from django.contrib.auth.models import User
from desktop.lib.django_util import render, MessageException
from django.core import urlresolvers
from hbexplorer.models import ClusterAddress

__users_lock = threading.Lock()

def list_clusters(request):
  return render('list_clusters.mako', request, dict(clusters=ClusterAddress.objects.all()))

def delete_cluster(request, clusterid):
  return render('list_clusters.mako', request, None)

"""
  if request.method == 'POST':
    try:
      user = User.objects.get(username=username)
      user.delete()
      # Send a flash message saying "deleted"?
      return list_users(request)
    except User.DoesNotExist:
      raise MessageException("User not found.")
  else:
    return render("confirm.mako",
      request,
      dict(path=request.path, title="Delete user?"))
"""

def edit_cluster(request, clusterid=None):
  return render('list_clusters.mako', request, None)

  """
  edit_cluster(request, clusterid = None) -> reply

  @type request:        HttpRequest
  @param request:       The request object
  @type clusterid:       string
  @param clusterid:      Default to None, when creating a new cluster entry
  """

  """
  if username is not None:
    instance = User.objects.get(username=username)
  else:
    instance = None

  if request.method == 'POST':
    form = UserChangeForm(request.POST, instance=instance)
    if form.is_valid(): # All validation rules pass
      #
      # Check for 3 more conditions:
      # (1) A user cannot inactivate oneself;
      # (2) Non-superuser cannot promote himself; and
      # (3) The last active superuser cannot demote/inactivate himself.
      #
      form_is_super = form.cleaned_data["is_superuser"]
      form_is_active = form.cleaned_data["is_active"]
      if request.user.username == username and not form_is_active:
        raise MessageException("You cannot make yourself inactive.")

      global __users_lock
      __users_lock.acquire()
      try:
        if form.instance.is_superuser:
          if not form_is_super or not form_is_active:
            # Is there any other active superuser left?
            all_active_su = User.objects.filter(is_superuser__exact = True,
                                                is_active__exact = True)
            num_active_su = all_active_su.count()
            assert num_active_su >= 1, "No active superuser configured"
            if num_active_su == 1:
              raise MessageException("You cannot remove the last active "
                                     "superuser from the configuration.")
        else:
          if form_is_super and not request.user.is_superuser:
            raise MessageException("You cannot make yourself a superuser.")

        # All ok
        form.save()
      finally:
        __users_lock.release()

      request.path = urlresolvers.reverse(list_users)
      return list_users(request)
  else:
    form = UserChangeForm(instance=instance)
  return render('edit_user.mako', request,
    dict(form=form, action=request.path, username=username))
  """