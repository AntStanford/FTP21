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


      <form method="post" action="submit.cfm" class="form-horizontal validate" enctype="multipart/form-data" id="frmEvent">


      <div class="control-group">
        <label class="control-label">Title</label>
        <div class="controls">
          <input class="sluggable required" maxlength="255" name="event_title" type="text" <cfif parameterexists(id)>value="#getinfo.event_title#"</cfif> />
        </div>
      </div>

         <div class="control-group">
            <label class="control-label">Start Date</label>
            <div class="controls">
               <input maxlength="255" name="start_date" type="text" class="datepicker required" autocomplete="off" <cfif parameterexists(id)>value="#DateFormat(getinfo.start_date,'mm/dd/yyyy')#"</cfif> />
            </div>
         </div>

         <div class="control-group">
            <label class="control-label">End Date</label>
            <div class="controls">
               <input maxlength="255" name="end_date" type="text" class="datepicker required" autocomplete="off" <cfif parameterexists(id)>value="#DateFormat(getinfo.end_date,'mm/dd/yyyy')#"</cfif> />
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
            <label class="control-label">External Link</label>
            <div class="controls">
               <input maxlength="255" name="externallink" type="text" <cfif parameterexists(id)>value="#getinfo.externallink#"</cfif> /> 
            </div>
         </div>



         <div class="control-group">
            <label class="control-label">Location</label>
            <div class="controls">
               <input maxlength="255" name="event_location" type="text" <cfif parameterexists(id)>value="#getinfo.event_location#"</cfif> />
            </div>
         </div>

    <!---  <div class="control-group">
            <label class="control-label">Address</label>
            <div class="controls">
               <input maxlength="255" name="Address" type="text" <cfif parameterexists(id)>value="#getinfo.Address#"</cfif> />
            </div>
         </div>

     <div class="control-group">
            <label class="control-label">City</label>
            <div class="controls">
               <input maxlength="255" name="City" type="text" <cfif parameterexists(id)>value="#getinfo.City#"</cfif> />
            </div>
         </div>

     <div class="control-group">
            <label class="control-label">State</label>
            <div class="controls">
               <input maxlength="255" name="state" type="text" <cfif parameterexists(id)>value="#getinfo.state#"<cfelse>value="MD"</cfif> />
            </div>
         </div>

      <div class="control-group">
            <label class="control-label">Zip</label>
            <div class="controls">
               <input maxlength="255" name="Zip" type="text" <cfif parameterexists(id)>value="#getinfo.zip#"</cfif> />
            </div>
         </div> --->

<cfif (not parameterexists(id)) or (parameterexists(id) and getinfo.reocurringEventID is "")>
     <div class="control-group">
            <label class="control-label"></label>
            <div class="controls">
               Use below for recurring
            </div>
         </div>


     <div class="control-group">
            <label class="control-label">Recurring?</label>
            <div class="controls">
              <select name="reocurring" style="width: 100px;">
        <option value="No" <cfif isdefined('url.id') and getinfo.reocurring is "No">SELECTED</cfif>>No</option>
        <option value="Yes" <cfif isdefined('url.id') and getinfo.reocurring is "Yes">SELECTED</cfif>>Yes</option>
      </select>
            </div>
       </div>

     <div class="control-group">
            <label class="control-label">Occurrence?</label>
            <div class="controls">
              <select name="Occurance" style="width: 100px;">
        <option value="Daily" <cfif isdefined('url.id') and getinfo.Occurance is "Daily">SELECTED</cfif>>Daily</option>
        <option value="Weekly" <cfif isdefined('url.id') and getinfo.Occurance is "Weekly">SELECTED</cfif>>Weekly</option>
        <option value="Monthly" <cfif isdefined('url.id') and getinfo.Occurance is "Monthly">SELECTED</cfif>>Monthly</option>
      </select>
            </div>
         </div>

     <div class="control-group">
            <label class="control-label">How Many Total Occurences?</label>
            <div class="controls">
              <select name="HowManyTimes" style="width: 100px;">
        <cfloop index="i" from="1" to="100" step="1">
        <option value="#i#" <cfif isdefined('url.id') and getinfo.HowManyTimes is "#i#">SELECTED</cfif>>#i#</option>
        </cfloop>
      </select>
            </div>
         </div>
</cfif>

      <div class="control-group">
        <label class="control-label">Body</label>
        <div class="controls">

          <textarea id="live-editor" name="details_long" rows="4" cols="30"><cfif parameterexists(id)>#getinfo.details_long#</cfif></textarea>

        </div>
      </div>



      <div class="control-group">
        <label class="control-label">Image Upload</label>
        <div class="controls">
          <input type="file" name="photo" />
          <span class="help-block">Image must be resized to 200px by 150px before uploaded; max file size is 200kb.</span>
        </div>
      </div>
    
    <input type="hidden" name="original_photo" value="<cfif parameterexists(id)>#getinfo.photo#</cfif>">


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


      <cfif parameterexists(id) and getinfo.reocurringEventID is not "">
        <!--- Set hidden elements for update --->
        <input type="hidden" name="reocurring" value="Yes">
        <input type="hidden" name="Occurance" value="#getinfo.Occurance#">
        <input type="hidden" name="HowManyTimes" value="#getinfo.HowManyTimes#">

        <div class="control-group">
            <label class="control-label">This is a group event.<br />(recurring)</label>
            <div class="controls">
              <select name="GroupOrSingle" style="width: 300px;">
        <option value="All">Update All Events In This Group</option>
        <option value="One">Update Only This Event</option>
      </select>
            </div>
         </div>

    </cfif>


      <div class="form-actions">
          <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          <cfif parameterexists(id)>
            <input type="hidden" name="id" value="#url.id#">
      <cfif getinfo.reocurringEventID is not ""><input type="hidden" name="reocurringEventID" value="#getinfo.reocurringEventID#"></cfif>
          </cfif>
      </div>

    </form>

  </div>

</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

<style type="text/css">label.error{color:red !important;}</style>

<script>
  $(document).ready(function(){
    $("#frmEvent").validate();
  });
</script>