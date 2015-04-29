require 'test_helper'

class StatementsControllerTest < ActionController::TestCase
  setup do
    @statement = statements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create statement" do
    assert_difference('Statement.count') do
      post :create, statement: { approved: @statement.approved, campaign_id: @statement.campaign_id, candidate_id: @statement.candidate_id, description: @statement.description, event_day_id: @statement.event_day_id, rwu_id: @statement.rwu_id, title: @statement.title, ugc_candidate_name: @statement.ugc_candidate_name, ugc_date: @statement.ugc_date.strftime('%m/%d/%Y'), ugc_event_location: @statement.ugc_event_location, ugc_event_title: @statement.ugc_event_title, ugc_notes: @statement.ugc_notes, url: @statement.url, user_id: @statement.user_id, third_party_url: @statement.third_party_url}
    end

    assert_redirected_to statement_path(assigns(:statement))
  end

  test "should show statement" do
    get :show, id: @statement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @statement
    assert_response :success
  end

  test "should update statement" do
    patch :update, id: @statement, statement: { approved: @statement.approved, campaign_id: @statement.campaign_id, candidate_id: @statement.candidate_id, description: @statement.description, event_day_id: @statement.event_day_id, rwu_id: @statement.rwu_id, title: @statement.title, ugc_candidate_name: @statement.ugc_candidate_name, ugc_date: @statement.ugc_date.strftime('%m/%d/%Y'), ugc_event_location: @statement.ugc_event_location, ugc_event_title: @statement.ugc_event_title, ugc_notes: @statement.ugc_notes, url: @statement.url, user_id: @statement.user_id, third_party_url: @statement.third_party_url }
    assert_redirected_to statement_path(assigns(:statement))
  end

  test "should destroy statement" do
    assert_difference('Statement.count', -1) do
      delete :destroy, id: @statement
    end

    assert_redirected_to statements_path
  end
end
