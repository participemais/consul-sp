module OpenGovHelper
  def open_gov_tabs
    {
      "articles" => admin_open_gov_articles_path,
      "participations" => admin_open_gov_participation_articles_path,
      "monitoring" => admin_open_gov_plans_path
    }
  end
end
