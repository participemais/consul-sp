(() => {
  'use strict';
  App.SubprefectureData = {
    toggle_info: () => {
      $(".js-subprefecture-data")
        .children('span')
        .toggleClass('icon-plus-square icon-minus-square');
      $(".js-subprefecture-info").slideToggle();
    },
    initialize: () => {
      $(".js-subprefecture-data").on("click", () => {
        App.SubprefectureData.toggle_info();
      });
    }
  }
}).call(this);
