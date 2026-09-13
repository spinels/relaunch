require_relative 'spec_helper'
require 'rbconfig'
require 'tmpdir'
require 'timeout'
require 'pty' unless Gem.win_platform?

describe 'Keyboard controls in a terminal', unless: Gem.win_platform? do
  def with_terminal(mode)
    Dir.mktmpdir('rerun-terminal') do |dir|
      script = File.join(dir, 'runner.rb')
      File.write(script, <<~RUBY)
        require 'rerun'
        STDOUT.sync = true

        def run
          runner = Rerun::Runner.new('unused')
          def runner.die
            puts 'KEYBOARD_EXIT'
            Thread.exit
          end
          thread = runner.start_keypress_thread
          puts(thread ? 'KEYBOARD_ENABLED' : 'KEYBOARD_DISABLED')
          thread.join if thread
        end

        if ARGV.first == 'background'
          pid = fork do
            Process.setpgrp
            run
          end
          File.write(#{File.join(dir, 'child.pid').inspect}, pid)
          Process.wait(pid)
        else
          run
        end
      RUBY

      PTY.spawn(RbConfig.ruby, '-I', File.expand_path('../lib', __dir__), script, mode) do |reader, writer, pid|
        begin
          yield reader, writer
        ensure
          if File.size?(File.join(dir, 'child.pid'))
            Process.kill('KILL', -File.read(File.join(dir, 'child.pid')).to_i) rescue nil
          end
          Process.kill('KILL', pid) rescue nil
          Process.wait(pid) rescue nil
          reader.close unless reader.closed?
          writer.close unless writer.closed?
        end
      end
    end
  end

  def read_until(reader, marker)
    output = ''
    Timeout.timeout(10) do
      output << reader.readpartial(4096) until output.include?(marker)
    end
    output
  end

  it 'does not start keyboard controls in a background process group' do
    with_terminal('background') do |reader, _writer|
      expect(read_until(reader, 'KEYBOARD_DISABLED')).not_to include('stty:')
    end
  end

  it 'accepts keyboard commands in the foreground process group' do
    with_terminal('foreground') do |reader, writer|
      read_until(reader, 'KEYBOARD_ENABLED')
      writer.write("q\n")
      expect(read_until(reader, 'KEYBOARD_EXIT')).not_to include('stty:')
    end
  end
end
