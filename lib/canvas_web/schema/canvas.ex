defmodule CanvasWeb.Schema do
  alias OpenApiSpex.Schema

  defmodule CreateCanvas do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CreateCanvas",
      description: "Parameters to create canvas to draw on",
      type: :object,
      properties: %{
        rows: %Schema{
          type: :integer,
          description: "A number of characters rows on canvas",
          minimum: 1,
          maximum: 200
        },
        cols: %Schema{
          type: :integer,
          description: "A number of characters columns on canvas",
          minimum: 1,
          maximum: 200
        },
        fill_char: %Schema{
          type: :string,
          description: "Character used to fill in canvas",
          minLength: 1,
          maxLength: 1
        }
      },
      required: [:rows, :cols, :fill_char],
      example: %{
        "rows" => 3,
        "cols" => 3,
        "fill_char" => " "
      }
    })
  end

  defmodule Canvas do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Canvas",
      description: "A canvas to draw on",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Unique Canvas identifier"},
        rows: %Schema{
          type: :integer,
          description: "A number of characters rows on canvas",
          minimum: 1,
          maximum: 200
        },
        cols: %Schema{
          type: :integer,
          description: "A number of characters columns on canvas",
          minimum: 1,
          maximum: 200
        },
        chars: %Schema{type: :object, description: "Character mapping on canvas"}
      },
      required: [:rows, :cols, :fill_char],
      example: %{
        "id" => 1,
        "rows" => 3,
        "cols" => 3,
        "chars" => %{
          "0" => %{"0" => "O", "1" => "O", "2" => " "},
          "1" => %{"0" => "O", "1" => "O", "2" => " "},
          "2" => %{"0" => " ", "1" => " ", "2" => " "}
        }
      }
    })
  end

  defmodule CanvasResponse do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CanvasReponse",
      description: "Canvas response schema",
      type: :object,
      properties: %{
        data: Canvas
      },
      example: %{
        "data" => %{
          "id" => 1,
          "rows" => 3,
          "cols" => 3,
          "chars" => %{
            "0" => %{"0" => "O", "1" => "O", "2" => " "},
            "1" => %{"0" => "O", "1" => "O", "2" => " "},
            "2" => %{"0" => " ", "1" => " ", "2" => " "}
          }
        }
      }
    })
  end

  defmodule DrawRectangle do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DrawRectangle",
      description: "Parameters to draw a rectangle on canvas",
      type: :object,
      properties: %{
        rectangle: %Schema{
          type: :object,
          properties: %{
            col: %Schema{
              type: :integer,
              description: "Column position of top-left corner of Rectangle",
              minimum: 1,
              maximum: 200
            },
            row: %Schema{
              type: :integer,
              description: "Row position of top-left corner of Rectangle",
              minimum: 1,
              maximum: 200
            },
            width: %Schema{
              type: :integer,
              description: "Width of Rectangle",
              minimum: 1,
              maximum: 200
            },
            height: %Schema{
              type: :integer,
              description: "Height of Rectangle",
              minimum: 1,
              maximum: 200
            },
            oc: %Schema{
              type: :string,
              description: "Outline characteer of Rectanle",
              minLength: 1,
              maxLength: 1
            },
            fc: %Schema{
              type: :string,
              description: "Fill characteer of Rectanle",
              minLength: 1,
              maxLength: 1
            }
          }
        }
      },
      required: [:rows, :cols, :fill_char],
      example: %{
        "row" => 0,
        "col" => 0,
        "width" => 5,
        "height" => 5,
        "oc" => "@",
        "fc" => "X"
      }
    })
  end

  defmodule DrawFloodFill do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DrawFillFlood",
      description: "Parameters to create canvas to draw on",
      type: :object,
      properties: %{
        flood_fill: %Schema{
          type: :object,
          properties: %{
            col: %Schema{
              type: :integer,
              description: "Start column of flood fill operation",
              minimum: 1,
              maximum: 200
            },
            row: %Schema{
              type: :integer,
              description: "Start row of flood fill operation",
              minimum: 1,
              maximum: 200
            },
            fc: %Schema{
              type: :string,
              description: "Fill characteer",
              minLength: 1,
              maxLength: 1
            }
          }
        }
      },
      required: [:rows, :cols, :fill_char],
      example: %{
        "row" => 0,
        "col" => 0,
        "width" => 5,
        "height" => 5,
        "oc" => "@",
        "fc" => "X"
      }
    })
  end

  defmodule Draw do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Draw",
      description: "Draw operation",
      type: :object,
      oneOf: [
        DrawRectangle,
        DrawFloodFill
      ]
    })
  end

  defmodule BadRequestParameters do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "BadRequestParameters",
      description: "Request parameters are not valid",
      type: :object,
      properties: %{
        error: %Schema{
          type: :string,
          description: "Error message"
        }
      },
      example: %{
        "error" => "Row position is out of canvas max size (1 to 200)"
      }
    })
  end

  defmodule NotFound do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "NotFound",
      description: "Object not found schema",
      type: :object,
      properties: %{
        error: %Schema{
          type: :string,
          description: "Error message"
        }
      },
      example: %{
        "error" => "Canvas 1 not found"
      }
    })
  end
end
