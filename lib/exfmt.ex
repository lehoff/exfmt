defmodule Exfmt do

  alias :prettypr, as: PP

  def format({:def, _, [fun_args | [[{:do, do_block}]] ]}) do
    fun_fmt = format_fun(fun_args)
    block_fmt = format_do(do_block)
    def_line = PP.follow(PP.follow(PP.text('def'),
          fun_fmt),
      PP.text('do'))
    format_line_and_block(def_line, block_fmt)
    |> add_end
  end


  def format({:case, _, [case_expr | [[{:do, case_block}]]]}) do
    case_expr_fmt = format(case_expr)
    case_block_fmt = format_do(case_block)
    case_line =
      PP.follow(
        PP.text('case'),
        PP.follow(
          case_expr_fmt,
          PP.text('do')))
    format_line_and_block(case_line, case_block_fmt)
    |> add_end
  end

  def format({:+, _, [left, right]}) do
    left_fmt = format(left)
    right_fmt = format(right)
    format_inline_op(format_op(:+), left_fmt, right_fmt)
  end

  def format({:*, _, [left_ast, right_ast]}) do
    left = format(left_ast)
    right = format(right_ast)
    format_inline_op(format_op(:*), left, right)
  end

  def format({:->, _, case_clause}) do
    {pattern, block} = format_case_clause(case_clause)
    line = PP.follow(pattern, PP.text('->'))
    PP.break(format_line_and_block(line, block))
  end


  def format({var, _, nil}) do
    PP.text(to_charlist(var))
  end

  def format(n) when is_integer(n) do
    PP.text(Integer.to_charlist(n))
  end

#  def format(statements) when is_list(statements) do
#    Enum.map(statements, fn(s) -> PP.break(format(s)) end)
#    |> join
#  end

  def format_inline_op(op, left, right) do
    PP.follow(
      PP.follow(left, op),
      right)
  end

  def format_op(op) do
    PP.text(List.flatten([' ', Atom.to_charlist(op), ' ']))
  end

  def format_line_and_block(line, block) do
    PP.above(
      line,
      PP.nest(2, block))
  end

  def add_end(block) do
    PP.above(
      block,
      PP.text('end'))
  end

  def format_case_clause([[pattern_ast], block_ast]) do
    pattern = format(pattern_ast)
    block = format(block_ast)
    {pattern, block}
  end


  # format_do will format the statements of the do block and leave the rest to
  # the level above.
  def format_do(statements) when is_list(statements) do
    ss_fmt = Enum.map(statements, &format/1)
    join(ss_fmt, PP.empty)
  end

  def format_do(statement) do
    format(statement)
  end

  # format_fun formats the fun name and args
  def format_fun({fun_name, _, args}) do
    args_fmt = Enum.map(args, fn(arg) -> format(arg) end) |> comma_join
    PP.beside(
      PP.text(to_charlist(fun_name)),
      wrap_parenthesis(args_fmt))
  end


  def join([d], _joiner) do
    d
  end

  def join([d|[_|_]=ds], joiner) do
    PP.beside(
      PP.beside(d, joiner),
      join(ds, joiner))
  end

  def join(ds) do
    Enum.reduce(ds, PP.empty,
      fn(d, acc) -> PP.follow(d, acc) end)
  end

  def comma_join(ds) do
    join(ds, PP.text(', '))
  end

  def wrap_parenthesis(d) do
    PP.beside(
      PP.text('('),
      PP.beside(d, PP.text(')')))
  end

  def test(ast) do
     ast |> format |> PP.format |> IO.puts
  end

  def ast(1) do
    :ok
  end

  def example_ast(filename) do
    {:ok, ast} = File.read!("examples/" <> filename)
    |> Code.string_to_quoted
    ast
  end

end
