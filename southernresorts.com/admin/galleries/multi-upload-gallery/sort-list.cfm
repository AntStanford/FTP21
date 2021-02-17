<cfset page.title ="Multi-Upload Photo Gallery">
<cfset module = 'photo'>

<cfquery name="getphotos" dataSource="#dsn#">
   select id,thefile from cms_assets where section = 'Gallery' and galleryid = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"> order by sort
</cfquery>

<cfinclude template="/admin/components/header.cfm">
	
<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.deletephoto') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Photo deleted!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Insert successful!</strong> Add another #module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>
  
  <div class="alert alert-success" style="display:none" id="sortStatus">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <strong>Success!</strong> The sort order has been updated.
</div> 

<a href="/admin/galleries/multi-upload-gallery/index.cfm?id=#url.id#" class="btn btn-success"><i class="icon-chevron-left icon-white"></i> Go Back to Photos</a>     
  
<cfif getphotos.recordcount gt 0>

  <div class="widget-box">
  	<div class="widget-title">
  		<span class="icon">
  			<i class="icon-picture"></i>
  		</span>
  		<h5>Drag photos to change the order, this will save automatically.</h5>
  	</div>
  	<div class="widget-content">		
		<ul id="sort-list" class="thumbnails">
  		  <cfloop query="getphotos">
    			<li class="span2" id="#id#" style="border:none">
    			 <a href="javascript:;" role="button" class="thumbnail" data-toggle="modal"><img src="/images/gallery/#thefile#"></a> 
    		  </li>
    		</cfloop>
  		</ul>
  		
  	</div>
  </div>
   

</cfif>
  
  
  
  
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">


	<script type="text/javascript">

		$(document).ready(function() {

		//this handles the image sorting
		$("#sort-list").sortable({
		update: function(event, ui) {
		var sortOrder = $(this).sortable('toArray').toString();
		//alert(sortOrder);
		<cfoutput>$.get('sorter.cfm?id=#url.id#', {sortOrder:sortOrder});</cfoutput>
		$('#sortStatus').css('display','block');
		}
		});

		});

	</script>
