defmodule Mattslasher.MattermostTable do
  @moduledoc """
  Module for rendering mattermost table
  """

  defstruct [
    alignments: [],
    rows:       [],
  ]

  @typedoc """
  Represents a mattermost table with
  - alignments: as list of alignment for each column
  - rows: as list of all rows (first row is header row)
  """
  @type t :: %__MODULE__{alignments: List.t, rows: List.t}

  @doc ~S"""
  Renders mattermost table

   ## Example
    iex> render_table(%Mattslasher.MattermostTable{})
    ""
    iex> render_table(%Mattslasher.MattermostTable{alignments: ["c", "l", "r"], rows: [["foo", "bar", "baz"], ["test", "test1", "test2"]]})
    "|foo|bar|baz|\n|:-:|:-|-:|\n|test|test1|test2|\n"
  """
  @spec render_table(Mattslasher.MattermostTable.t) :: String.t
  def render_table(table_struct) do
    {header_row, popped_list} = List.pop_at(table_struct.rows, 0)

    if nil === header_row do
      ""
    else
      table = render_table_row(header_row)
      table = table <> render_alignment_row(table_struct.alignments)
      render_table_rows(popped_list, table)
    end
  end

  defp alignment_to_string(alignment) do
    case alignment do
      "c" ->
        ":-:"
      "l" ->
        ":-"
      "r" ->
        "-:"
      _ ->
        ":-"
    end
  end

  defp render_alignment_row(alignments) do
    if [] === alignments do
      ""
    else
      row = Enum.reduce(
        alignments,
        "",
        fn(alignment, acc) -> acc <> "|" <> alignment_to_string(alignment) end
      )

      row <> "|\n"
    end
  end

  defp render_table_rows(rows, table) do
    {row, popped_list} = List.pop_at(rows, 0)

    table_rows =
      if row != nil do
        render_table_rows(popped_list, table <> render_table_row(row))
      else
        table
      end
    
    table_rows
  end

  defp render_table_row(columns) do
    row = Enum.reduce(
      columns,
      "",
      fn(column, acc) -> acc <> "|" <> column end
    )

    row <> "|\n"
  end
end