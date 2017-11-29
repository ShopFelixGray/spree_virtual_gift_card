Deface::Override.new(
  virtual_path: "spree/admin/shared/_main_menu",
  name: "admin_user_sub_menu_index",
  replace: "erb[loud]:contains('BackendConfiguration::USER_TABS')",
  :disabled => false) do
    <<-HTML
      <%= main_menu_tree Spree.t(:users), icon: "user", sub_menu: "user", url: "#sidebar-user" %>
    HTML
end
