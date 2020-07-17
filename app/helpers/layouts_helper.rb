module LayoutsHelper
  def layout_menu_link_to(text, path, is_active, options)
    if is_active
      tag.span(t("shared.you_are_in"), class: "show-for-sr") + " " +
        link_to(text, path, options.merge(class: "is-active"))
    else
      link_to(text, path, options)
    end
  end

  def online_hearings_page
    @online_hearings_page ||=
      SiteCustomization::Page.find_by(slug: 'audiencias', status: 'published')
  end
end
