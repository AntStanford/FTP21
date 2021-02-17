<!--- and also check for add-ons --->
<cfset session.booking.methodname = 'GetPropertyAmenitiesWithRates'>

<!--- <cfinclude template="/vacation-rentals/api/callAPI.cfm">  --->

<cfquery name="qryAddons" datasource="#settings.dsn#">
select * from cms_checkout_addons
</cfquery>

<style>
.shoppingimg {width:150px;}
.shoppingimgmodal {width:250px;}
</style>

<div class="panel panel-default">
  <!--- add-ons --->
  <!---
    <cfquery name="getAllAddons" dataSource="#dsn#">
    select * from cms_checkout_addons
    </cfquery>
  --->
  <div class="panel-heading">
    <h3 class="panel-title">Optional Items to Add for Your Convenience</h3>
  </div>
  <div class="panel-body">
    <!---
    <table class="table">
      <cfoutput query="qryAddons">
        <!--- <cfset idAsString = NumberAsString(getAllAddons.id)> --->
        <tr>
          <td colspan="2"><b>#title#</b></td>
        </tr>
        <tr>
          <td><img class="shoppingimg" src="/images/addons/#photo#" style=""></td>
          <!--- <td>#mid(description,1,100)#...</td> --->
          <td>#description#</td>
        </tr>
        <tr>
          <td></td>
          <td class="text-right">#Dollarformat(amount)#&nbsp;&nbsp;<a href="" data-toggle="modal" data-target="##addonModal#qryAddons.track_ID#" class="btn btn-info">Donate Now</a></td>
        </tr>
      </cfoutput>
    </table>
    --->
    <div class="row">
      <cfoutput query="qryAddons">
        <!--- <cfset idAsString = NumberAsString(getAllAddons.id)> --->
        <div class="col-md-12">
          <div style="padding:10px;border-top:1px rgba(0,0,0,0.25) solid;border-bottom:1px rgba(0,0,0,0.25) solid;">
            <b>#title#</b>
          </div>
        </div>
        <div class="col-md-12">
          <div style="padding:10px;">
            <div class="row">
              <div class="col-md-4 col-sm-4 col-xs-4">
                <img class="shoppingimg" src="/images/addons/#photo#" style="width:100% !important;height:auto !important;">
              </div>
              <div class="col-md-8 col-sm-8 col-xs-8">
                <!--- <td>#mid(description,1,100)#...</td> --->
                #description#
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-12" style="margin-bottom:15px;">
          <div class="text-right" style="padding:10px;border-top:1px rgba(0,0,0,0.25) solid;">
            #Dollarformat(amount)#&nbsp;&nbsp;<a href="" data-toggle="modal" data-target="##addonModal#qryAddons.track_ID#" class="btn btn-info">Donate Now</a>
          </div>
        </div>
      </cfoutput>
    </div>
  </div>
  <!--- end add ons--->
</div>

<!---
  <cfif isdefined('getAllAddons') and getAllAddons.recordCount gt 0>
    <cfoutput query="getAllAddons">
      <cfset idAsString = NumberAsString(getAllAddons.id)>
--->

<cf_htmlfoot>
  <cfoutput query="qryAddons">
    <div class="modal fade" id="addonModal#qryAddons.track_ID#" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="myModalLabel">#qryAddons.title#</h4>
          </div>
          <div class="modal-body">
            <img class="shoppingimgmodal pull-left" src="/images/addons/#qryAddons.photo#" style="padding-right:15px">
            #qryAddons.description#
            <form class="modalform">
              <label>Quantity</label><br>
              <input type="text" name="addOnQty_#qryAddons.track_ID#" id="addOnQty_#qryAddons.track_ID#" placeholder="Enter Qty" value="1" class="text-center">
              <input type="button" name="submitqty" value="Submit" class="btn btn-info submitbtn" id="submitqty_#qryAddons.track_ID#" data-dismiss="modal">
            </form>
          </div>
          <div class="modal-footer">
            <button id="btnClose" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </cfoutput>
</cf_htmlfoot>

<!---
    </cfoutput>
  </cfif>
--->