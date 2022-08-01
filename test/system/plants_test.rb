require "application_system_test_case"

class PlantsTest < ApplicationSystemTestCase
  setup do
    @plant = Plant.ordered.first
  end

  test "Showing a plant" do
    visit plants_path
    click_link @plant.scientific
    assert_selector "h1", text: @plant.scientific
  end

  test "Creating a new plant" do
    visit plants_path
    #assert_selector "h1", text: "Plants"

    click_on "New plant"
    fill_in :plant_scientific, with: "Capybara plant"
    select "Tramil", from: :plant_pharmacopoeia
    select "Zingiberaceae", from: :plant_family

  #  assert_selector "h1", text: "Plants"
    click_on "create a new plant"

  #  assert_selector "h1", text: "Plants"
    assert_text "Capybara plant"
  end

  test "Updating a plant" do
    visit plants_path
    find(:css,'.edit').click
    fill_in :plant_scientific, with: "Updated plant"
    click_on "Save change"
    assert_text "Updated plant"
  end

  test "Destroying a plant" do
    visit plants_path
    assert_text @plant.scientific

    #click_on "delete", match: :first
    accept_alert do
        find(:css,'.delete').click
    end
    assert_no_text @plant.scientific
  end
end
