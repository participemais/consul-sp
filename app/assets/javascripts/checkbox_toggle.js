(() => {
  "use strict";
  App.CheckboxToggle = {
    toggleBox: () => {
      const $checkbox = $("[data-checkbox-toggle]");
      const $target = $($($checkbox).data("checkbox-toggle"));

      if ($($checkbox).is(":checked")) {
        $target.slideDown();
      } else {
        $target.slideUp();
      }
    },
    toggleOnChange: () => {
      $("[data-checkbox-toggle]").on("change", () => {
        App.CheckboxToggle.toggleBox()
      });
    },
    initialize: () => {
      App.CheckboxToggle.toggleBox();
      App.CheckboxToggle.toggleOnChange();
    }
  };
}).call(this);
