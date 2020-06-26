(() => {
  'use strict';
  App.DistrictData = {
    initialize: () => {
      $(".js-district-info").on('click', (handler) => {
        const target = handler.target;
        const id = target.dataset.district;

        $(target).removeClass("icon-plus-square").addClass("icon-minus-square");

        $(`[data-target="budget_district_${id}"]`).slideDown(1000);
      })
    }
  }
}).call(this);
