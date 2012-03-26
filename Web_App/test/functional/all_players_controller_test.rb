require 'test_helper'

class AllPlayersControllerTest < ActionController::TestCase
  setup do
    @all_player = all_players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:all_players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create all_player" do
    assert_difference('AllPlayer.count') do
      post :create, all_player: @all_player.attributes
    end

    assert_redirected_to all_player_path(assigns(:all_player))
  end

  test "should show all_player" do
    get :show, id: @all_player.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @all_player.to_param
    assert_response :success
  end

  test "should update all_player" do
    put :update, id: @all_player.to_param, all_player: @all_player.attributes
    assert_redirected_to all_player_path(assigns(:all_player))
  end

  test "should destroy all_player" do
    assert_difference('AllPlayer.count', -1) do
      delete :destroy, id: @all_player.to_param
    end

    assert_redirected_to all_players_path
  end
end
