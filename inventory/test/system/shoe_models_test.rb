require "application_system_test_case"

class ShoeModelsTest < ApplicationSystemTestCase
  setup do
    @shoe_model = shoe_models(:one)
  end

  test "visiting the index" do
    visit shoe_models_url
    assert_selector "h1", text: "Shoe models"
  end

  test "should create shoe model" do
    visit shoe_models_url
    click_on "New shoe model"

    fill_in "Name", with: @shoe_model.name
    click_on "Create Shoe model"

    assert_text "Shoe model was successfully created"
    click_on "Back"
  end

  test "should update Shoe model" do
    visit shoe_model_url(@shoe_model)
    click_on "Edit this shoe model", match: :first

    fill_in "Name", with: @shoe_model.name
    click_on "Update Shoe model"

    assert_text "Shoe model was successfully updated"
    click_on "Back"
  end

  test "should destroy Shoe model" do
    visit shoe_model_url(@shoe_model)
    click_on "Destroy this shoe model", match: :first

    assert_text "Shoe model was successfully destroyed"
  end
end
