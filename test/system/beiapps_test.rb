# frozen_string_literal: true

require 'application_system_test_case'

class BeiappsTest < ApplicationSystemTestCase
  setup do
    @beiapp = beiapps(:one)
  end

  test 'visiting the index' do
    visit beiapps_url
    assert_selector 'h1', text: 'Beiapps'
  end

  test 'should create beiapp' do
    visit beiapps_url
    click_on 'New beiapp'

    fill_in 'Application stack', with: @beiapp.application_stack
    fill_in 'Beispace', with: @beiapp.beispace_id
    fill_in 'Code stack', with: @beiapp.code_stack
    fill_in 'Code stack version', with: @beiapp.code_stack_version
    fill_in 'Database stack', with: @beiapp.database_stack
    fill_in 'Database version', with: @beiapp.database_version
    fill_in 'Name', with: @beiapp.name
    fill_in 'Owner contact email', with: @beiapp.owner_contact_email
    fill_in 'Owner contact phone', with: @beiapp.owner_contact_phone
    fill_in 'Owner location', with: @beiapp.owner_location
    fill_in 'Owner name', with: @beiapp.owner_name
    fill_in 'Owner social github', with: @beiapp.owner_social_github
    fill_in 'Owner social instagram', with: @beiapp.owner_social_instagram
    fill_in 'Owner social twitter', with: @beiapp.owner_social_twitter
    fill_in 'Owner website', with: @beiapp.owner_website
    fill_in 'Primary dependency stack', with: @beiapp.primary_dependency_stack
    fill_in 'Summary', with: @beiapp.summary
    click_on 'Create Beiapp'

    assert_text 'Beiapp was successfully created'
    click_on 'Back'
  end

  test 'should update Beiapp' do
    visit beiapp_url(@beiapp)
    click_on 'Edit this beiapp', match: :first

    fill_in 'Application stack', with: @beiapp.application_stack
    fill_in 'Beispace', with: @beiapp.beispace_id
    fill_in 'Code stack', with: @beiapp.code_stack
    fill_in 'Code stack version', with: @beiapp.code_stack_version
    fill_in 'Database stack', with: @beiapp.database_stack
    fill_in 'Database version', with: @beiapp.database_version
    fill_in 'Name', with: @beiapp.name
    fill_in 'Owner contact email', with: @beiapp.owner_contact_email
    fill_in 'Owner contact phone', with: @beiapp.owner_contact_phone
    fill_in 'Owner location', with: @beiapp.owner_location
    fill_in 'Owner name', with: @beiapp.owner_name
    fill_in 'Owner social github', with: @beiapp.owner_social_github
    fill_in 'Owner social instagram', with: @beiapp.owner_social_instagram
    fill_in 'Owner social twitter', with: @beiapp.owner_social_twitter
    fill_in 'Owner website', with: @beiapp.owner_website
    fill_in 'Primary dependency stack', with: @beiapp.primary_dependency_stack
    fill_in 'Summary', with: @beiapp.summary
    click_on 'Update Beiapp'

    assert_text 'Beiapp was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Beiapp' do
    visit beiapp_url(@beiapp)
    click_on 'Destroy this beiapp', match: :first

    assert_text 'Beiapp was successfully destroyed'
  end
end
