require "application_system_test_case"

class SourcesTest < ApplicationSystemTestCase
  setup do
    @source = sources(:first)
  end

  test "Creating a New Source with a New author" do
    visit sources_path
    assert_selector "li" text: "Plantes", "Bibliographie", "Citations", "Auteurs"
    click_on "New Source"
    assert_selector "li" text: "Plantes", "Bibliographie", "Citations", "Auteurs"
    assert_selector "h1", text: "New Source"
    fill_in "Create a new author.first_name", with: "Baillon"
    fill_in "Create a new author.last_name", with: "Henri"
    fill_in "Create a new area", with: "Martinique "
    fill_in "Title", with: " "
    fill_in "Publication date", with: " "
    fill_in "Edition Reference", with: " "
    fill_in "Link", with: " "
    fill_in "Ex Archive", with: " "
    fill_in "Origin", with: " "
    fill_in "note", with: " "
    click_on "Create A New Source"
    assert_selector "li" text: "Plantes", "Bibliographie", "Citations", "Auteurs"
    assert_text " "
  end

  
