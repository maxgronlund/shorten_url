defmodule ShortenUrlWeb.ErrorJSONTest do
  use ShortenUrlWeb.ConnCase, async: true

  test "renders 404" do
    assert ShortenUrlWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ShortenUrlWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
