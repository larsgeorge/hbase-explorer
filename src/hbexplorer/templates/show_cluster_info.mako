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

${shared.header('Info for ' + clusterid, section='info')}
  <div data-filters="Tabs">
    <ul class="toolbar tabs" style="position: absolute; top:69px; left: 80px;">
        <li><span>Version</span></li>
        <li><span>Status</span></li>
    </ul>
    <ul class="tab_sections ccs-clear" style="border-top: 1px solid #999; padding: 10px">
      <li>
        <h2>Version</h2>
        <p><br/>HBase ${shared.render_json(cluster_info.getClusterVersion())} 
        ${shared.render_json(cluster_info.getVersion())}</p>    
      </li>
      <li>
        <% status = cluster_info.getClusterStatus() %>
        <h2>Summary</h2>
        <p>
          <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
          <tr><td  width="150">Requests:</td><td>${status["requests"]}</td></tr>
          <tr><td>Average Load:</td><td>${status["averageLoad"]}</td></tr>
          <tr><td>Regions:</td><td>${status["regions"]}</td></tr>
          </table>
        </p>
        <h2>Live Nodes</h2><br/>
          ${shared.render_nodes(status["LiveNodes"])}
        <h2>Dead Nodes</h2>
        <p>
          ${shared.render_nodes(status["DeadNodes"])}
        </p>
      </li>
    </ul>
  </div>    
${shared.footer()}
