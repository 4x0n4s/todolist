defmodule TodoList do
  @filename "infos.txt" #File where the tasks are saved

  unless File.exists?(@filename) do
    File.write!(@filename, "")
  end

  def run do
    IO.puts("\e[H\e[2J")
    IO.puts("
  [1] - Add an item
  [2] - Display all items
  [3] - Modify an item
  [4] - Delete an item
  [5] - Delete all items
  [0] - Quit
")
    IO.puts("Option: ")

    option = String.to_integer(String.trim(IO.gets("")))

    case option do

      1 ->
        IO.puts("Enter the task you want to record:")

        case File.read(@filename) do
          {:ok, file} -> content = if file == "", do: String.trim(IO.gets("")), else: file <> "\n" <> String.trim(IO.gets(""))

            File.write(@filename, content)
            IO.puts("Task added successfully")
            Process.sleep(5000)
            run()
        end

      2 ->
        File.read!(@filename)
        |> String.split("\n", trim: true)
        |> Enum.each(&IO.puts/1)
        IO.puts("-------------------------")
        Process.sleep(3000)
        run()

      3 ->
        {:ok, lines} = File.read(@filename)
        IO.puts("Which ID/line do you want to modify:")
        line_number = String.to_integer(String.trim(IO.gets(""))) - 1

        lines = String.split(lines, "\n", trim: true)

        case Enum.at(lines, line_number) do
          nil ->
            IO.puts("Line not found. Please select an existing line.")
            Process.sleep(5000)
            run()

          line ->
            IO.puts("Current line content: #{line}")
            IO.puts("Enter new content for this line:")
            new_line = String.trim(IO.gets(""))

            updated_lines = List.replace_at(lines, line_number, new_line)

            case File.write(@filename, Enum.join(updated_lines, "\n")) do
              :ok -> IO.puts("Line modified successfully.")
              {:error, reason} -> IO.puts("Error: #{reason}")
            end
          end
      4 ->
        {:ok, lines} = File.read(@filename)
        IO.puts("Which ID/line do you want to delete:")
        line_number = String.to_integer(String.trim(IO.gets(""))) - 1

        case Enum.at(String.split(lines, "\n", trim: true), line_number) do
          nil ->
            IO.puts("Line not found. Please select an existing line.")
            Process.sleep(5000)
            IO.puts("\e[H\e[2J")
            run()

          line ->
            ul = Enum.reject(String.split(lines, "\n", trim: true), fn x -> x == line end)

            case File.write(@filename, Enum.join(ul, "\n")) do
              :ok -> IO.puts("Line deleted")
              {:error} -> IO.puts("Error")
            end

            Process.sleep(3000)
            run()
        end

      5 ->
        File.write!(@filename, "")
        IO.puts("All tasks have been deleted..")
        Process.sleep(5000)
        run()

      0 ->
        Process.sleep(1500)
        Process.exit()

      _ ->
        IO.puts("Error, please respect the syntax... (0/1/2/3/4/5)")
        Process.sleep(5000)
        run()
    end
  end
end

TodoList.run()
