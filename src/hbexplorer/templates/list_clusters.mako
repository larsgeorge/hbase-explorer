##/**
## * Copyright 2007 The Apache Software Foundation
## *
## * Licensed to the Apache Software Foundation (ASF) under one
## * or more contributor license agreements.  See the NOTICE file
## * distributed with this work for additional information
## * regarding copyright ownership.  The ASF licenses this file
## * to you under the Apache License, Version 2.0 (the
## * "License"); you may not use this file except in compliance
## * with the License.  You may obtain a copy of the License at
## *
## *     http://www.apache.org/licenses/LICENSE-2.0
## *
## * Unless required by applicable law or agreed to in writing, software
## * distributed under the License is distributed on an "AS IS" BASIS,
## * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## * See the License for the specific language governing permissions and
## * limitations under the License.
## */
<%namespace name="shared" file="shared_components.mako" />

${shared.header("HBase Explorer")}
<div id="hbexplorer_clusterlist" class="view">
  <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
    <thead>
      <tr>
        <th>Cluster Address</th>
        <th colspan="2">Description</th>
      </tr>
    </thead>
    <tbody>
    % for cluster in clusters:
      <tr>
        <td>${cluster.address}</td>
        <td>${cluster.description}</td>
        <td>
          <a title="Edit ${cluster.address}" class="edit frame_tip" href="${ url('hbexplorer.views.edit_cluster', clusterid=cluster.address) }">Edit</a>
          <a title="Delete ${cluster.address}" class="delete frame_tip confirm_and_post" alt="Are you sure you want to delete ${cluster.address}?" href="${ url('hbexplorer.views.delete_cluster', clusterid=cluster.address) }">Delete</a>
        </td>
      </tr>
    % endfor
    </tbody>
  </table>
  <a class="hbexplorer_add_cluster" href="${ url('hbexplorer.views.edit_cluster') }">Add Cluster</a>
</div>
${shared.footer()}