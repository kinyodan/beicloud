require "application_system_test_case"

class AppsTest < ApplicationSystemTestCase
  setup do
    @app = apps(:one)
  end

  test "visiting the index" do
    visit apps_url
    assert_selector "h1", text: "Apps"
  end

  test "should create app" do
    visit apps_url
    click_on "New app"

    fill_in "Anchor url", with: @app.anchor_url
    fill_in "App dashboard", with: @app.app_dashboard_id
    fill_in "Back up url", with: @app.back_up_url
    fill_in "Github account", with: @app.github_account
    fill_in "Github owner", with: @app.github_owner
    fill_in "Github repo name", with: @app.github_repo_name
    fill_in "Main url", with: @app.main_url
    fill_in "Status", with: @app.status
    fill_in "Subdomain", with: @app.subdomain
    fill_in "User", with: @app.user_id
    click_on "Create App"

    assert_text "App was successfully created"
    click_on "Back"
  end

  test "should update App" do
    visit app_url(@app)
    click_on "Edit this app", match: :first

    fill_in "Anchor url", with: @app.anchor_url
    fill_in "App dashboard", with: @app.app_dashboard_id
    fill_in "Back up url", with: @app.back_up_url
    fill_in "Github account", with: @app.github_account
    fill_in "Github owner", with: @app.github_owner
    fill_in "Github repo name", with: @app.github_repo_name
    fill_in "Main url", with: @app.main_url
    fill_in "Status", with: @app.status
    fill_in "Subdomain", with: @app.subdomain
    fill_in "User", with: @app.user_id
    click_on "Update App"

    assert_text "App was successfully updated"
    click_on "Back"
  end

  test "should destroy App" do
    visit app_url(@app)
    click_on "Destroy this app", match: :first

    assert_text "App was successfully destroyed"
  end
end
