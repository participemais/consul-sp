(() => {
  "use strict";
  App.EnableElements = {
    initialize: () => {
      $("[data-choose-option]").on("click", function() {
        const klass = this.dataset.chooseOption;
        $(`.${klass}`).each(function() {
          if ($(this).prop("disabled")) {
            $(this).prop("disabled", false);
          }
        });
      });
    }
  };
}).call(this);
