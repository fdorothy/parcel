defmodule Parcel.Pagination do
  defstruct [:items, :page, :page_size, :total_pages, :total_items]

  @type t :: %Parcel.Pagination {
    items: List.t,
    page: integer,
    page_size: integer,
    total_pages: integer,
    total_items: integer
  }

  def paginate(items, params) do
    config = Application.get_env(:parcel, :defaults)
    paginate(
      items,
      params[:page] || 1,
      case params[:page_size] do
	nil -> config[:page_size]
	page_size -> clamp(page_size, 1, config[:max_page_size])
      end
    )
  end

  defp paginate(items, page, page_size) do
    total_items = Enum.count(items)
    total_pages = Enum.max([1, ceil(total_items / page_size)])
    page = clamp(page, 1, total_pages)
    offset = (page-1)*page_size
    page_items = Enum.slice(items, offset, page_size)
    %Parcel.Pagination {
      items: page_items,
      page: page,
      page_size: page_size,
      total_pages: total_pages,
      total_items: total_items
    }
  end

  defp ceil(x), do: Kernel.trunc(Float.ceil(x))
  defp clamp(x, a, b), do: Enum.min([Enum.max([x, a]), b])
end
