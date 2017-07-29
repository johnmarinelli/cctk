require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "CCTK"
    assert_equal full_title("a"), "a | CCTK"
  end

end
