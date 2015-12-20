defmodule Blog.UserNavigationTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "user can navigate to blog from home page" do
    navigate_to("/")
    click("blog")

    assert(currentpath() == "/blog")
  end
end
