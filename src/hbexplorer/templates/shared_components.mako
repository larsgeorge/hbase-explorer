<%!
from django.template.defaultfilters import urlencode, escape
%>

<%!
def is_selected(section, matcher):
  if section == matcher:
    return "selected"
  else:
    return ""
%>

<%def name="header(title='HBase Explorer', toolbar=True, section=False, search_entry=False)">
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <title>${title}</title>
  </head>
  <body>
    % if toolbar:
    <div class="toolbar">
      <a href="${url('hbexplorer.views.list_clusters')}"><img class="hbx_icon" src="/hbexplorer/static/art/hbexplorer.png"/></a>
      % if search_entry:
        <div class="hbx_tb_actions">
        <input type="text" class="hbx_search_entry"
          data-filters="OverText, ArtInput, FilterInput"
          data-art-input-type="search" title="Filter by Address"
          data-filter-elements="a.hbx_link_entry" data-filter-parents="tr"/>
        </div>
      % endif
      % if section:
        <ul class="hbx_nav" data-filters="ArtButtonBar">
          <li><a href="${ url('hbexplorer.views.edit_scan', clusterid=clusterid) }" 
            class="hbx_nav_icon hbx_query_nav ${is_selected(section, 'scan')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">Scan Editor</a></li>
          <li><a href="${ url('hbexplorer.views.list_user_scans', clusterid=clusterid) }"
            class="hbx_nav_icon hbx_my_queries_nav ${is_selected(section, 'my scans')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">My Scans</a></li>
          <li><a href="${ url('hbexplorer.views.list_saved_scans', clusterid=clusterid) }" 
            class="hbx_nav_icon hbx_queries_nav ${is_selected(section, 'saved scans')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">Saved Scans</a></li>
          <li><a href="${ url('hbexplorer.views.list_scan_history', clusterid=clusterid) }" 
            class="hbx_nav_icon hbx_history_nav ${is_selected(section, 'history')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">History</a></li>
          <li><a href="${ url('hbexplorer.views.list_tables', clusterid=clusterid) }" 
            class="hbx_nav_icon hbx_tables_nav ${is_selected(section, 'tables')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">Tables</a></li>
          <li><a href="${ url('hbexplorer.views.show_cluster_info', clusterid=clusterid) }" 
            class="hbx_nav_icon hbx_config_nav ${is_selected(section, 'info')}" data-filters="ArtButton"
            data-icon-styles="{'width': 16, 'height': 16, 'top': 4, 'left': 5}">Info</a>
          </li>
          <li><a class="ccs-refresh large" data-filters="ArtButton">Refresh</a></li>
        </ul>
      % endif
    </div>
    % endif
</%def>

<%def name="footer()">
  </body>
</html>
</%def>

<%def name="render_field(field, hidden=False, notitle=False)">
<%
  cls = ""
  if hidden: 
    cls = "ccs-hidden"
  titlecls = ""
  if notitle or hidden:
    titlecls = "ccs-hidden"
%>
  <dt class="${titlecls}">${field.label_tag() | n}</dt>
  <dd class="${cls}">${str(field) | n}</dd>
  % if len(field.errors):
    <dt>&nbsp;</dt>
    <dd class="ccs-error validation-advice">
       ${str(field.errors) | n}
     </dd>
  % endif
</%def>

<%def name="render_json(json, indent=0, increment=15)">
  % if type(json) in (list, tuple):
    % for item in json:
      ${render_json(item, indent + increment, increment)}
    % endfor
  % elif type(json) is dict:
    <ul class="indent_${indent}">
    % for key, value in json.iteritems():
      <li>${key}: ${render_json(value)}</li>
    % endfor
    </ul>
  % else:
    ${json}
  % endif
</%def>

<%def name="render_nodes(nodeslist)">
  % for nodes in nodeslist:
    % if nodes:
      % for name, node in nodes.iteritems(): 
  <h3>Name: ${node["name"]}</h3>
  <p>
  <table data-filters="HtmlTable" class="sortable" cellpadding="0" cellspacing="0">
  <tr><td width="150">Start Code:</td><td>${node["startCode"]}</td></tr>
  <tr><td>Max Heap Size:</td><td>${node["maxHeapSizeMB"]} MB</td></tr>
  <tr><td>Requests:</td><td>${node["requests"]}</td></tr>
  </table>
  </p>
  <u>Regions</u>
        % for region in node["Region"]:
  <p>
  <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
  <tr><td width="150">Name:</td><td>${region["name"]}</td></tr>
  <tr><td>Memstore Size:</td><td>${region["memstoreSizeMB"]} MB</td></tr>
  <tr><td>Stores:</td><td>${region["stores"]}</td></tr>
  <tr><td>Store Files:</td><td>${region["storefiles"]}</td></tr>
  <tr><td>Store File Size:</td><td>${region["storefileSizeMB"]} MB</td></tr>
  <tr><td>Store File Index Size:</td><td>${region["storefileIndexSizeMB"]}</td></tr>
  </table>
  </p>
        % endfor
      % endfor
    % else:
    <p>None</p>
    % endif
  % endfor
</%def>
