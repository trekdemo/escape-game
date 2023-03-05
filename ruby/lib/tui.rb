class TUI
  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
  end

  def display(message = nil)
    @output.puts(message)
  end

  def display_header(message)
    display
    display message.upcase
  end

  def display_room(room)
    display_header room.title
    display room.description if room.description
  end

  def display_actions(actions = [])
    return if actions.empty?

    @output.puts 'You can...'
    actions.each_with_index do |action, i|
      @output.puts "[#{i + 1}] #{action}"
    end
  end

  def ask(question = nil)
    @output.puts(question) if question
    @output.print '>'
    @input.readline.strip
  end
end
