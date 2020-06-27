(() => {
  'use strict';
  App.DistrictData = {
    toggle_info: (handler) => {
      const target = handler.target;
      const id = target.dataset.district;
      $(target).toggleClass("icon-plus-square icon-minus-square");
      $(`[data-target="budget_district_${id}"]`).slideToggle();
    },
    initialize: () => {
      $(".js-district-info").on("click", (handler) => {
        App.DistrictData.toggle_info(handler);
      });
    }
  }
}).call(this);
