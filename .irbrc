require 'rubygems'
require 'pp'
require 'irb/completion'
require 'irb/ext/save-history'

$KCODE = 'u' unless defined?(Encoding)

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:PROMPT_MODE]  = :SIMPLE

# Use awesome_print as default formatter
begin
  require 'ap'

  if defined?(Logger)
    Logger.class_eval do
      alias_method :original_debug, :debug
      def debug(message)
        original_debug(message.ai)
      end
    end
  end

  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError
end

if defined?(Rails)
  rails_root = File.basename(Dir.pwd)
  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{rails_root}> ",
    :PROMPT_S => "#{rails_root}* ",
    :PROMPT_C => "#{rails_root}? ",
    :RETURN   => "=> %s\n"
  }
  IRB.conf[:PROMPT_MODE] = :RAILS

  # Called after the irb session is initialized and Rails has
  # been loaded (props: Mike Clark).
  IRB.conf[:IRB_RC] = Proc.new do

    if defined?(ActiveRecord)
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Base.instance_eval { alias :[] :find }
    end

    if defined?(Mongoid)
      Mongoid.logger = Logger.new(STDOUT)
    end
  end
end

begin
  require 'drx'
rescue LoadError
end

# vim: set ft=ruby:
