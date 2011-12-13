rails = File.join Dir.getwd, 'config', 'environment.rb'

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails

  if Rails.version.first == '2'
    require 'console_app'
    require 'console_with_helpers'
  elsif Rails.version.first == '3'
    require 'rails/console/app'
    require 'rails/console/helpers'
  else
    warn '[WARN] Can not load Rails console commands (Not on Rails 2 or Rails 3?)'
  end
end


begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| output.puts value.ai }
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


Pry.hooks[:before_session] = proc do

  puts "Loading #{Rails.env} environment (Rails #{Rails.version})" if defined?(Rails)
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

# vim: set ft=ruby:
