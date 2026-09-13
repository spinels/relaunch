require_relative 'spec_helper'
require 'rbconfig'
require 'tmpdir'
require 'timeout'

describe 'the incrementing test app' do
  it 'keeps an open snapshot consistent while publishing updates' do
    Dir.mktmpdir('relaunch-inc') do |dir|
      path = File.join(dir, 'inc.txt')
      script = File.expand_path('../inc.rb', __dir__)
      pid = Process.spawn(RbConfig.ruby, script, path, out: File::NULL, err: File::NULL)

      begin
        Timeout.timeout(5) do
          sleep 0.01 until File.exist?(path)
          File.open(path) do |snapshot|
            original = snapshot.read
            sleep 0.01 until File.read(path) != original
            snapshot.rewind

            expect(snapshot.read).to eq(original)
            expect(original.lines.size).to eq(4)
          end
        end
      ensure
        Process.kill('KILL', pid) rescue Errno::ESRCH
        Process.wait(pid)
      end
    end
  end
end
