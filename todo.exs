defmodule TodoList do
  @filename "infos.txt" #File where the tasks are saved

  def init do
    unless File.exists?(@filename) do
      File.write!(@filename, "")
    end
  end
  
  def run do
    IO.puts("  [1] - Add an item
  [2] - Display all items
  [3] - Delete an item
  [4] - Delete all items
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
              IO.puts("\e[H\e[2J")
              TodoList.run
              
          end

      2 ->
        File.read!(@filename)
        |> String.split("\n", trim: true)
        |> Enum.each(&IO.puts/1)
        IO.puts("-------------------------")
        Process.sleep(3000)
        TodoList.run
        
      3 ->
        {:ok, lines} = File.read(@filename)
        IO.puts("Which line do you want to delete:")
        line_number = String.to_integer(String.trim(IO.gets(""))) - 1

        case Enum.at(String.split(lines, "\n", trim: true), line_number) do
          nil ->
            IO.puts("Line not found. Please select an existing line.")
            Process.sleep(5000)
            IO.puts("\e[H\e[2J")
            TodoList.run
          line ->
            ul = Enum.reject(String.split(lines, "\n", trim: true), fn x -> x == line end)

            case File.write(@filename, Enum.join(ul, "\n")) do
              :ok -> IO.puts("Line deleted")
              {:error} -> IO.puts("Error")
            end

            Process.sleep(3000)
            TodoList.run
        end
      4 ->
        File.write!(@filename, "")
        IO.puts("All tasks have been deleted..")

        Process.sleep(5000)
        TodoList.run

      0 ->
        Process.sleep(1500)
        IO.puts("\e[H\e[2J")

      _ ->
        IO.puts("Error, please respect the syntax... (0/1/2/3/4)")
        Process.sleep(5000)
        IO.puts("\e[H\e[2J")
        TodoList.run
    end
  end
end

IO.puts("\e[H\e[2J")
TodoList.init
TodoList.run
