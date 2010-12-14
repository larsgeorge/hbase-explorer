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

${shared.header('Tables for ' + clusterid, section='tables')}
  <% tables = cluster_info.getTables() %>
  % if tables:
  <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
  <thead>
    <tr>
    <th colspan="2">Name</th>
    </tr>
  </thead>
  <tbody>
    % for table in tables:
    <tr>
    <td>
      <a class="hbx_link_entry" target="HBaseExplorer" 
         href="${ url('hbexplorer.views.explore_table', clusterid=clusterid, tablename=table) }">${table}</a>
    </td>
    <td>
      ##<a title="Edit scan for ${table}" class="hbx_link_img edit frame_tip" 
      ##   href="${ url('hbexplorer.views.edit_scan', clusterid=address, tablename=table) }">Edit</a>
      ##<a title="Open full scan for ${table}" class="hbx_link_img open frame_tip" 
      ##   href="${ url('hbexplorer.views.execute_scan', clusterid=address, tablename=table) }">Open</a>
    </td>
    </tr>
    % endfor
  </tbody>
  </table>
  % else:
      none   
  % endif
${shared.footer()}
