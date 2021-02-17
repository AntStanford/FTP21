<cfset page.title ="Pages">
<cfinclude template="/admin/components/header.cfm">

<style type="text/css">
  #loadingDiv {background: rgba(0,0,0,0.5); width: 100%; height: 100%; position: fixed !important; top: 0; right: 0; bottom: 0; left: 0; z-index: 999999;}
  #loadingDiv .loader {width: 120px; height: 120px; position: fixed; top: 0; right: 0; bottom: 0; left: 0; z-index: 999999; margin: auto;}
  .subsort {cursor: pointer;}
</style>

<div id="loadingDiv">
  <img src="/admin/images/circle-loading.gif" class="loader">
</div>

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_pages where parentID = 0 and showInAdmin = 'Yes' order by sort
</cfquery>

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
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

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>
    <h5><cfoutput>#page.title#</cfoutput></h5>
  </div>
  <div class="widget-content nopadding">
    <div class="table-wrap">
      <table class="table table-heading">
        <tr>
          <th width="30">Sort</th>
          <th width="200">Top Level Pages</th>
          <th>Sub Level Pages</th>
          <th width="90">In Navigation</th>
          <th width="60">Content</th>
          <th width="50"></th>
          <th width="65"></th>
          <th width="60"></th>
        </tr>
      </table>
      <ul id="sort-list">
        <cfoutput query="getinfo">
          <li id="listItem_#id#">
            <table class="table table-bordered table-striped">
              <tr>
                <td width="30" style="text-align:center;"><i class="icon-resize-vertical"></i></td>
                <td width="200">#name#</td>
                <td></td>
                <td width="90" style="text-align:center;">#showInNavigation#</td>
                <td width="60" style="text-align:center;"><cfif len(getinfo.body)>Y<cfelse>N</cfif></td>
                <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-block btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
                <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-block btn-danger mytooltip" data-confirm="Are you sure you want to delete this page?"><i class="icon-remove icon-white"></i> Delete</a></td>
                <td width="60">
                  <cfif triggerOnly eq 'Yes'>
                    Trigger
                  <cfelse>
                    <a href="/#slug#" class="btn btn-mini btn-block" target="_blank"><i class="icon-eye-open"></i> View</a>
                  </cfif>
                </td>
              </tr>
              <!--- check for any sub-pages --->
              <cfquery name="getSubPages" dataSource="#dsn#">
                select id,name,slug,showinNavigation,body from cms_pages where parentID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getinfo.id#">
                order by subsort
              </cfquery>
              <cfif getSubPages.recordcount gt 0>
                <cfloop query="getSubPages">
                  <tr>
                    <td width="30" style="text-align:center;"></td>
                    <td width="200" style="text-align: center;">
                      <!--- Add arrows for sort - down on first, up & down on all but the last, then up only on the last --->
                      <cfif getSubPages.currentrow is 1>
                        <i class="subsort icon-arrow-down" data-parentid="#getinfo.id#" data-thisid="#getSubPages.id#" data-direction="down"></i>
                      <cfelseif getSubPages.currentrow is not getSubPages.recordcount>
                        <i class="subsort icon-arrow-up" data-parentid="#getinfo.id#" data-thisid="#getSubPages.id#" data-direction="up"></i>&nbsp;&nbsp;&nbsp;
                        <i class="subsort icon-arrow-down" data-parentid="#getinfo.id#" data-thisid="#getSubPages.id#" data-direction="down"></i>
                      <cfelse>
                        <i class="subsort icon-arrow-up" data-parentid="#getinfo.id#" data-thisid="#getSubPages.id#" data-direction="up"></i>
                      </cfif>
                    </td>
                    <td>#name#</td>
                    <td width="90" style="text-align:center;">#showInNavigation#</td>
                    <td width="60" style="text-align:center;"><cfif len(getSubPages.body)>Y<cfelse>N</cfif></td>
                    <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-block btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
                    <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-block btn-danger mytooltip" data-confirm="Are you sure you want to delete this page?"><i class="icon-remove icon-white"></i> Delete</a></td>
                    <td width="60"><a href="/#slug#" class="btn btn-mini btn-block" target="_blank"><i class="icon-eye-open"></i> View</a></td>
                  </tr>
                </cfloop>
              </cfif>
            </table>
          </li>
        </cfoutput>
      </ul>
    </div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
  $("#sort-list").sortable({
    update: function(event, ui) {
      var sortOrder = $(this).sortable('toArray').toString();
      $.get('sorter.cfm', {sortOrder:sortOrder});
      $('#sortStatus').css('display','block');
    }
  });  

  $(".subsort").click(function(){
    var parentId = $(this).attr('data-parentid');
    var thisId = $(this).attr('data-thisid');
    var dir = $(this).attr('data-direction');
//console.log('parentId: ' + parentId + ", thisId: " + thisId + ", dir: " + dir);      
    // this function does the re-sorting
    $.ajax({
      type: "POST",
      url: 'sub-sorter.cfm',
      data: {parentId: parentId, thisId: thisId, dir: dir},
      success: function(data){
        $loading.show();
        location.reload();
      }
    });
  });    

});

var $loading = $('#loadingDiv').hide();
</script>

<style>
.table-heading, #sort-list { min-width: 800px; }
.table-heading th { padding: 5px 8px; text-align: center; }
#sort-list table td { vertical-align: middle; }
@media (max-width: 1200px) {
  .table-wrap { overflow-y: auto; width: 100%; }
}
</style>

<cfinclude template="/admin/components/footer.cfm">