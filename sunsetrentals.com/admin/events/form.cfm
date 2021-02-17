<cfif isdefined('url.id')>

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_eventcal where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

</cfif>


<cfset page.title ="Events">
<cfinclude template="/admin/components/header.cfm">


<cfoutput>

<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Update successful!</strong> Continue editing this event or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Success!</strong> Add another event or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.deletephoto')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Success!</strong> The photo was deleted.
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


      <form method="post" action="submit.cfm" class="form-horizontal" enctype="multipart/form-data">


      <div class="control-group">
				<label class="control-label">Title</label>
				<div class="controls">
          <input class="sluggable" maxlength="255" name="event_title" type="text" <cfif parameterexists(id)>value="#getinfo.event_title#"</cfif> />
        </div>
			</div>

         <div class="control-group">
            <label class="control-label">Start Date</label>
            <div class="controls">
               <input class="datepicker" maxlength="255" name="start_date" type="text" <cfif parameterexists(id)>value="#DateFormat(getinfo.start_date,'mm/dd/yyyy')#"</cfif> readonly/>
            </div>
         </div>

         <div class="control-group">
            <label class="control-label">End Date</label>
            <div class="controls">
               <input class="datepicker" maxlength="255" name="end_date" type="text" <cfif parameterexists(id)>value="#DateFormat(getinfo.end_date,'mm/dd/yyyy')#"</cfif> readonly/>
            </div>
         </div>


         <div class="control-group">
            <label class="control-label">Start Time</label>
            <div class="controls">
               <input type="text" name="time_start" <cfif parameterexists(id)>value="#getinfo.time_start#"</cfif>>
            </div>
         </div>

         <div class="control-group">
            <label class="control-label">End Time</label>
            <div class="controls">
               <input type="text" name="time_end" <cfif parameterexists(id)>value="#getinfo.time_end#"</cfif>>
            </div>
         </div>



         <div class="control-group">
            <label class="control-label">Location</label>
            <div class="controls">
               <input maxlength="255" name="event_location" type="text" <cfif parameterexists(id)>value="#getinfo.event_location#"</cfif> />
            </div>
         </div>


      <div class="control-group">
				<label class="control-label">Body</label>
				<div class="controls">

          <textarea id="live-editor" name="details_long" rows="4" cols="30">
             <cfif parameterexists(id)>#getinfo.details_long#</cfif>
          </textarea>


        </div>
			</div>



      <div class="control-group">
        <label class="control-label">Image Upload</label>
        <div class="controls">
          <input type="file" name="photo" />
          <span class="help-block">Image must be resized to 200px by 150px before uploaded; max file size is 200kb.</span>
        </div>
      </div>


			<cfif parameterexists(id) and len(getinfo.photo)>
          <div class="widget-box">
          <div class="widget-title">
          <span class="icon">
          <i class="icon-picture"></i>
          </span>
          <h5>Event Photo</h5>
          </div>
          <div class="widget-content">

          <ul class="thumbnails">

          <li class="span2">
            <img src="/images/events/#getinfo.photo#">
            <br /><br /><a href="submit.cfm?id=#id#&deletephoto" class="btn btn-danger" data-confirm="Are you sure you want to delete this photo?"><i class="icon-remove icon-white"></i> Delete</a>
          </li>

          </ul>

          </div>
          </div>
      </cfif>



		  <div class="form-actions">
          <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
        </div>

    </form>

  </div>

</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

