<cfset page.title ="Homepage Slideshow">
<cfset uppicture = #ExpandPath('/images/homeslideshow')#>
<cfset module = 'image'>

<cfif isdefined('url.id')>

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_assets where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

</cfif>


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


  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">



         <!-- Text input-->
        <div class="control-group">
          <label class="control-label" for="name">Name</label>
          <div class="controls">
            <input id="name" name="name" type="text" class="input-xlarge" <cfif parameterexists(id)>value="#getinfo.name#"</cfif>>
          </div>
        </div>

        <!-- Text input-->
        <div class="control-group">
          <label class="control-label" for="caption">Caption</label>
          <div class="controls">
            <input id="caption" name="caption" type="text" class="input-xlarge" <cfif parameterexists(id)>value="#getinfo.caption#"</cfif>>
          </div>
        </div>


         <!-- Text input-->
        <div class="control-group">
          <label class="control-label" for="link">Link</label>
          <div class="controls">
            <input id="link" name="link" type="text" class="input-xlarge" <cfif parameterexists(id)>value="#getinfo.link#"</cfif>>
          </div>
        </div>


          <div class="control-group">
            <label class="control-label">Image</label>
            <div class="controls">
              <div class="uploader" id="uniform-undefined" style="width:290px;">
                <input type="file" size="19" name="photo" id="fileName" style="opacity:0;">
                <span class="filename" style="width:182px;">No file selected</span>
                <span class="action">Choose File</span>
              </div>

              <span class="help-block">
                  <br />Please adhere to the following parameters to maintain optimal page load times:<br /><br />
                  Max width = 1800px<br />
                  6 image limit<br />
                  Image resolution must not exceed 72 pixels per inch<br />
                  Max file size is 300 kb
               </span>

              <cfif isdefined('url.id') and getinfo.thefile neq ''>
                <br /><br />Preview:<br /><img src="/images/homeslideshow/#getinfo.thefile#" style="width:50%">
              </cfif>

            </div>
          </div>






				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>

    </div>
  </div>








</cfoutput>

<cfinclude template="/admin/components/footer.cfm">