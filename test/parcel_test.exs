defmodule ParcelTest do
  use ExUnit.Case

  def query(items, params) do
    Parcel.paginate(items, params)
  end

  def check(items, page, page_size, expected_items, expected_total_pages) do
    assert %Parcel {
      items: Enum.to_list(expected_items),
      page: page,
      page_size: page_size,
      total_pages: expected_total_pages,
      total_items: Enum.count(items)
    } == query(items, %{page: page, page_size: page_size})
  end

  test "we can paginate through items" do
    check(1..100, 1, 10, 1..10, 10)
    check(1..100, 2, 10, 11..20, 10)
    check(1..100, 10, 10, 91..100, 10)

    check(1..18, 1, 10, 1..10, 2)
    check(1..18, 2, 10, 11..18, 2)

    check(1..10, 1, 20, 1..10, 1)
  end

  test "pages are clamped" do
    assert %Parcel {
      items: Enum.to_list(6..10),
      page: 2,
      page_size: 5,
      total_pages: 2,
      total_items: 10
    } == query(1..10, %{page: 3, page_size: 5})

    assert %Parcel {
      items: Enum.to_list(1..5),
      page: 1,
      page_size: 5,
      total_pages: 2,
      total_items: 10
    } == query(1..10, %{page: 0, page_size: 5})
  end

  test "empty list of data returns 1 page" do
    check([], 1, 10, [], 1)
  end

  test "minimum of 1 page size" do
    assert %Parcel {
      items: [1],
      page: 1,
      page_size: 1,
      total_pages: 10,
      total_items: 10
    } == query(1..10, %{page: 1, page_size: 0})
  end

  test "maximum page size as specified in config" do
    assert %Parcel {
      items: Enum.to_list(1..20),
      page: 1,
      page_size: 20,
      total_pages: 5,
      total_items: 100
    } == query(1..100, %{page: 1, page_size: 1000})
  end
end
