<%namespace name="shared" file="shared_components.mako" />

${shared.header("HBase Explorer")}

## use double hashes for a mako template comment

## this id in the div below ("index") is stripped by CCS.JFrame
## and passed along as the "view" argument in its onLoad event

## the class 'jframe_padded' will give the contents of your window a standard padding
<div id="index" class="view jframe_padded">
  <h2>Hbexplorer app is successfully setup!</h2>
  <p>It's now ${date}.</p>
</div>
${shared.footer()}