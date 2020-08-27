(function() {
  "use strict";
  App.ValuationBudgetInvestmentForm = {
    hideAllFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").hide("down");
      $("#valuation_budget_investment_edit_form .feasibility_fields").hide("down");
    },
    showFeasibilityFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").hide("down");
      $("#valuation_budget_investment_edit_form .feasibility_fields").show("down");
    },
    showAllFields: function() {
      $("#valuation_budget_investment_edit_form .feasible_fields").show("down");
      $("#valuation_budget_investment_edit_form .feasibility_fields").show("down");
    },
    changeFeasibilityFields: function() {
      var feasibility;
      feasibility = $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']:checked").val();
      if (feasibility === "feasible") {
        App.ValuationBudgetInvestmentForm.showAllFields();
      } else if (feasibility === "unfeasible") {
        App.ValuationBudgetInvestmentForm.showFeasibilityFields();
      } else {
        App.ValuationBudgetInvestmentForm.hideAllFields();
      }
    },
    showFeasibilityFieldsOnChange: function() {
      $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']").on("change", function() {
        App.ValuationBudgetInvestmentForm.changeFeasibilityFields();
      });
    },
    initialize: function() {
      App.ValuationBudgetInvestmentForm.showFeasibilityFieldsOnChange();
      App.ValuationBudgetInvestmentForm.changeFeasibilityFields();
    }
  };
}).call(this);
