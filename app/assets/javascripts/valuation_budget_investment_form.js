(function() {
  "use strict";
  App.ValuationBudgetInvestmentForm = {
    hideAllFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").hide("down");
      $("#valuation_budget_investment_edit_form .unfeasible_fields").hide("down");
    },
    showNotFeasibleFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").hide("down");
      $("#valuation_budget_investment_edit_form .unfeasible_fields").show("down");
    },
    showAllFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").show("down");
      $("#valuation_budget_investment_edit_form .unfeasible_fields").show("down");
    },
    showFeasibilityFields: function() {
      var feasibility;
      feasibility = $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']:checked").val();
      if (feasibility === "feasible") {
        App.ValuationBudgetInvestmentForm.showAllFields();
      } else if (feasibility === "unfeasible") {
        App.ValuationBudgetInvestmentForm.showNotFeasibleFields();
      } else {
        App.ValuationBudgetInvestmentForm.hideAllFields();
      }
    },
    showFeasibilityFieldsOnChange: function() {
      $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']").on("change", function() {
        App.ValuationBudgetInvestmentForm.showFeasibilityFields();
      });
    },
    initialize: function() {
      App.ValuationBudgetInvestmentForm.showFeasibilityFieldsOnChange();
    }
  };
}).call(this);
