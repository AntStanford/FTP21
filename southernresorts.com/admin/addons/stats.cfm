<cfset page.title ="Checkout Addons Stats">

  <cfparam name="form.startDate" default="#dateformat(dateadd('d',-30,now()),"mm/dd/yyyy")#">
  <cfparam name="form.endDate" default="#dateformat(now(),"mm/dd/yyyy")#">

  <cfquery name="getAddons" dataSource="#application.dsn#">
    select title from cms_checkout_addons order by title
  </cfquery>

  <cfquery name="orderInfo" dataSource="#application.dsn#">
    Select Count(*) as count,min(dtCreated) as mindate
    From apilogs
    Where dtCreated >= '#dateformat(form.startDate, 'yyyy/mm/dd')#' and dtCreated <= '#dateformat(form.endDate, 'yyyy/mm/dd')#'
    and page = '/vacation-rentals/book-now-confirm.cfm'
  </cfquery>


<cfinclude template="/admin/components/header.cfm">  

<style type="text/css">
  input[type="submit"],input[type="reset"]{position: relative;top: -5px;}
</style>

<form method="post">
  <cfoutput>
  <input type="text" name="startDate" class="datepicker" placeholder="From" autocomplete="off" style="width:100px;" required="required" value="#dateformat(form.startDate, 'mm/dd/yyyy')#">
  <input type="text" name="endDate" class="datepicker" placeholder="To" autocomplete="off" style="width:100px;" required="required" value="#dateformat(form.endDate, 'mm/dd/yyyy')#">
  </cfoutput>
  <select name="title" style="width:200px;"><option value="all">Select Addon</option><cfoutput query="getAddons"><option value="#title#" <cfif isdefined('form.title') and form.title eq title>selected</cfif>>#title#</option></cfoutput></select>
  <input type="submit" value="Search" class="btn btn-primary">
  <input type="reset" value="Reset" class="btn btn-default">
</form> 

<div class="widget-box">
  <div class="widget-content nopadding">

  <cfquery name="getAddonBookings" dataSource="#application.dsn#">
    Select res,dtCreated
    From apilogs
    Where 
    res LIKE '%<confirmation_id>%' 
    and page = '/vacation-rentals/book-now-confirm.cfm'

    <cfif isdefined('form.title') and form.title neq 'all'>
      and req LIKE '%#form.title#%'
    <cfelse>
      and req LIKE '%Addons:%'
    </cfif>

     and dtCreated >= '#dateformat(form.startDate, 'yyyy/mm/dd')#' and dtCreated <= '#dateformat(form.endDate, 'yyyy/mm/dd')#'
  </cfquery>


    <table class="table table-bordered table-striped">
    <tr>
      <th width="30">No.</th>
      <th>Date</th>       
      <th>Confirmation</th>     
      <th>Start Date</th>
      <th>End Date</th> 
      <th></th>
    </tr>  
      
    <cfoutput query="getAddonBookings">
      <cfif isXML(res)>
        <cfset resInfo = xmlParse(res)>
      </cfif>

      <tr>
        <td>#currentrow#.</td>
        <td>#dateformat(dtCreated, 'mm/dd/yyyy')#</td>    
        <cfif isXML(res)> 
          <td>#resInfo.Response.data.reservation.confirmation_id#</td>       
          <td>#resInfo.Response.data.reservation.startdate#</td>     
          <td>#resInfo.Response.data.reservation.enddate#</td>
        <cfelse>
          <td colspan="3">Error parsing data.</td>
        </cfif>
      </tr>


    </cfoutput>
  
    </table>



  </div>
</div>
<cfinclude template="/admin/components/footer.cfm">
