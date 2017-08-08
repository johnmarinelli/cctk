require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def  setup 
    @base_title = 'CCTK'
  end

  test "should get root" do
    get root_path
    assert_response :success
  end

  test "should go to user page if logged in" do
    log_in_as users(:one), 'password1'
    get root_path
    assert_redirected_to users(:one)
  end

  test "should get about" do
    get about_path
    assert_select "title", "About | #{@base_title}"
    assert_response :success
  end

end
