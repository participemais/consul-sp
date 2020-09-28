(() => {
  "use strict";
  App.DataInfoToggle = {
    toggleBox: (handler) => {
      const id = handler.currentTarget.dataset.infoToggle;
      $(`#${id}`).slideToggle();
    },
    initialize: () => {
      $("[data-info-toggle]").on("click", (handler) => {
        App.DataInfoToggle.toggleBox(handler);
      });
    }
  };
}).call(this);
