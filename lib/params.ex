defmodule Parcel.Params do
  use Maru.Helper
  params :pagination do
    optional :page, type: Integer
    optional :per_page, type: Integer
  end
end
