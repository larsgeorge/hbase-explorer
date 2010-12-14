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

${shared.header('Edit Scan for ' + clusterid, section='scan')}
<form action="${action}" method="POST" enctype="multipart/form-data">
  <dl>
    ##${shared.render_field(form["startRow"])}
    ##${shared.render_field(form["endRow"])}
    ##${shared.render_field(form["batch"])}
    ##${shared.render_field(form["startTime"])}
    ##${shared.render_field(form["endTime"])}
  </dl>
  <input class="ccs-hidden" type="submit" value="Submit" />
</form>  
${shared.footer()}
