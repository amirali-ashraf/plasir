require "application_system_test_case"

class StocksTest < ApplicationSystemTestCase
  setup do
    @stock = stocks(:one)
  end

  test "visiting the index" do
    visit stocks_url
    assert_selector "h1", text: "Stocks"
  end

  test "should create stock" do
    visit stocks_url
    click_on "New stock"

    fill_in "Count", with: @stock.count
    fill_in "Shoe model", with: @stock.shoe_model_id
    fill_in "Store", with: @stock.store_id
    click_on "Create Stock"

    assert_text "Stock was successfully created"
    click_on "Back"
  end

  test "should update Stock" do
    visit stock_url(@stock)
    click_on "Edit this stock", match: :first

    fill_in "Count", with: @stock.count
    fill_in "Shoe model", with: @stock.shoe_model_id
    fill_in "Store", with: @stock.store_id
    click_on "Update Stock"

    assert_text "Stock was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock" do
    visit stock_url(@stock)
    click_on "Destroy this stock", match: :first

    assert_text "Stock was successfully destroyed"
  end
end
