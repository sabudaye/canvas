defmodule CanvasWeb.CanvasController do
  use CanvasWeb, :controller

  alias Canvas.Feature.Drawing
  alias Canvas.{FloodFill, Rectangle}

  def new(conn, %{"canvas" => canvas_params}) do
    with %{"rows" => rows, "cols" => cols, "fill_char" => fill_char} <- canvas_params,
         {:ok, canvas} <- Drawing.new(rows, cols, fill_char) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.canvas_path(conn, :show, canvas))
      |> render("show.json", %{canvas: canvas})
    else
      {:error, message} -> send_error(conn, message)
      _ -> send_error(conn, "missing required parameter")
    end
  end

  def show(conn, %{"id" => canvas_id}) do
    with {:ok, canvas} <- Drawing.get(canvas_id) do
      render(conn, "show.json", %{canvas: canvas})
    else
      {:error, message} -> send_error(conn, message)
    end
  end

  def draw(conn, %{"id" => canvas_id, "rectangle" => rectangle_params}) do
    with %{"row" => row, "col" => col, "width" => width, "height" => height} <- rectangle_params,
         rectangle <- %Rectangle{
           pos_row: to_int(row),
           pos_col: to_int(col),
           width: to_int(width),
           height: to_int(height),
           fill_char: rectangle_params["fc"],
           outline_char: rectangle_params["oc"]
         },
         {:ok, new_canvas} <- Drawing.add_rectangle(canvas_id, rectangle) do
      render(conn, "show.json", %{canvas: new_canvas})
    else
      {:error, message} -> send_error(conn, message)
      _ -> send_error(conn, "missing required parameter")
    end
  end

  def draw(conn, %{"id" => canvas_id, "flood_fill" => flood_fill_params}) do
    with %{"row" => row, "col" => col, "fc" => fc} <- flood_fill_params,
         flood_fill <- %FloodFill{
           pos_row: to_int(row),
           pos_col: to_int(col),
           flood_char: fc
         },
         {:ok, new_canvas} <- Drawing.flood_fill(canvas_id, flood_fill) do
      render(conn, "show.json", %{canvas: new_canvas})
    else
      {:error, message} -> send_error(conn, message)
      _ -> send_error(conn, "missing required parameter")
    end
  end

  def draw(conn, _params) do
    send_error(conn, "drawing parameters are not correct")
  end

  def send_error(conn, message) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: message})
  end

  defp to_int(val) when is_integer(val), do: val
  defp to_int(val) when is_binary(val), do: String.to_integer(val)
end
