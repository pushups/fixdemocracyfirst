require 'test_helper'

class EventDaysControllerTest < ActionController::TestCase
  setup do
    @event_day = event_days(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_days)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_day" do
    assert_difference('EventDay.count') do
      post :create, event_day: { date: @event_day.date, end_time: @event_day.end_time, event_id: @event_day.event_id, rwu_id: @event_day.rwu_id, start_time: @event_day.start_time }
    end

    assert_redirected_to event_day_path(assigns(:event_day))
  end

  test "should show event_day" do
    get :show, id: @event_day
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_day
    assert_response :success
  end

  test "should update event_day" do
    patch :update, id: @event_day, event_day: { date: @event_day.date, end_time: @event_day.end_time, event_id: @event_day.event_id, rwu_id: @event_day.rwu_id, start_time: @event_day.start_time }
    assert_redirected_to event_day_path(assigns(:event_day))
  end

  test "should destroy event_day" do
    assert_difference('EventDay.count', -1) do
      delete :destroy, id: @event_day
    end

    assert_redirected_to event_days_path
  end
end
