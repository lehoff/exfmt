defmodule Math do
  def sum(a, b) do
    a + b
  end


  def pap(0, b) do
    0
  end

  def pap(a, b) do
    x = a + b
    y = a * b
    x + y
  end



  def ged(a, b) do
    case a do
      0 ->
        1
      1 ->
        b
      _ ->
        a * b
    end
  end

  def sum2(a, b \\ 0), do: a+b

end
