$(document).ready(function(){

  // Datepicker plugin
  $('.datepicker').datepicker().on('changeDate',function(ev){
    //when the user makes a selection hide the datepicker
    $(this).datepicker('hide');
  });

  // Choose File Text Show
  $('#uniform-undefined input[type=file]').change(function() {
    var filename = $(this).val();
    if (filename.substring(3,11) == 'fakepath') {
      filename = filename.substring(12);
    }
    $(this).next().text(filename);
  });

});

function countit(what){
  formcontent=what.form.metakeywords.value
  what.form.displaycount.value=formcontent.length
}
function countit2(what){
  formcontent=what.form.metadescription.value
  what.form.displaycount2.value=formcontent.length
}
function countit3(what){
  formcontent=what.form.metatitle.value
  what.form.displaycount3.value=formcontent.length
}