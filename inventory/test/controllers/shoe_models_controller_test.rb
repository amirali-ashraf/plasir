require "test_helper"

class ShoeModelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shoe_model = shoe_models(:one)
  end

  test "should get index" do
    get shoe_models_url
    assert_response :success
  end

  test "should get new" do
    get new_shoe_model_url
    assert_response :success
  end

  test "should create shoe_model" do
    assert_difference("ShoeModel.count") do
      post shoe_models_url, params: { shoe_model: { name: @shoe_model.name } }
    end

    assert_redirected_to shoe_model_url(ShoeModel.last)
  end

  test "should show shoe_model" do
    get shoe_model_url(@shoe_model)
    assert_response :success
  end

  test "should get edit" do
    get edit_shoe_model_url(@shoe_model)
    assert_response :success
  end

  test "should update shoe_model" do
    patch shoe_model_url(@shoe_model), params: { shoe_model: { name: @shoe_model.name } }
    assert_redirected_to shoe_model_url(@shoe_model)
  end

  test "should destroy shoe_model" do
    assert_difference("ShoeModel.count", -1) do
      delete shoe_model_url(@shoe_model)
    end

    assert_redirected_to shoe_models_url
  end
end
