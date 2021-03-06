if SiteCustomization::Page.find_by(slug: "welcome_level_two_verified").nil?
  page = SiteCustomization::Page.new(slug: "welcome_level_two_verified", status: "published")
  page.title = I18n.t("welcome.welcome.title")

  page.content = "<p>#{I18n.t("welcome.welcome.user_permission_info")}</p>
                  <ul>
                    <li>#{I18n.t("welcome.welcome.user_permission_debates")}</li>
                  </ul>

                  <p>#{I18n.t("welcome.welcome.user_permission_verify")}</p>
                  <ul>
                    <li>#{I18n.t("welcome.welcome.user_permission_votes")}</li>
                  </ul>

                  <a href='/verification' class='button success radius expand'>
                    #{I18n.t("welcome.welcome.user_permission_verify_my_account")}
                  </a>

                  <p><a href='/'>#{I18n.t("welcome.welcome.go_to_index")}</a></p>"
  page.save!
end
