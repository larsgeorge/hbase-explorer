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
      <p><a data-splitview-resize="{'left':0}">hide help</a></p>
    </div>
    <div class="hbexplorer_explorer_right right_col jframe_padded">
      TBD.
    </div>
  </div>
</div>
${shared.footer()}