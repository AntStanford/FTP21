<cfset page.title ="Manage Your Amenities">

<cfquery name="getinfo" dataSource="#dsn#">
  select * from cms_amenities order by sort
</cfquery>

<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>The amenity has been updated.</strong>
  </div>
</cfif>

<cfif isdefined('url.delete')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Review deleted</strong>
  </div>
</cfif>

<cfif settings.booking.pms eq 'Homeaway'>
   
   <cfif settings.booking.v12Client eq 'Yes'>
    <cfset pmsForm = 'form-homeaway-v12.cfm'>
   <cfelse>
    <cfset pmsForm = 'form-homeaway.cfm'>
   </cfif>   

<cfelseif settings.booking.pms eq 'Barefoot'>
  <cfset pmsForm = 'form-barefoot.cfm'>
<cfelseif settings.booking.pms eq 'Escapia'>
  <cfset pmsForm = 'form-escapia.cfm'>
<cfelseif settings.booking.pms eq 'Track'>
	<cfset pmsForm = 'form-track.cfm'>
</cfif>  

<p><a href="<cfoutput>#pmsForm#</cfoutput>" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>  
    <h5><cfoutput>#page.title#</cfoutput></h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
      <tr>
        <th width="41"></th>
        <!--- <th>No.</th> --->
        <th width="300">Name</th>
        <th>Category</th>
        <th></th>          
        <th></th>
      </tr>  
    </table>

    <ul id="sort-list">      
      <cfoutput query="getinfo">
        <li id="listItem_#id#">
          <table class="table table-bordered table-striped">
            <tr>
              <td width="45"><i class="icon-resize-vertical"></i></td>
              <!--- <td width="45">#currentrow#.</td> --->
              <td width="300">#title#</td> 
              <td>#category#</td>
              <td width="50"><a href="#pmsForm#?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>          
              <td width="70"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this amenity?"><i class="icon-trash icon-white"></i> Delete</a></td>      
            </tr>
          </table>
        </li>
      </cfoutput>
    </table>
  </div>
</div>

<cfinclude template="/admin/components/footer.cfm">

<script type="text/javascript">
  $(document).ready(function() {
    $("#sort-list").sortable({
      update: function(event, ui) {
        var sortOrder = $(this).sortable('toArray').toString();
        $.get('sorter.cfm', {sortOrder:sortOrder});
        $('#sortStatus').css('display','block');
      }
    });
  });
</script>