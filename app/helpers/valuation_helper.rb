module ValuationHelper
  def valuator_or_group_select_options
    valuator_group_select_options + valuator_select_options
  end

  def valuator_select_options
    Valuator.order("description ASC").order("users.email ASC").includes(:user).
             map { |v| [v.description_or_email, "valuator_#{v.id}"] }
  end

  def valuator_group_select_options
    ValuatorGroup.order("name ASC").map { |g| [g.name, "group_#{g.id}"] }
  end

  def explanation_field(field)
    Nokogiri::HTML.parse(field).text.squish if field.present?
  end
end
