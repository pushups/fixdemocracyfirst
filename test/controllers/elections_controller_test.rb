require 'test_helper'

class ElectionsControllerTest < ActionController::TestCase
  setup do
    @election = elections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:elections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create election" do
    assert_difference('Election.count') do
      post :create, election: { election_year: @election.election_year, name: @election.name, office_type_id: @election.office_type_id, rwu_id: @election.rwu_id, special: @election.special, state: @election.state }
    end

    assert_redirected_to election_path(assigns(:election))
  end

  test "should show election" do
    get :show, id: @election
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @election
    assert_response :success
  end

  test "should update election" do
    patch :update, id: @election, election: { election_year: @election.election_year, name: @election.name, office_type_id: @election.office_type_id, rwu_id: @election.rwu_id, special: @election.special, state: @election.state }
    assert_redirected_to election_path(assigns(:election))
  end

  test "should destroy election" do
    assert_difference('Election.count', -1) do
      delete :destroy, id: @election
    end

    assert_redirected_to elections_path
  end
end
