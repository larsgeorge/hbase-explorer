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
## *   http://www.apache.org/licenses/LICENSE-2.0
## *
## * Unless required by applicable law or agreed to in writing, software
## * distributed under the License is distributed on an "AS IS" BASIS,
## * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## * See the License for the specific language governing permissions and
## * limitations under the License.
## */
<%namespace name="shared" file="shared_components.mako" />

${shared.header(address)}
</div>
<div id="hbexplorer_cluster" class="view">
  <div class="hbexplorer_cluster_wrapper splitview">
    <div class="hbexplorer_cluster_left left_col jframe_padded">
      <p><b>Cluster Browser</b></p>
      <p class="version">Version: HBase ${shared.render_json(cluster_info.getClusterVersion())} 
      <div class="ccs-info_text">${shared.render_json(cluster_info.getVersion())}</div></p>
      <p>The first tab on the right shows the list of available tables. Click on the tabkle name to open a new
         window where you can browse its data or see its schema. You can open more than one table window if you like.</p>
      <p>The second tab displays the cluster status. This includes the various nodes of the cluster and what regions
         they host.</p>
    </div>
    <div class="hbexplorer_cluster_right right_col jframe_padded">
      <div class="ccs-tab_ui">
        <ul class="ccs-tabs clearfix">
            <li><span>Tables</span></li>
            <li><span>Status</span></li>
        </ul>
        <ul class="ccs-tab_sections" style="border-top: 1px solid #999; padding: 10px">
          <li>
            <p><h3>Available Tables</h3>
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
                <a class="hbexplorer_link_entry" target="HBaseExplorer" 
                   href="${ url('hbexplorer.views.explore_table', clusterid=address, tablename=table) }">${table}</a>
              </td>
              <td>
                <a title="Edit ${table}" class="hbexplorer-link-img edit frame_tip" 
                   href="${ url('hbexplorer.views.edit_table', clusterid=address, tablename=table) }">Edit</a>
              </td>
              </tr>
              % endfor
            </tbody>
            </table>
            % else:
                none   
            % endif
            </p>
          </li>
          <li>
            <% status = cluster_info.getClusterStatus() %>
            <h3>Summary</h3>
            <p>
              <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
              <tr><td>Requests:</td><td>${status["requests"]}</td></tr>
              <tr><td>Average Load:</td><td>${status["averageLoad"]}</td></tr>
              <tr><td>Regions:</td><td>${status["regions"]}</td></tr>
              </table>
            </p>
            <h3>Live Nodes</h3>
            <p>
              % for nodes in status["LiveNodes"]:
                % for name, node in nodes.iteritems(): 
              <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
              <tr><td><div style="float: left; margin-right: 50px">Name:</div></td><td>${node["name"]}</td></tr>
              <tr><td>Start Code:</td><td>${node["startCode"]}</td></tr>
              <tr><td>Max Heap Size:</td><td>${node["maxHeapSizeMB"]} MB</td></tr>
              <tr><td>Requests:</td><td>${node["requests"]}</td></tr>
              </table>
              <h4 style="margin-left: 50px">Regions</h4>
                  % for region in node["Region"]:
              <table style="margin-left: 50px" class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
              <tr><td><div style="float: left; margin-right: 50px">Name:</div></td><td>${region["name"]}</td></tr>
              <tr><td>Memstore Size:</td><td>${region["memstoreSizeMB"]} MB</td></tr>
              <tr><td>Stores:</td><td>${region["stores"]}</td></tr>
              <tr><td>Store Files:</td><td>${region["storefiles"]}</td></tr>
              <tr><td>Store File Size:</td><td>${region["storefileSizeMB"]} MB</td></tr>
              <tr><td>Store File Index Size:</td><td>${region["storefileIndexSizeMB"]}</td></tr>
              </table>
                  % endfor
                % endfor
              % endfor
            </p>
            <h3>Dead Nodes</h3>
            <p>Dump: ${shared.render_json(status["DeadNodes"])}</p>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>
${shared.footer()}