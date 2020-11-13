(function() {
  "use strict";
  App.InvestmentReportAlert = {
    initialize: function() {
      $("#js-investment-report-alert").on("click", function() {
        if (this.checked) {
          return confirm(this.dataset.alert);
        }
      });
    }
  };
}).call(this);
