<cfset page.title ="Specials">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_specials order by sort,startdate
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table">
      <tr>
        <th width="20">Sort</th>
        <th width="45">No.</th>
        <th width="30">Active</th>
        <th>Title</th>
        <th width="100">Start Date</th>
        <th width="100">End Date</th>
        <th width="80"></th>     
        <th width="50"></th> 
        <th width="65"></th>  
      </tr>       
    </table> 
   <ul id="sort-list">
      <cfoutput query="getinfo">
        <li id="listItem_#id#">
          <table class="table table-bordered table-striped">
            <tr>
              <td width="30"><i class="icon-resize-vertical"></i></td>
              <td width="45">#currentrow#.</td>
              <td width="30">#active#</td>
              <td>#title#</td>   
              <td width="100">#DateFormat(startdate,'mm/dd/yyyy')#</td>            
              <td width="100">#DateFormat(enddate,'mm/dd/yyyy')#</td>
              <td width="80"><a href="properties/index.cfm?specialid=#id#" class="btn btn-mini btn-warning"><i class="icon-home icon-white"></i> Properties</a></td>
              <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
              <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this special?"><i class="icon-remove icon-white"></i> Delete</a></td>         
            </tr>
          </table>
        </li>
      </cfoutput>
    </ul>
  </div>
</div>
</cfif>

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
