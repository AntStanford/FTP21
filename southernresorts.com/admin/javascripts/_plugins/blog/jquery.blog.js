$(document).ready(function () {
	
		  
  //This is needed for the blog to check for duplicate slugs 
	$('#catform').submit(function(){
	 
	 var name = $('#catform input[name=name]').val();
	 var slug = $('#catform input[name=slug]').val();
	 
	 if(name == '' || slug == ''){
	   alert('Name and Slug are required fields');
	   return false;
	 }else{
	   return true;
	 }
	
	});
  
  //Blog Stuff
  $('#submitpost').click(function(){
    
    var mytitle = $('#blogform input[name=title]').val();
    var myslug = $('#blogform input[name=slug]').val();
    
    if(mytitle == '' || myslug == ''){
      alert('Title and Slug are required fields.');
    }else{
    
      $.ajax({
        type: "GET",
        url: "/admin/blog/slugcheck.cfm",
        data: { slug: myslug}
      }).done(function( msg ) {
        var result = $.trim(msg);
        if(result == 'No Duplicate Slug Found'){        
        $('#blogform').submit();
        }else{
        alert('Duplicate slug found. Please choose another one.');
        }
      });  
    
    }      
  
  }); //end of blogpost click
  
  
   // Convert titles to URL-safe slugs using Wijmo Widgets on the blog form.cfm page and Pages form.cfm
  $('.sluggable').keyup( function() {        
    var value = $(this).val();
    $('.slug').val(value.replace(/[^a-z 0-9]+/gi,'').replace(/[\s]+/gi,'-').toLowerCase());
  });
  
  
});





