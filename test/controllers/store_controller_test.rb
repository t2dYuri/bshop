require 'test_helper'

class StoreControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_select '.entry', minimum: 3
    assert_select 'h4', "#{ products(:bike).title }"
    assert_match products(:bike).description, response.body
    assert_match /with performance that's anything but entry-level/, response.body
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

end
