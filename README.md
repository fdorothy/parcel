# Parcel

Elixir-based pagination on enumerable types.

There are other packages available for pagination. Many packages work on a database backend, such as Ecto. Parcel paginates Elixir enumerables, which means it can work in situations where there is no database backing or it is not convenient to write a single database query.

## Installation

Parcel is just one file. Everything you need is contained within lib/parcel.ex. Copy lib/parcel.ex into your project, configure and enjoy.

## Configuration

Parcel has a few configuration options.

```elixir
config :parcel,
  defaults: [
    max_page_size: 20,
    page_size: 10
  ]
```

## Usage

```elixir
iex(1)> Parcel.paginate(1..100, [page: 1, page_size: 10])
%Parcel{items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], page: 1, page_size: 10,
 total_items: 100, total_pages: 10}
```

If you do not pass in a page size it will use the default value in the configuration.

```elixir
iex(2)> Parcel.paginate(1..100, [page: 1])
%Parcel{items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], page: 1, page_size: 10,
 total_items: 100, total_pages: 10}
```

## License

Parcel is released under a BSD-3 license. See LICENSE in the source code for more information.