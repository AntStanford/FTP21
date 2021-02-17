<cfif cgi.script_name neq '/guest-focus/index.cfm' AND !isdefined('cookie.GuestFocusLoggedInID') and cgi.script_name neq '/guest-focus/reset-password.cfm'>
	<cflocation addToken="no" url="/guest-focus/index.cfm">
</cfif>

<!doctype html>
<html lang="en-US">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Description Here">
  <title>Guest Focus</title>
  <link href="../guest-focus/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="../guest-focus/stylesheets/google-fonts.css" rel="stylesheet" type="text/css">
  <link href="../guest-focus/stylesheets/styles.css" rel="stylesheet" type="text/css" media="screen, projection">
  <link href="../guest-focus/bootstrap/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">
  <link href="../guest-focus/stylesheets/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="../guest-focus/javascripts/vendors/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <cf_htmlfoot>
  <script src="../guest-focus/javascripts/vendors/jquery/jquery-3.2.1.min.js"></script>
  <script src="../guest-focus/javascripts/vendors/jquery/jquery-migrate-1.4.1.min.js"></script>
  <script src="../guest-focus/javascripts/vendors/jquery-ui/jquery-ui.min.js"></script>
  <script src="../guest-focus/bootstrap/js/bootstrap.min.js"></script>
  <script src="../guest-focus/bootstrap/js/bootstrap-select.min.js"></script>
  <script src="../guest-focus/javascripts/vendors/jquery-validate/jquery.validate.min.js"></script>
  </cf_htmlfoot>
  <!--[if lt IE 9]>
    <script src="../guest-focus/javascripts/jquery/lt-ie9/html5shiv.min.js"></script>
    <script src="../guest-focus/javascripts/jquery/lt-ie9/respond.min.js"></script>
  <![endif]-->
  <link href="../guest-focus/images/layout/favicon.ico" rel="icon" type="image/x-icon">
</head>
<body>
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed">
        <i class="fa fa-bars"></i>
      </button>
      <a class="navbar-brand" href="/"><i class="fa fa-globe"></i> Website</a>
    </div>
    <cfif cgi.script_name neq '/guest-focus/index.cfm' and cgi.script_name neq '/guest-focus/reset-password.cfm'>
	    <ul class="nav navbar-nav navbar-right">	      
	      <li><a href="../guest-focus/index.cfm?logout"><i class="fa fa-power-off"></i> Logout</a></li>
	    </ul>
    </cfif>
  </div>
</nav>