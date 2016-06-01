# Copyright (c) 2016, Fredric Dorothy All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

defmodule Parcel do
  defstruct [:items, :page, :page_size, :total_pages, :total_items]

  @type t :: %Parcel {
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
    %Parcel {
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
