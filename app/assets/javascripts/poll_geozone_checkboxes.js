(() => {
  "use strict";
  App.PollGeozoneCheckboxes = {
    initialize: function() {
      $('#subs_restricted').on('change', function(){
        if ($('#subs_restricted').is(":checked")) {
          $('#subs').slideDown();
          $('#districts').slideUp();
          $('#districts_restricted').prop('checked', false);
          $('#districts input').prop('checked', false);
        } else {
          $('#subs').slideUp();
          $('#subs input').prop('checked', false);
        }

      });

      $('#districts_restricted').on('change', function(){
        if ($('#districts_restricted').is(":checked")) {
          $('#districts').slideDown();
          $('#subs').slideUp();
          $('#subs_restricted').prop('checked', false);
          $('#subs input').prop('checked', false);
        } else {
          $('#districts').slideUp();
          $('#districts input').prop('checked', false);
        }
      });

      $('.polls-form input[type="submit"]').on('click', function(e){
        if ($('#subs_restricted').is(":checked")) {
          if (!$('#subs input[type=checkbox]').is(":checked")){
            e.preventDefault();
            alert($('#subs_restricted').data('alert'));
          }
        } else if ($('#districts_restricted').is(":checked")) {
          if (!$('#districts input[type=checkbox]').is(":checked")){
            e.preventDefault();
            alert($('#districts_restricted').data('alert'));
          }
        }
      });

      if (!$('#subs_restricted').is(":checked")) {
        $('#subs input[type=checkbox]').prop( "checked", false );
      }
    }
  }

}).call(this);