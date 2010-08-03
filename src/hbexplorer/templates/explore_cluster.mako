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

${shared.header("HBase Explorer")}
</div>
<div id="hbexplorer_explorer" class="view">
  <div class="hbexplorer_explorer_wrapper splitview">
    <div class="hbexplorer_explorer_left left_col jframe_padded">
      <p>Cluster: ${clusterid}</p>
      <p>Available tables:</p>
      % if tables:
        % for table in cluster_info.getTables():
        <p><a class="hbexplorer_link_table" href="/hbexplorer/explore/${table}">${table}</a></p>
        % endfor
      % else:
        none   
      % endif
      <p><a data-splitview-resize="{'left':0}" title="hide help" class="hbexplorer-link-img hidehelp frame_tip">Hide</a>
      <a data-splitview-resize="{'left':0}">hide help</a></p>
    </div>
    <div class="hbexplorer_explorer_right right_col jframe_padded">
      <p>Cluster Version: ${cluster_info.getClusterVersion()}</p>
      <p>Version: <div style="margin-left: 20px"><code><ul>
      % for key, value in cluster_info.getVersion().iteritems():
       <li>${key}: ${value}</li>
      %endfor
      </ul></code></div>
      </p>
      <p>Cluster Status: <div style="margin-left: 20px"><code><ul>
      <% cluster_status = cluster_info.getClusterStatus() %>
      % for key, value in cluster_status.iteritems():
        % if key not in ("LiveNodes", "DeadNodes"):
       <li>${key}: ${value}</li>
        % endif
      %endfor
      <li>Live Nodes: <div style="margin-left: 40px"><code><ul>
      % for node in cluster_status["LiveNodes"]:
       <li>${node["Node"]}: </li>
      % endfor
        </ul></code></div>
      </li>
      </ul></code></div>
      </p>
    </div>
  </div>
</div>
${shared.footer()}