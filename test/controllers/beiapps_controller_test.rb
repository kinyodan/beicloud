# frozen_string_literal: true

require 'test_helper'

class BeiappsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beiapp = beiapps(:one)
  end

  test 'should get index' do
    get beiapps_url
    assert_response :success
  end

  test 'should get new' do
    get new_beiapp_url
    assert_response :success
  end

  test 'should create beiapp' do
    assert_difference('Beiapp.count') do
      post beiapps_url,
           params: { beiapp: { application_stack: @beiapp.application_stack, beispace_id: @beiapp.beispace_id,
                               code_stack: @beiapp.code_stack, code_stack_version: @beiapp.code_stack_version, database_stack: @beiapp.database_stack, database_version: @beiapp.database_version, name: @beiapp.name, owner_contact_email: @beiapp.owner_contact_email, owner_contact_phone: @beiapp.owner_contact_phone, owner_location: @beiapp.owner_location, owner_name: @beiapp.owner_name, owner_social_github: @beiapp.owner_social_github, owner_social_instagram: @beiapp.owner_social_instagram, owner_social_twitter: @beiapp.owner_social_twitter, owner_website: @beiapp.owner_website, primary_dependency_stack: @beiapp.primary_dependency_stack, summary: @beiapp.summary } }
    end

    assert_redirected_to beiapp_url(Beiapp.last)
  end

  test 'should show beiapp' do
    get beiapp_url(@beiapp)
    assert_response :success
  end

  test 'should get edit' do
    get edit_beiapp_url(@beiapp)
    assert_response :success
  end

  test 'should update beiapp' do
    patch beiapp_url(@beiapp),
          params: { beiapp: { application_stack: @beiapp.application_stack, beispace_id: @beiapp.beispace_id,
                              code_stack: @beiapp.code_stack, code_stack_version: @beiapp.code_stack_version, database_stack: @beiapp.database_stack, database_version: @beiapp.database_version, name: @beiapp.name, owner_contact_email: @beiapp.owner_contact_email, owner_contact_phone: @beiapp.owner_contact_phone, owner_location: @beiapp.owner_location, owner_name: @beiapp.owner_name, owner_social_github: @beiapp.owner_social_github, owner_social_instagram: @beiapp.owner_social_instagram, owner_social_twitter: @beiapp.owner_social_twitter, owner_website: @beiapp.owner_website, primary_dependency_stack: @beiapp.primary_dependency_stack, summary: @beiapp.summary } }
    assert_redirected_to beiapp_url(@beiapp)
  end

  test 'should destroy beiapp' do
    assert_difference('Beiapp.count', -1) do
      delete beiapp_url(@beiapp)
    end

    assert_redirected_to beiapps_url
  end
end
