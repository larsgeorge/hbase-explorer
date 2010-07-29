<%!
from django.template.defaultfilters import urlencode, escape
%>

<%def name="header(title='HBase Explorer', toolbar=True)">
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body>
      % if toolbar:
      <div class="toolbar">
        <a href="${url('hbexplorer.views.list_clusters')}"><img src="/hbexplorer/static/art/hbexplorer.png" class="hbexplorer_icon"/></a>
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
