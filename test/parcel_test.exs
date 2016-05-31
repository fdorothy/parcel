defmodule ParcelTest do
  use ExUnit.Case

  defmodule Hundred do
    use Maru.Router
    helpers Parcel.Params
    params do
      use :pagination
    end
    get do
      data = 1..100

      # paginate the response
      json(conn, Parcel.Pagination.paginate(1..100, params))
    end
  end

  defmodule HundredTest do
    use Maru.Test, for: Hundred

    def query(params) do
      resp = conn(:get, "/", params)
      |> make_response
      |> Map.fetch!(:resp_body)
      |> Poison.decode!
    end
  end

  test "we can get the first 10 results" do
    assert %{"data" => Enum.to_list(1..10), "page" => 0, "per_page" => 10, "total_pages" => 10} == HundredTest.query(%{page: 0, per_page: 10})
  end
end
