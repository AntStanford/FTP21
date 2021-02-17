<cfsetting requesttimeout="300" /><!--- 300 = 5 minutes --->

<cfset variables.officeIP = '216.99.119.254' />
<cfset variables.jimIP = '173.93.73.19' />
<cfset variables.saraIP = '68.44.158.31' />
<cfset variables.coleIP = '75.87.66.209' />
<cfset variables.pratikIP = '103.17.82.124' />
<cfset variables.adouteIP = createObject("java","java.net.InetAddress").getByName("adoute.dyndns.org").getHostAddress() />

<!--- DO NOT USE REVERSE DNS ON ANY 'LIVE' SITE PAGES - IT SHOULD ONLY BE USED AS A DEV TOOL --->
<cfif   cgi.remote_addr NEQ variables.officeIP AND
        cgi.remote_addr NEQ variables.adouteIP AND
        cgi.remote_addr NEQ variables.jimIP AND
        cgi.remote_addr NEQ variables.saraIP AND
        cgi.remote_addr NEQ variables.coleIP AND
		cgi.remote_addr NEQ variables.pratikIP
        >
    <cflocation url="/" addtoken="false">
</cfif>
<!--- ONLY APPROVED USERS SHOULD GET THIS FAR --->

<!DOCTYPE html>
<html lang="en">
    <head>
  <!-- http://www.1stwebdesigner.com/design/snippets-html5-boilerplate/ -->

    <meta charset="utf-8">
    <title>Site Search</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">


    <!-- For faster page loads -->
    <!--[if IE]><![endif]-->
    <!-- Bootstrap -->
    <link href="//cdnjs.cloudflare.com/ajax/libs/normalize/2.1.0/normalize.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="//ajax.aspnetcdn.com/ajax/bootstrap/2.3.1/css/bootstrap.min.css" media="screen" />
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/select2/3.4.1/select2.min.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.min.css"/>
    <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">


    <!-- Place favicon.ico and apple-touch-icon.png in the root of your domain and delete these references -->

               <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
    <link rel="shortcut icon" href="/favicon.ico">



<style>
    /* maxvoltar.com/archive/-webkit-font-smoothing */
    html { -webkit-font-smoothing: antialiased; overflow-y: scroll; }
    body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
        font:13px sans-serif; *font-size:small; *font:x-small; line-height:1.22;
    }



    /*
    fonts.css from the YUI Library: developer.yahoo.com/yui/
    Please refer to developer.yahoo.com/yui/fonts/ for font sizing percentages
    */
    table { font-size:inherit; font:100%; }
    select, input, textarea { font:99% sans-serif; }

    /* makes the text wrap when it reaches the walls of its container */
    pre {
        padding: 15px;
        white-space: pre; /* CSS2 */
        white-space: pre-wrap; /* CSS 2.1 */
        white-space: pre-line; /* CSS 3 (and 2.1 as well, actually) */
        word-wrap: break-word; /* IE */
    }
    /* align checkboxes, radios, text inputs with their label */
    input[type="radio"] { vertical-align: text-bottom; }
    input[type="checkbox"] { vertical-align: bottom; *vertical-align: baseline; }
    .ie6 input { vertical-align: text-bottom; }

    /* hand cursor on clickable input elements */
    label, input[type=button], input[type=submit], button { cursor: pointer; }

    /* bicubic resizing for non-native sized IMG:
    code.flickr.com/blog/2008/11/12/on-ui-quality-the-little-things-client-side-image-resizing/ */
    .ie7 img { -ms-interpolation-mode: bicubic; }

    @media all and (orientation:portrait) {
    /* Style adjustments for portrait mode goes here */
    }

    @media all and (orientation:landscape) {
    /* Style adjustments for landscape mode goes here */
    }

</style>

    </head>
    <body>
        <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#">Site Search</a>
          <div class="nav-collapse collapse">
            <!--- <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul> --->
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>



     <div class="container">

     <!---  <h1>Search for text within a directory recursively</h1>

        <form method="GET" action="">
            <p>Test examples: test, nest, Added, Bug Fixes</p>
            <p>Text or regex to search for:</p>
            <p><input type="text" name="searchcriteria" />
            </p>

            <p>Directory:</p>
            <p><input type="text" name="folderpath" /> <br /> Defaults to document root directory. <br />/ or ../ is accepted</p>
            <p><input type="submit" value="Search" name="search" class="btn"/> </p> --->

            <form class="form-horizontal" action="" method="GET">
<fieldset>

<!-- Form Name -->
<legend>Search for text within a directory recursively</legend>

<!-- Search input-->
<div class="control-group">
  <label class="control-label" for="searchcriteria">Search Criteria</label>
  <div class="controls">
    <input id="searchcriteria" name="searchcriteria" placeholder="" class="input-xlarge search-query" required type="text">
    <p class="help-block">Text or regex to search for:</p>
  </div>
</div>

<!-- Select Basic -->
<div class="control-group">
  <label class="control-label" for="folderpath">Search Path</label>
  <div class="controls">
    <select id="folderpath" name="folderpath" class="input-xlarge">
      <option value=".">Current Directory</option>
      <option value="/">Root Directory</option>
      <option value="../">One Directory Up</option>
    </select>
    <p class="help-block">Defaults to document root directory. <br />/ or ../ is accepted</p>
  </div>
</div>

<!-- Button -->
<div class="control-group">
  <label class="control-label" for="submit"></label>
  <div class="controls">
    <button id="submit" name="search" value="Search" class="btn btn-inverse">Search</button>
  </div>
</div>

</fieldset>
</form>



        <!--- </form> --->

    <cfif isDefined('url.search')>
        <cfif folderpath is "">
            <cfset folderpath = '.'>
        </cfif>

        <!--- <cfinclude template="icndsearch_.cfm"> --->
        <cfset arrMatchingPaths = SearchFiles(
        Path = #ExpandPath( folderpath )#,
        Criteria = "#searchcriteria#"
        ) />
<cfoutput><p class="alert alert-info"><strong>#arrayLen(arrMatchingPaths)#</strong> Results for search term: <strong>#searchcriteria#</strong></p></cfoutput>
        <!--- log every search --->
        <!--- writeThisLog('message','status level') --->
        <cfset writeThisLog(#searchcriteria# & '->' & #folderpath#,'Info')>
        <!--- <cfdump var="#arrMatchingPaths#"> --->

        <table class="table table-striped table-hover table-condensed">
            <th>No.</th>
            <th>Results</th>
            <th></th>
            <cfoutput>
                <cfloop from="1" index="i" to="#arrayLen(arrMatchingPaths)#">

                    <tr>
                        <td>#i#</td>
                        <td>#arrMatchingPaths[i]#</td>
                        <td><button class="btn btn-inverse btn-small strike">Strike</button></td>
                    </tr>

                </cfloop>
                </cfoutput>

        </table>
    </cfif>

    </div> <!-- /container -->


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script src="//ajax.aspnetcdn.com/ajax/bootstrap/2.3.1/bootstrap.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/placeholders/2.1.0/placeholders.min.js"></script>
    <script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/select2/3.4.1/select2.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/js/toastr.min.js"></script>




    <script>
    $(document).ready(function() {
         //$('#element').validate();
         $('select').select2();
    });
</script>


<script>
    $(document).ready(function(){
        $('.strike').click(function() {
            $(this).css("color","red");
        })
    })
</script>


    </body>
    </html>




<!---   <cfelse>
        Forbidden!
</cfif> --->


<!--- --------------------------------------------------------------------------------------- ----
                                        FUNCTIONS
--------------------------------------------------------------------------------------------------
    Blog Entry:
    Searching Directories And File Content Using ColdFusion

    Author:
    Ben Nadel / Kinky Solutions

    Link:
    http://www.bennadel.com/index.cfm?event=blog.view&id=553

    Date Posted:
    Mar 1, 2007 at 8:06 AM


    Edits by DP:
    Added recurse="true" To make this function recursive to search in directories

---- --------------------------------------------------------------------------------------- --->


<cffunction
    name="SearchFiles"
    access="public"
    returntype="array"
    output="false"
    hint="Searchs files for the given values. Returns an array of file paths.">

    <!--- Define arguments. --->
    <cfargument
        name="Path"
        type="any"
        required="true"
        hint="This is either a directory path or an array of file paths which we will be searching."
        />

    <cfargument
        name="Criteria"
        type="string"
        required="true"
        hint="The values for which we are searching the file contents."
        />

    <cfargument
        name="Filter"
        type="string"
        required="false"
        default="cfm,css,htm,html,js,txt,xml,php,cfc"
        hint="List of file extensions that we are going to allow."
        />

    <cfargument
        name="IsRegex"
        type="boolean"
        required="false"
        default="false"
        hint="Flags whether or not the search criteria is a regular expression."
        />


    <!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />


    <!---
        Check to see if we are dealing with a directory path.
        If we are, we are going to want to get those paths
        and convert it to an array of file paths.
    --->
    <cfif IsSimpleValue( ARGUMENTS.Path )>

        <!---
            Get all the files in the given directory. We are
            going to ensure that only files are returned in
            the resultant query. We don't want to deal with
            any directories.
        --->

        <!--- DP to make this function recursive to search in directories  --->
        <!--- Added recurse="true" --->


        <cfdirectory
            action="LIST"
            directory="#ARGUMENTS.Path#"
            name="LOCAL.FileQuery"
            filter="*.*"
            recurse="true"
            />

        <!---
            Now that we have the query, we want to create an
            array of the file names.
        --->
        <cfset LOCAL.Paths = ArrayNew( 1 ) />

        <!--- Loop over the query and set up the values. --->
        <cfloop query="LOCAL.FileQuery">

            <cfset ArrayAppend(
                LOCAL.Paths,
                (LOCAL.FileQuery.directory & "\" & LOCAL.FileQuery.name)
                ) />

        </cfloop>

    <cfelse>

        <!---
            For consistency sake, just store the path argument
            into our local paths value so that we can refer to
            this and the query-route the same way (see above).
        --->
        <cfset LOCAL.Paths = ARGUMENTS.Path />

    </cfif>


    <!---
        ASSERT: At this point, whether we were passed in a
        directory path or an array of file paths, we now have
        an array of file paths that we are going to search
        in the variable LOCAL.Paths.
    --->


    <!---
        Create an array in which we will store the file paths
        that had matching criteria.
    --->
    <cfset LOCAL.MatchingPaths = ArrayNew( 1 ) />


    <!---
        Clean up the filter to be used in a regular expression.
        We are going to turn the list into an OR reg ex.
    --->
    <cfset ARGUMENTS.Filter = ARGUMENTS.Filter.ReplaceAll(
        "[^\w\d,]+",
        ""
        ).ReplaceAll(
            ",",
            "|"
        ) />


    <!--- Loop over the file paths in our paths array. --->
    <cfloop
        index="LOCAL.PathIndex"
        from="1"
        to="#ArrayLen( LOCAL.Paths )#"
        step="1">


        <!---
            Get a short hand to the current path. This is
            not necessary but just makes referencing the
            path easier.
        --->
        <cfset LOCAL.Path = LOCAL.Paths[ LOCAL.PathIndex ] />


        <!---
            Check to see if this file path is allowed. Either
            we have no file filters or we do and this file
            has one of them.
        --->
        <cfif (
            (NOT Len( ARGUMENTS.Filter )) OR
            (
                REFindNoCase(
                    "(#ARGUMENTS.Filter#)$",
                    LOCAL.Path
                    )
            ))>


            <!---
                This is a file that we can use. Read in the
                contents of the file.
            --->
            <cffile
                action="READ"
                file="#LOCAL.Path#"
                variable="LOCAL.FileData"
                />


            <!---
                Check to see what kind of search we are going.
                Is it a straight-up value search or is it a
                regular expression search?
            --->
            <cfif (
                (
                    ARGUMENTS.IsRegex AND
                    REFindNoCase(
                        ARGUMENTS.Criteria,
                        LOCAL.FileData
                    )
                ) OR
                (
                    (NOT ARGUMENTS.IsRegex) AND
                    FindNoCase(
                        ARGUMENTS.Criteria,
                        LOCAL.FileData
                    )
                )
                )>

                <!---
                    This is a good file path. Add it to the
                    list of successful file paths.
                --->
                <cfset ArrayAppend(
                    LOCAL.MatchingPaths,
                    LOCAL.Path
                    ) />

            </cfif>

        </cfif>

    </cfloop>


    <!--- Return the array of matching file paths. --->
    <cfreturn LOCAL.MatchingPaths />

</cffunction>

<!---
Author: DP
Purpose: To log various levels of information during program run
Param: Message: Accepts: String
Param: Level:   Accepts:
                Info - Default
                Debug
                Warning
                Error
            --->
<cffunction name="writeThisLog" ouput="false">
    <cfargument name="message" type="any" required="true">
    <cfargument name="level" type="string" default="Info" >

    <cfset filename = #expandPath("log.txt")#>
        <cffile action="append" file="#filename#" output="#DateFormat(Now(),'mm/dd/yy')# #TimeFormat(Now(), 'short')# Level: #level# - #message#">
        <!--- <cfheader statusText="Internal Server Error" statusCode="500"> --->
</cffunction>