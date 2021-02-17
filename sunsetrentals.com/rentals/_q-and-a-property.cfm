<cfquery name="propertyQuestions" dataSource="#settings.dsn#">
	select * from be_questions_and_answers_properties
	where approved = 'yes'
	and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">
	order by createdat
</cfquery>

<div id="qanda" name="qanda" class="info-wrap q-and-a-wrap">
  <div class="info-wrap-heading"><i class="fa fa-question-circle" aria-hidden="true"></i> Questions and Answers</div>
  <div class="info-wrap-body">
    <em>Want to know specifics? Ask anything about this specific property that you would like to know...<br/>Example: <strong>&ldquo;Is the balcony screened in?&rdquo;</strong> or <strong>&ldquo;Is there a toaster oven?&rdquo;</strong></em>
    <cfif propertyQuestions.recordcount gt 0>
  	  <div class="owl-carousel q-and-a-carousel">
  	    <cfloop query="propertyQuestions">
  		    <cfoutput>
  		    <blockquote class="the-q-and-a">
  		      <div class="question"><strong>Q:</strong> #question#</div>
  		      <div class="signature">- #firstname# #left(lastname,1)#. Posted: #dateformat(createdat,'mm/dd/yyyy')#</div>
  		      <cfif len(answer)><div class="answer"><strong>A:</strong> #answer#</div></cfif>
  		    </blockquote>
  		    </cfoutput>
  	    </cfloop>
  	  </div>
       <small class="scroll-indicator"><i class="fa fa-arrows-h" aria-hidden="true"></i><strong><span class="swipe">Swipe</span><span class="drag">Drag</span> for Questions/Answers</strong></small>
  	</cfif>

    <div class="btn-group">
      <cfif propertyQuestions.recordcount gt 0><button id="nextQA" class="btn next-slide site-color-1-bg site-color-3-bg-hover text-white" type="button">Next Q&A</button></cfif>
      <button id="propertyQA" class="btn site-color-2-bg site-color-3-bg-hover text-white" type="button" data-toggle="modal" data-target="#propertyQAModal">Ask A Question</button>
    </div>
  </div><!-- END info-wrap-body -->
</div><!-- END q-and-a-wrap -->
