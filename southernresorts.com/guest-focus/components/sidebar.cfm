<div class="sidebar-wrap">
  <div class="sidebar-company">
    <div class="sidebar-company-logo">
      <img src="../images/layout/logo.png">
    </div>
    <div class="sidebar-company-name"><cfoutput>#settings.company#</cfoutput></div>
  </div>
  <ul class="sidebar-list">
    <li class="sidebar-list-item">
      <a href="dashboard.cfm" class="sidebar-list-link">
        <span class="sidebar-list-link-icon"><i class="fa fa-heart"></i></span>
        <span class="sidebar-list-link-name">Favorites</span>
      </a>
    </li>
    <cfif settings.hasGuestLoyalty eq 'yes'>
	    <li class="sidebar-list-item">
	      <a href="guest-loyalty.cfm" class="sidebar-list-link">
	        <span class="sidebar-list-link-icon"><i class="fa fa-asterisk"></i></span>
	        <span class="sidebar-list-link-name">Guest Loyalty</span>        
	      </a>
	    </li>   
	    <li class="sidebar-list-item">
	      <a href="guest-loyalty-faqs.cfm" class="sidebar-list-link">
	        <span class="sidebar-list-link-icon"><i class="fa fa-question"></i></span>
	        <span class="sidebar-list-link-name">Guest Loyalty FAQs</span>        
	      </a>
	    </li> 
	    <li class="sidebar-list-item">
	      <a href="../guest-focus/booking-history.cfm" class="sidebar-list-link">
	        <span class="sidebar-list-link-icon"><i class="fa fa-book"></i></span>
	        <span class="sidebar-list-link-name">Booking History</span>
	      </a>
	    </li>
    </cfif>
    <li class="sidebar-list-item">
      <a href="../guest-focus/send-questions-to-pm.cfm" class="sidebar-list-link">
        <span class="sidebar-list-link-icon"><i class="fa fa-envelope"></i></span>
        <span class="sidebar-list-link-name">Send Questions to PM</span>
      </a>
    </li>
    <li class="sidebar-list-item">
      <a href="../guest-focus/profile.cfm" class="sidebar-list-link">
        <span class="sidebar-list-link-icon"><i class="fa fa-user-circle"></i></span>
        <span class="sidebar-list-link-name">Profile</span>
      </a>
    </li>
  </ul>
</div>