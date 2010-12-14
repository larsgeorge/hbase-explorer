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

${shared.header(address + " :: " + tablename)}
</div>
<div id="hbx_table" class="view">
  <div class="hbx_table_wrapper splitview">
    <div class="hbx_table_left left_col jframe_padded">
      <p><b>Table Browser</b></p>
      <p class="version"><u>Version:</u> HBase ${shared.render_json(cluster_info.getClusterVersion())} 
      <div class="ccs-info_text">${shared.render_json(cluster_info.getVersion())}</div></p>
      <p>Navigate through the table data. To do: Scan specific areas, search for a start row etc.</p>
    </div>
    <div class="hbx_table_right right_col jframe_padded">
      <div class="ccs-tab_ui">
        <ul class="ccs-tabs clearfix">
            <li><span>Data</span></li>
            <li><span>Schema</span></li>
            <li><span>Regions</span></li>
        </ul>
        <ul class="ccs-tab_sections" style="border-top: 1px solid #999; padding: 10px">
          <li>
            % if rows:
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
                   href="${ url('hbexplorer.views.explore_table', clusterid=address, tablename=table) }">${table}</a>
              </td>
              <td>
                <a title="Edit ${table}" class="hbx_link_img edit frame_tip" 
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
          </li>
          <li>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>
${shared.footer()}