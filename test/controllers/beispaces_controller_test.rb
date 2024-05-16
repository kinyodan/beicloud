# frozen_string_literal: true

require 'test_helper'

class BeispacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beispace = beispaces(:one)
  end

  test 'should get index' do
    get beispaces_url
    assert_response :success
  end

  test 'should get new' do
    get new_beispace_url
    assert_response :success
  end

  test 'should create beispace' do
    assert_difference('Beispace.count') do
      post beispaces_url,
           params: { beispace: { app_count: @beispace.app_count, designation: @beispace.designation,
                                 subdomain: @beispace.subdomain, user_id: @beispace.user_id } }
    end

    assert_redirected_to beispace_url(Beispace.last)
  end

  test 'should show beispace' do
    get beispace_url(@beispace)
    assert_response :success
  end

  test 'should get edit' do
    get edit_beispace_url(@beispace)
    assert_response :success
  end

  test 'should update beispace' do
    patch beispace_url(@beispace),
          params: { beispace: { app_count: @beispace.app_count, designation: @beispace.designation,
                                subdomain: @beispace.subdomain, user_id: @beispace.user_id } }
    assert_redirected_to beispace_url(@beispace)
  end

  test 'should destroy beispace' do
    assert_difference('Beispace.count', -1) do
      delete beispace_url(@beispace)
    end

    assert_redirected_to beispaces_url
  end
end
