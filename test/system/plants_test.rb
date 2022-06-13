require "application_system_test_case"

class PlantsTest < ApplicationSystemTestCase
  setup do
    @plant = Plant.ordered.first
  end

  #test "Showing a plant" do
  #  visit plants_path
  #  click_link @plant.name

  #  assert_selector "h1", text: @plant.name
#  end

  test "Creating a new plant" do
    visit plants_path
    assert_selector "h1", text: "Plants"

    click_on "New plant"
    fill_in :plant_scientific, with: "Capybara plant"
    select "Amaranthaceae", from: :plant_pharmacopoeia
    select "none", from: :plant_family

    assert_selector "h1", text: "Plants"
    click_on "create this plant"

    assert_selector "h1", text: "Plants"
    assert_text "Capybara plant"
  end

  #test "Updating a plant" do
  #  visit plants_path
  #  assert_selector "h1", text: "Plants"

  #  click_on "Edit", match: :first
  #  fill_in "Name", with: "Updated plant"

  #  assert_selector "h1", text: "Plants"
  #  click_on "Update plant"

  #  assert_selector "h1", text: "Plants"
  #  assert_text "Updated plant"
  #end

#  test "Destroying a plant" do
#    visit plants_path
#    assert_text @plant.name

#    click_on "Delete", match: :first
#    assert_no_text @plant.name
#  end
end
