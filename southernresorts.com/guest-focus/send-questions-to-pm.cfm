<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">

<div class="content-wrap">

  <div class="page-header">
    <h1>Send Questions to PM</h1>
  </div>

  <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>

  <cfif isdefined('url.success')>
    <div class="alert alert-success">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      Your message has been sent.
    </div>
  </cfif>

  <br>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">Fill out form below</h3>
    </div>
    <div class="panel-body">
      <form method="post" action="submit.cfm" id="sendquestiontopmform">
        <input type="hidden" name="action" value="sendquestiontopm">
        <fieldset>
          <div class="form-group">
            <label class="control-label" for="textinput">Subject</label>
            <input id="textinput" name="subject" type="text" placeholder="" class="form-control input-md required">
          </div>
          <div class="form-group">
            <label class="control-label" for="textarea">Comments</label>
            <textarea class="form-control required" id="textarea" name="comments"></textarea>
          </div>
          <div class="form-group">
            <label class="control-label" for="singlebutton"></label>
            <button id="singlebutton" name="singlebutton" class="btn btn-primary">Submit</button>
          </div>
        </fieldset>
      </form>
    </div>
  </div>

</div>

<cfinclude template="../guest-focus/components/footer.cfm">