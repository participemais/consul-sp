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
        }
      });
    }
  }

}).call(this);