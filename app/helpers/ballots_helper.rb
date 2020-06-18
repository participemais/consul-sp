module BallotsHelper
  def progress_bar_width(amount_available, amount_spent)
    (amount_spent / amount_available.to_f * 100).to_s + "%"
  end

  def remaining_votes_link(group)
    amount =
      if @budget.resource_allocation_balloting?
        translation = "remaining_money"
        @ballot.formatted_amount_available(
          @ballot.heading_for_group(group)
        )
      else
        translation = "remaining_votes"
        @ballot.amount_available
      end

    if amount.is_a?(String) || amount > 0
      link_to(
        sanitize(t("budgets.ballots.show.#{translation}", count: amount)),
        budget_group_path(@budget, group)
      )
    end
  end
end
