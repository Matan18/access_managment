defmodule AccessManagmentWeb.ErrorJSONTest do
  use AccessManagmentWeb.ConnCase, async: true

  test "renders 404" do
    assert AccessManagmentWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{message: "Not Found"}
           }
  end

  test "renders 500" do
    assert AccessManagmentWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{message: "Internal Server Error"}}
  end
end
