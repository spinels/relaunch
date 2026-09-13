require_relative 'spec_helper'
require 'open3'
require 'tmpdir'
require 'rbconfig'

describe 'the gem executables' do
  %w[rerun relaunch].each do |command|
    it "reads existing .rerun configuration through #{command}" do
      executable = File.expand_path("../bin/#{command}", __dir__)

      Dir.mktmpdir('relaunch-config') do |dir|
        File.write(File.join(dir, '.rerun'), "--verbose\n--name from-rerun-config\n")

        stdout, stderr, status = Open3.capture3(RbConfig.ruby, executable, chdir: dir)

        expect(status.success?).to be(true), stderr
        expect(stdout).to include('rerun options:', 'from-rerun-config')
      end
    end
  end
end
