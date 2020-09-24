(() => {
  "use strict";
  App.LinkTargetBlank = {
    initialize: () => {
      const $link = $("a[href^='http']");
      const regexp = /localhost|participemais/;

      if ($link.length > 0 && !$link.attr("href").match(regexp)) {
        $link.attr("target","_blank");
      };
    }
  }
}).call(this);
