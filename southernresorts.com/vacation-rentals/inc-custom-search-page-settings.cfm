<cfif isdefined('session.booking.maxoccupancy') and session.booking.maxoccupancy contains '+'>
   <cfset session.booking.maxoccupancy = replace(session.booking.maxoccupancy,'+','','all')>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'blue-ribbon-homes'>
   <cfset session.booking.amenities = '106348'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'corolla-vacation-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5348'>
   <cfset session.booking.city = 'Corolla'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'duck-vacation-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5313'>
   <cfset session.booking.city = 'Duck'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'kill-devil-hills-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5350'>
   <cfset session.booking.city = 'Kill Devil Hills'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'kitty-hawk-vacation-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5349'>
   <cfset session.booking.city = 'Kitty Hawk'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'nags-head-vacation-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5345'>
   <cfset session.booking.city = 'Nags Head'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-between-highways-rentals'>
   <cfset session.booking.strarea = 'BH'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-community-pool-access-rentals'>
   <cfset session.booking.amenities = '106312'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-elevator-equipped-rentals'>
   <cfset session.booking.amenities = '106303'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-heated-pool-rentals'>
   <cfset session.booking.amenities = '106307'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-hot-tub-rentals'>
   <cfset session.booking.amenities = '106306'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-internet-access-rentals'>
   <cfset session.booking.amenities = '106316'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-non-smoking-home-rentals'>
   <cfset session.booking.amenities = '106315'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-oceanfront-rentals'>
   <cfset session.booking.strArea = 'OF'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-pet-friendly-rentals'>
   <cfset session.booking.amenities = '106302'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-oceanside-rentals'>
   <cfset session.booking.strArea = 'OS'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-pool-rentals'>
   <cfset session.booking.amenities = '106304,106312'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-private-pool-rentals'>
   <cfset session.booking.amenities = '106304'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-two-bedroom-condo-rentals'>
   <cfset session.booking.bedrooms = '2,2'>
   <cfset session.booking.hometype = 'Condo'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'obx-three-bedroom-condo-rentals'>
   <cfset session.booking.bedrooms = '3,3'>
   <cfset session.booking.hometype = 'Condo'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'pine-island-rentals'>
   <cfset session.booking.resort_area_id = 5878>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'repeat-renters-loyalty-program'>
   <cfset session.booking.amenities = '130435'>
</cfif>

<cfif isdefined('page.slug') and page.slug eq 'southern-shores-vacation-rentals'>
   <cfset session.booking.neighborhoodAreaId = '5351'>
   <cfset session.booking.city = 'Southern Shores'>
</cfif>