require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "成功の物語"
    assert_equal full_title("Help"), "Help | 成功の物語"
  end
end