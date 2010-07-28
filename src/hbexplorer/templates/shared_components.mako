<%!
#declare imports here, for example:
#import datetime
%>

<%!
import datetime
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