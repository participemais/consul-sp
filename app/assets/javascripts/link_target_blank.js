(() => {
  "use strict";
  App.LinkTargetBlank = {
    initialize: () => {
      $("a[href^='http']").attr("target","_blank");
    }
  }
}).call(this);