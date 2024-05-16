# frozen_string_literal: true

require 'application_system_test_case'

class BeispacesTest < ApplicationSystemTestCase
  setup do
    @beispace = beispaces(:one)
  end

  test 'visiting the index' do
    visit beispaces_url
    assert_selector 'h1', text: 'Beispaces'
  end

  test 'should create beispace' do
    visit beispaces_url
    click_on 'New beispace'

    fill_in 'App count', with: @beispace.app_count
    fill_in 'Designation', with: @beispace.designation
    fill_in 'Subdomain', with: @beispace.subdomain
    fill_in 'User', with: @beispace.user_id
    click_on 'Create Beispace'

    assert_text 'Beispace was successfully created'
    click_on 'Back'
  end

  test 'should update Beispace' do
    visit beispace_url(@beispace)
    click_on 'Edit this beispace', match: :first

    fill_in 'App count', with: @beispace.app_count
    fill_in 'Designation', with: @beispace.designation
    fill_in 'Subdomain', with: @beispace.subdomain
    fill_in 'User', with: @beispace.user_id
    click_on 'Update Beispace'

    assert_text 'Beispace was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Beispace' do
    visit beispace_url(@beispace)
    click_on 'Destroy this beispace', match: :first

    assert_text 'Beispace was successfully destroyed'
  end
end
