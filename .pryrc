begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError
  puts 'awesome_print not available :('
end

begin
  require 'hirb'
  old_print = Pry.config.print
  Pry.config.print = proc do |output, value|
    Hirb::View.view_or_page_output(value) || old_print.call(output, value)
  end
  Hirb.enable
rescue LoadError
  puts 'hirb not available :('
end

begin
  require 'interactive_editor'
rescue LoadError
end

Pry.config.hooks.add_hook(:before_session, :greetings) do

  puts "You are using #{RUBY_DESCRIPTION}. Have fun ;)"

  if defined?(ActiveRecord)
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  if defined?(Mongoid)
    Mongoid.logger = Logger.new(STDOUT)
  end

  if defined?(MongoMapper)
    MongoMapper.connection.instance_variable_set(:@logger, Logger.new(STDOUT))
  end

  if defined?(Rails)
    Rails.logger = Logger.new(STDOUT)
  end
end

if Pry.commands['continue']
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
end

if Pry.commands['up']
  Pry.commands.alias_command 'u', 'up'
  Pry.commands.alias_command 'd', 'down'
end

if Pry.commands['show-stack']
  Pry.commands.alias_command 'ss', 'show-stack'
end

# vim: set ft=ruby:
