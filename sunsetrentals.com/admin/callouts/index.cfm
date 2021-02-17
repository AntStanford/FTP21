<cfset page.title ="Callouts">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_callouts order by `sort`
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">�</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<cfif getinfo.recordcount gt 0>
  <div class="alert alert-info">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <strong>Drag 'n drop the arrows to update sort order</strong>
  </div>
</cfif>

<div class="alert alert-success" style="display:none" id="sortStatus">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <strong>Success!</strong> The sort order has been updated.
</div>

<!--- <p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p> --->

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">

    <table class="table">
       <tr>
         <th width="20">Sort</th>
         <th>Title</th>
         <th width="50"></th>

       </tr>
    </table>

    <ul id="sort-list">

    <cfoutput query="getinfo">

      <li id="listItem_#id#">

         <table class="table table-bordered table-striped">
            <tr>
              <td width="30"><i class="icon-resize-vertical"></i></td>
              <td>#title#</td>
              <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>

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