(() => {
  'use strict';
  App.ProposalsStatusFilters = {
    checkAll: () => {
      $('#status_filters_all').on('change', () => {
        const all = event.target;
        $('.js-proposals-status-filters')
          .not(all)
          .prop('checked', all.checked);
      });
    },
    allCheckBox: () => {
      const $statusFilters = $('.js-proposals-status-filters')
        .not('#status_filters_all');

      $statusFilters.on('change', () => {
        const $all = $('#status_filters_all');
        if ($statusFilters.not(':checked').length == 0) {
          $all.prop('checked', true);
        } else if($all.prop('checked')) {
          $all.prop('checked', false);
        }
      });
    },
    initialize: () => {
      App.ProposalsStatusFilters.checkAll();
      App.ProposalsStatusFilters.allCheckBox();
    }
  };
}).call(this);
