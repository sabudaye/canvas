defmodule CanvasWeb.CanvasControllerTest do
  use CanvasWeb.ConnCase

  describe "create canvas" do
    test "renders canvas when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 3, cols: 3, fill_char: " "})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => id,
               "rows" => 3,
               "cols" => 3,
               "chars" => %{
                 "0" => %{"0" => " ", "1" => " ", "2" => " "},
                 "1" => %{"0" => " ", "1" => " ", "2" => " "},
                 "2" => %{"0" => " ", "1" => " ", "2" => " "}
               }
             } = json_response(conn, 200)["data"]
    end

    test "returns error when row number is not valid", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 0, cols: 3, fill_char: " "})

      assert %{"error" => "Rows number is out of range (1 to 200)"} = json_response(conn, 422)
    end

    test "returns error when fill char is not valid ASCII char", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 3, cols: 3, fill_char: "Ф"})

      assert %{"error" => "Ф is not a single ASCII char"} = json_response(conn, 422)
    end

    test "returns error when fill char is not defined", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 3, cols: 3})

      assert %{"error" => "missing required parameter"} = json_response(conn, 422)
    end
  end

  describe "draw rectangle" do
    test "draws rectangle on canvas when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 3, cols: 3, fill_char: " "})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 0, row: 0, width: 2, height: 2, fc: "O"}
        )

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => id,
               "rows" => 3,
               "cols" => 3,
               "chars" => %{
                 "0" => %{"0" => "O", "1" => "O", "2" => " "},
                 "1" => %{"0" => "O", "1" => "O", "2" => " "},
                 "2" => %{"0" => " ", "1" => " ", "2" => " "}
               }
             } = json_response(conn, 200)["data"]
    end

    test "returns error when rectangle paramteres are not valid", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 3, cols: 3, fill_char: " "})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 0, row: 0, height: 2, fc: "O"}
        )

      assert %{"error" => "missing required parameter"} = json_response(conn, 422)

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 0, row: 0, width: 2, height: 2}
        )

      assert %{"error" => "One of either fill or outline character should always be present"} =
               json_response(conn, 422)

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: -1, row: 201, width: 2, height: 2}
        )

      assert %{"error" => "Row position is out of canvas max size (1 to 200)"} =
               json_response(conn, 422)
    end
  end

  describe "Test fixture 1" do
    test "renders canvas of 24x9 size and two rectangles on it", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 9, cols: 24, fill_char: " "})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 3, row: 2, width: 5, height: 3, oc: "@", fc: "X"}
        )

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 10, row: 3, width: 14, height: 6, oc: "X", fc: "O"}
        )

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => id,
               "rows" => 9,
               "cols" => 24,
               "chars" => %{
                 "0" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => " ",
                   "11" => " ",
                   "12" => " ",
                   "13" => " ",
                   "14" => " ",
                   "15" => " ",
                   "16" => " ",
                   "17" => " ",
                   "18" => " ",
                   "19" => " ",
                   "20" => " ",
                   "21" => " ",
                   "22" => " ",
                   "23" => " "
                 },
                 "1" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => " ",
                   "11" => " ",
                   "12" => " ",
                   "13" => " ",
                   "14" => " ",
                   "15" => " ",
                   "16" => " ",
                   "17" => " ",
                   "18" => " ",
                   "19" => " ",
                   "20" => " ",
                   "21" => " ",
                   "22" => " ",
                   "23" => " "
                 },
                 "2" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => "@",
                   "4" => "@",
                   "5" => "@",
                   "6" => "@",
                   "7" => "@",
                   "8" => " ",
                   "9" => " ",
                   "10" => " ",
                   "11" => " ",
                   "12" => " ",
                   "13" => " ",
                   "14" => " ",
                   "15" => " ",
                   "16" => " ",
                   "17" => " ",
                   "18" => " ",
                   "19" => " ",
                   "20" => " ",
                   "21" => " ",
                   "22" => " ",
                   "23" => " "
                 },
                 "3" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => "@",
                   "4" => "X",
                   "5" => "X",
                   "6" => "X",
                   "7" => "@",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "X",
                   "12" => "X",
                   "13" => "X",
                   "14" => "X",
                   "15" => "X",
                   "16" => "X",
                   "17" => "X",
                   "18" => "X",
                   "19" => "X",
                   "20" => "X",
                   "21" => "X",
                   "22" => "X",
                   "23" => "X"
                 },
                 "4" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => "@",
                   "4" => "@",
                   "5" => "@",
                   "6" => "@",
                   "7" => "@",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "O",
                   "12" => "O",
                   "13" => "O",
                   "14" => "O",
                   "15" => "O",
                   "16" => "O",
                   "17" => "O",
                   "18" => "O",
                   "19" => "O",
                   "20" => "O",
                   "21" => "O",
                   "22" => "O",
                   "23" => "X"
                 },
                 "5" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "O",
                   "12" => "O",
                   "13" => "O",
                   "14" => "O",
                   "15" => "O",
                   "16" => "O",
                   "17" => "O",
                   "18" => "O",
                   "19" => "O",
                   "20" => "O",
                   "21" => "O",
                   "22" => "O",
                   "23" => "X"
                 },
                 "6" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "O",
                   "12" => "O",
                   "13" => "O",
                   "14" => "O",
                   "15" => "O",
                   "16" => "O",
                   "17" => "O",
                   "18" => "O",
                   "19" => "O",
                   "20" => "O",
                   "21" => "O",
                   "22" => "O",
                   "23" => "X"
                 },
                 "7" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "O",
                   "12" => "O",
                   "13" => "O",
                   "14" => "O",
                   "15" => "O",
                   "16" => "O",
                   "17" => "O",
                   "18" => "O",
                   "19" => "O",
                   "20" => "O",
                   "21" => "O",
                   "22" => "O",
                   "23" => "X"
                 },
                 "8" => %{
                   "0" => " ",
                   "1" => " ",
                   "2" => " ",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => " ",
                   "8" => " ",
                   "9" => " ",
                   "10" => "X",
                   "11" => "X",
                   "12" => "X",
                   "13" => "X",
                   "14" => "X",
                   "15" => "X",
                   "16" => "X",
                   "17" => "X",
                   "18" => "X",
                   "19" => "X",
                   "20" => "X",
                   "21" => "X",
                   "22" => "X",
                   "23" => "X"
                 }
               }
             } = json_response(conn, 200)["data"]
    end
  end

  describe "Test fixture 3" do
    test "renders canvas of 21x8 size, three rectangles on it and a flood fiil", %{conn: conn} do
      conn =
        post(conn, Routes.canvas_path(conn, :new), canvas: %{rows: 8, cols: 21, fill_char: " "})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 14, row: 0, width: 7, height: 6, fc: "."}
        )

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 0, row: 3, width: 8, height: 4, oc: "O"}
        )

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id),
          rectangle: %{col: 5, row: 5, width: 5, height: 3, oc: "X", fc: "X"}
        )

      conn =
        post(conn, Routes.canvas_path(conn, :draw, id), flood_fill: %{col: 0, row: 0, fc: "-"})

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => id,
               "rows" => 8,
               "cols" => 21,
               "chars" => %{
                 "0" => %{
                   "0" => "-",
                   "1" => "-",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => "-",
                   "20" => ".",
                   "3" => "-",
                   "4" => "-",
                   "5" => "-",
                   "6" => "-",
                   "7" => "-",
                   "8" => "-",
                   "9" => "-"
                 },
                 "1" => %{
                   "0" => "-",
                   "1" => "-",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => "-",
                   "20" => ".",
                   "3" => "-",
                   "4" => "-",
                   "5" => "-",
                   "6" => "-",
                   "7" => "-",
                   "8" => "-",
                   "9" => "-"
                 },
                 "2" => %{
                   "0" => "-",
                   "1" => "-",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => "-",
                   "20" => ".",
                   "3" => "-",
                   "4" => "-",
                   "5" => "-",
                   "6" => "-",
                   "7" => "-",
                   "8" => "-",
                   "9" => "-"
                 },
                 "3" => %{
                   "0" => "O",
                   "1" => "O",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => "O",
                   "20" => ".",
                   "3" => "O",
                   "4" => "O",
                   "5" => "O",
                   "6" => "O",
                   "7" => "O",
                   "8" => "-",
                   "9" => "-"
                 },
                 "4" => %{
                   "0" => "O",
                   "1" => " ",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => " ",
                   "20" => ".",
                   "3" => " ",
                   "4" => " ",
                   "5" => " ",
                   "6" => " ",
                   "7" => "O",
                   "8" => "-",
                   "9" => "-"
                 },
                 "5" => %{
                   "0" => "O",
                   "1" => " ",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => ".",
                   "15" => ".",
                   "16" => ".",
                   "17" => ".",
                   "18" => ".",
                   "19" => ".",
                   "2" => " ",
                   "20" => ".",
                   "3" => " ",
                   "4" => " ",
                   "5" => "X",
                   "6" => "X",
                   "7" => "X",
                   "8" => "X",
                   "9" => "X"
                 },
                 "6" => %{
                   "0" => "O",
                   "1" => "O",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => "-",
                   "15" => "-",
                   "16" => "-",
                   "17" => "-",
                   "18" => "-",
                   "19" => "-",
                   "2" => "O",
                   "20" => "-",
                   "3" => "O",
                   "4" => "O",
                   "5" => "X",
                   "6" => "X",
                   "7" => "X",
                   "8" => "X",
                   "9" => "X"
                 },
                 "7" => %{
                   "0" => " ",
                   "1" => " ",
                   "10" => "-",
                   "11" => "-",
                   "12" => "-",
                   "13" => "-",
                   "14" => "-",
                   "15" => "-",
                   "16" => "-",
                   "17" => "-",
                   "18" => "-",
                   "19" => "-",
                   "2" => " ",
                   "20" => "-",
                   "3" => " ",
                   "4" => " ",
                   "5" => "X",
                   "6" => "X",
                   "7" => "X",
                   "8" => "X",
                   "9" => "X"
                 }
               }
             } = json_response(conn, 200)["data"]
    end
  end
end
