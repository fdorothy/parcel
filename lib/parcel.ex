defmodule Parcel.Pagination do
  defstruct page: 0,
    total_pages: 0,
    per_page: 10,
    data: []

  @type t :: %Parcel.Pagination {
    page: integer,
    total_pages: integer,
    per_page: integer,
    data: List.t
  }

  def paginate(conn, data, params) do
    opts =
      Keyword.merge(Application.get_env(:parcel, :defaults),
	[
	  per_page: params[:per_page],
	  page_size: params[:page_size]
	]
      )
    per_page = Enum.min([opts[:max_page_size], opts[:per_page]])
    pages = Kernel.trunc(Float.ceil(Enum.count(data) / per_page))

    cur_page = Enum.min([Enum.max([opts[:page], 0]), pages])
    cur_data = Enum.slice(data, cur_page*per_page, per_page)

    %Parcel.Pagination {
      page: cur_page,
      total_pages: pages,
      per_page: per_page,
      data: cur_data
    }
  end
end
