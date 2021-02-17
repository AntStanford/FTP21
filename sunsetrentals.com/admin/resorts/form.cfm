<cfset page.title ="Resorts">
<cfset uppicture = #ExpandPath('/images/properties')#>

<cfif isdefined('url.id')>

  <cfif isdefined('url.picId') and isdefined('url.picName')>

    <cffile action="delete" file="#uppicture#/#url.picName#">

    <cfquery dataSource="#application.dsn#">
      delete from photos where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.picid#">
    </cfquery>

  </cfif>

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_resorts where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

</cfif>

<cfinclude template="/admin/components/header.cfm">

<cfquery name="getStates" dataSource="#settings.bcdsn#">
	select * from states order by name_long
</cfquery>


<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this record or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.deletephoto') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Photo deleted!</strong> Continue editing this record or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.deletemap') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>PDF Map deleted!</strong> Continue editing this record or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Insert successful!</strong> Add another record or <a href="index.cfm">go back.</a>
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

            <div class="control-group">
					<label class="control-label">Name</label>
					<div class="controls">
						<input type="text" name="name" <cfif parameterexists(id)>value="#getinfo.name#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Slug</label>
					<div class="controls">
						<input type="text" name="slug" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
						<div class="help-block">(No spaces, underscores or special characters allowed; only hyphens only)</div>
					</div>
				</div>

        <cfquery name="getBuildingComplexes" dataSource="#settings.dsn#">
          select id,name from track_nodes
          where typeName = 'Complex'
          order by name
        </cfquery>
				<div class="control-group">
					<label class="control-label">Resort</label>
					<div class="controls">
						<select name="resort" style="width:200px">
              <option value=""></option>
							<cfloop query="getBuildingComplexes">
								<option value="#getBuildingComplexes.id#" <cfif parameterexists(id) and isdefined('getinfo.resort') and getinfo.resort eq getBuildingComplexes.id>selected="selected"</cfif>>#getBuildingComplexes.name#</option>
							</cfloop>
						</select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Address</label>
					<div class="controls">
						<input type="text" name="address" <cfif parameterexists(id)>value="#getinfo.address#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls">
						<input type="text" name="city" <cfif parameterexists(id)>value="#getinfo.city#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">State</label>
					<div class="controls">
						<select name="state" style="width:200px">
							<cfloop query="getStates">
								<option <cfif parameterexists(id) and getinfo.state eq getStates.name_long>selected="selected"</cfif>>#name_long#</option>
							</cfloop>
						</select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Zip</label>
					<div class="controls">
						<input type="text" name="zip" <cfif parameterexists(id)>value="#getinfo.zip#"</cfif>>
					</div>
				</div>


				<div class="control-group">
					<label class="control-label">Area</label>
					<div class="controls">
						<input type="text" name="area" <cfif parameterexists(id)>value="#getinfo.area#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Meta Title</label>
					<div class="controls">
						<input type="text" name="metaTitle" <cfif parameterexists(id)>value="#getinfo.metaTitle#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Meta Description</label>
					<div class="controls">
						<textarea name="metaDescription" class="mceNoEditor" style="height:100px"><cfif parameterexists(id)>#getinfo.metaDescription#</cfif></textarea>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<textarea name="description" id="txtContent"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>


					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Amenities</label>
					<div class="controls">
						<textarea name="amenities" style="height:100px"><cfif parameterexists(id)>#getinfo.amenities#</cfif></textarea>
						<br />(Separate amenities using a semi-colon)
					</div>
				</div>

               <div class="control-group">
                  <label class="control-label">Main Photo</label>
                  <div class="controls">
                  <div class="uploader" id="uniform-undefined">
                  <input type="file" size="19" name="mainphoto" style="opacity:0;">
                  <span class="filename">No file selected</span>
                  <span class="action">Choose File</span>
                  </div>
                  <cfif parameterexists(id) and len(getinfo.mainphoto)>
                  	<a href="/images/resorts/#getinfo.mainphoto#" target="_blank" class="btn btn-mini btn-success"><i class="icon-eye-open icon-white"></i> View Image</a>
                  	<a href="submit.cfm?resortID=#url.id#&delPhoto&photo=mainphoto" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete Image</a>
                  </cfif>
                  <div class="help-block">(This image will be used on the listing page)</div>
                  </div>
               </div>

               <div class="control-group">
                  <label class="control-label">PDF Map</label>
                  <div class="controls">
                  <div class="uploader" id="uniform-undefined">
                  <input type="file" size="19" name="pdfmap" style="opacity:0;">
                  <span class="filename">No file selected</span>
                  <span class="action">Choose File</span>
                  </div>
                  <cfif parameterexists(id) and len(getinfo.pdfmap)>
                  	<a href="/images/resorts/#getinfo.pdfmap#" target="_blank" class="btn btn-mini btn-success"><i class="icon-eye-open icon-white"></i> View PDF</a>
                  	<a href="submit.cfm?resortID=#url.id#&delMap&map=pdfmap" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete PDF</a>
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
