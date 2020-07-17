class Budget
  class Ballot < ApplicationRecord
    belongs_to :user
    belongs_to :budget
    belongs_to :poll_ballot, class_name: "Poll::Ballot"

    has_many :lines, dependent: :destroy
    has_many :investments, through: :lines
    has_many :groups, -> { distinct }, through: :lines
    has_many :headings, -> { distinct }, through: :groups

    def add_investment(investment)
      lines.create(investment: investment).persisted?
    end

    def total_amount_spent
      investments.sum(:price).to_i
    end

    def amount_spent(heading = nil)
      if resource_allocation_balloting?
        investments.by_heading(heading.id).sum(:price).to_i
      else
        total_amount_spent
      end
    end

    def formatted_amount_spent(heading)
      if resource_allocation_balloting?
        budget.formatted_currency_amount(amount_spent(heading))
      else
        total_amount_spent
      end
    end

    def amount_available(heading = nil)
      if resource_allocation_balloting?
        budget.heading_price(heading) - amount_spent(heading)
      else
        votes_per_user - amount_spent
      end
    end

    def formatted_amount_available(heading)
      if resource_allocation_balloting?
        budget.formatted_currency_amount(amount_available(heading))
      else
        amount_available
      end
    end

    def has_lines_in_group?(group)
      groups.include?(group)
    end

    def wrong_budget?(heading)
      heading.budget_id != budget_id
    end

    def different_heading_assigned?(heading)
      if resource_allocation_balloting?
        other_heading_ids = heading.group.heading_ids - [heading.id]
        lines.where(heading_id: other_heading_ids).exists?
      end
    end

    def valid_heading?(heading)
      !wrong_budget?(heading) && !different_heading_assigned?(heading)
    end

    def has_lines_with_no_heading?
      investments.no_heading.count > 0
    end

    def has_lines_with_heading?
      heading_id.present?
    end

    def has_lines_in_heading?(heading)
      investments.by_heading(heading.id).any?
    end

    def has_investment?(investment)
      reload
      lines.map(&:investment_id).include?(investment.id)
    end

    def heading_for_group(group)
      return nil unless has_lines_in_group?(group)

      investments.find_by(group: group).heading
    end

    def casted_offline?
      budget.poll&.voted_by?(user)
    end

    def resource_allocation_balloting?
      budget.resource_allocation_balloting?
    end

    def votes_per_user
      budget.max_votes
    end
  end
end
