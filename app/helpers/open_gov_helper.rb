module OpenGovHelper
  def open_gov_tabs
    {
      "articles" => admin_open_gov_articles_path,
      "participations" => participations_admin_open_gov_articles_path
    }
  end
end
