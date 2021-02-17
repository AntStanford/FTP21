<cfset page.title ="Multi-Upload Photo Gallery">
<cfset uppicture = '/images/gallery'>
<cfset module = 'photo'>

<cfquery name="getphotos" dataSource="#dsn#">
  select id,thefile from cms_assets where section = 'Gallery' order by sort
</cfquery>


<cfinclude template="/admin/components/header.cfm">
<link rel="stylesheet" href="jQuery-File-Upload/blueimp-gallery.min.css">
<link rel="stylesheet" href="jQuery-File-Upload/css/jquery.fileupload.css">
<style type="text/css">
   .files .preview img{width:100px}
</style>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="../index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.deletephoto')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Photo deleted!</strong>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Insert successful!</strong> Add another #module# or <a href="../index.cfm">go back.</a>
    </div>
  </cfif>


  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Upload Photos</h5>
    </div>
    <div class="widget-content">

      <!-- The file upload form used as target for the file upload widget -->
      <form id="fileupload" action="submit-multi.cfm" method="POST" enctype="multipart/form-data">
</cfoutput>

        <!-- Redirect browsers with JavaScript disabled to the origin page -->
        <noscript><input type="hidden" name="redirect" value="/backend/admin.cfm"></noscript>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->

        <div class="container">
	        <div class="row fileupload-buttonbar">
            <div class="col-lg-7" style="margin-left:24px">
              <div class="upload-buttons">
	              <!-- The fileinput-button span is used to style the file input field as button -->
	              <span class="btn btn-success fileinput-button">
	                <i class="glyphicon glyphicon-plus"></i>
	                <span>Add files...</span>
	                <input type="file" name="files[]" multiple>
	              </span>
	              <button type="submit" class="btn btn-primary start">
	                <i class="glyphicon glyphicon-upload"></i>
	                <span>Start upload</span>
	              </button>
	              <button type="reset" class="btn btn-warning cancel">
	                <i class="glyphicon glyphicon-ban-circle"></i>
	                <span>Cancel upload</span>
	              </button>
	              <cfoutput><a href="index.cfm" class="btn btn-info">Refresh Page</a></cfoutput>

	              <div class="alert alert-info" style="margin-top:20px">
                  After uploading images, click the 'Refesh Page' button
                </div>

	              <!-- The global file processing state -->
	              <span class="fileupload-process"></span>
              </div>
						</div>
            <!-- The global progress state -->
            <div class="col-lg-5 fileupload-progress fade">
              <!-- The global progress bar -->
              <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                  <div class="progress-bar progress-bar-success" style="width:0%;"></div>
              </div>
              <!-- The extended global progress state -->
              <div class="progress-extended">&nbsp;</div>
            </div>
	        </div>
	        <!-- The table listing the files available for upload/download -->
	        <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
        </div>
			</form>
    <br>

    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Notes</h3>
        </div>
        <div class="panel-body">
            <ul>
                <li>The maximum file size for uploads is <strong>5 MB</strong>.</li>
                <li>Only image files (<strong>JPG, GIF, PNG</strong>) are allowed.</li>
                <li>You can <strong>drag &amp; drop</strong> files from your desktop on this webpage.</li>

            </ul>
        </div>
    </div>
</div>
<!-- The blueimp Gallery widget -->
<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev"><</a>
    <a class="next">></a>
    <a class="close">x</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>
<!-- The template to display files available for upload -->

<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            <strong class="error text-danger"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" disabled>
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>Start</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <span class="preview">
                {% if (file.thumbnailUrl) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            <p class="name">
                {% if (file.url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
                {% } else { %}
                    <span>{%=file.name%}</span>
                {% } %}
            </p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
            {% if (file.deleteUrl) { %}
                <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>Delete</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } else { %}
                <!---
<button class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel</span>
                </button>
--->
            {% } %}
        </td>
    </tr>
{% } %}
</script>

      <cfoutput>
<cfif getphotos.recordcount gt 0>

  <div class="widget-box">
  	<div class="widget-title">
  		<span class="icon">
  			<i class="icon-picture"></i>
  		</span>
  		<h5>Uploaded Photos</h5>
  	</div>
  	<div class="widget-content">
  	   <cfif getphotos.recordcount gt 1>
      <a href="sort-list.cfm" class="btn btn-info">Click here to edit the sort order</a><br /><br />
      </cfif>
		<ul id="sort-list" class="thumbnails">
  		  <cfloop query="getphotos">
    			<li class="span2" id="li#id#" style="border:none">
    			 <a href="##modal#id#" role="button" class="thumbnail" data-toggle="modal"><div style="overflow:hidden !important;"><img src="#uppicture#/#thefile#"></div></a>
    		   <br /><a href="delete.cfm?photo=#thefile#&photoid=#getphotos.id#" class="btn btn-danger"><i class="icon-remove icon-white"></i> Delete</a>
    		  </li>
    		</cfloop>
  		</ul>

  	</div>
  </div>

  <!-- This is the image displayed in the modal -->

<cfloop query="getphotos">

  <div id="modal#id#" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modallbl#id#" aria-hidden="false">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="false">X</button>
      <h3 id="modallbl#id#">Image Preview</h3>
    </div>
    <div class="modal-body">
      <img src="#uppicture#/#thefile#" style="height:350px;">
    </div>
    <div class="modal-footer">
      <button class="btn" data-dismiss="modal" aria-hidden="false">Close</button>
    </div>
  </div>

</cfloop>



</cfif>





</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="jQuery-File-Upload/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="jQuery-File-Upload/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="jQuery-File-Upload/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="jQuery-File-Upload/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<script src="jQuery-File-Upload/bootstrap.min.js"></script>
<!-- blueimp Gallery script -->
<script src="jQuery-File-Upload/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="jQuery-File-Upload/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="jQuery-File-Upload/js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="jQuery-File-Upload/js/main.js"></script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="jQuery-File-Upload/js/cors/jquery.xdr-transport.js"></script>
<![endif]-->
