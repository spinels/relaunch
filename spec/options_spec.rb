here = File.expand_path(File.dirname(__FILE__))
require "#{here}/spec_helper.rb"

require "rerun/options"
require 'tempfile'

module Rerun
  describe Options do
    it "has good defaults" do
      defaults = Options.parse args: ["foo"]
      expect(defaults[:cmd]).to eq("foo")

      expect(defaults[:dir]).to eq(["."])
      expect(defaults[:pattern]).to eq(Options::DEFAULT_PATTERN)
      expect(defaults[:signal]).to include('KILL')
      expect(defaults[:wait]).to eq(2)
      expect(defaults[:notify]).to eq(true)
      expect(defaults[:quiet]).to eq(false)
      expect(defaults[:verbose]).to eq(false)
      expect(defaults[:name]).to eq(File.basename(Dir.pwd).capitalize)
      expect(defaults[:force_polling]).to eq(false)
      expect(defaults[:ignore_dotfiles]).to eq(true)

      expect(defaults[:clear]).to be_nil
      expect(defaults[:exit]).to be_nil

      expect(defaults[:background]).to eq(false)
    end

    ["--help", "-h", "--usage", "--version"].each do |arg|
      describe "when passed #{arg}" do
        it "returns nil" do
          expect do
            expect(Options.parse(args: [arg])).to be_nil
          end.to output.to_stdout
        end
      end
    end

    it "accepts --quiet" do
      options = Options.parse args: ["--quiet", "foo"]
      expect(options[:quiet]).to eq(true)
    end

    it "accepts --verbose" do
      options = Options.parse args: ["--verbose", "foo"]
      expect(options[:verbose]).to eq(true)
    end

    it "accepts --no-ignore-dotfiles" do
      options = Options.parse args: ["--no-ignore-dotfiles"]
      expect(options[:ignore_dotfiles]).to eq(false)
    end

    it "splits directories" do
      options = Options.parse args: ["--dir", "a,b", "foo"]
      expect(options[:dir]).to eq(["a", "b"])
    end

    it "adds directories specified individually with --dir" do
      options = Options.parse args: ["--dir", "a", "--dir", "b"]
      expect(options[:dir]).to eq(["a", "b"])
    end

    it "adds directories specified individually with -d" do
      options = Options.parse args: ["-d", "a", "-d", "b"]
      expect(options[:dir]).to eq(["a", "b"])
    end

    it "adds directories specified individually using mixed -d and --dir" do
      options = Options.parse args: ["-d", "a", "--dir", "b"]
      expect(options[:dir]).to eq(["a", "b"])
    end

    it "adds individual directories and splits comma-separated ones" do
      options = Options.parse args: ["--dir", "a", "--dir", "b", "--dir", "foo,other"]
      expect(options[:dir]).to eq(["a", "b", "foo", "other"])
    end

    it "accepts --name for a custom application name" do
      options = Options.parse args: ["--name", "scheduler"]
      expect(options[:name]).to eq("scheduler")
    end

    it "accepts --force-polling to force listener polling" do
      options = Options.parse args: ["--force-polling"]
      expect(options[:force_polling]).to eq(true)
    end

    it "accepts --ignore" do
      options = Options.parse args: ["--ignore", "log/*"]
      expect(options[:ignore]).to eq(["log/*"])
    end

    it "accepts --ignore multiple times" do
      options = Options.parse args: ["--ignore", "log/*", "--ignore", "*.tmp"]
      expect(options[:ignore]).to eq(["log/*", "*.tmp"])
    end

    it "accepts --restart which allows the process to restart itself, defaulting to HUP" do
      options = Options.parse args: ["--restart"]
      expect(options[:restart]).to be_truthy
      expect(options[:signal]).to eq("HUP")
    end

    it "allows user to override HUP signal when --restart is specified" do
      options = Options.parse args: %w[--restart --signal INT]
      expect(options[:restart]).to be_truthy
      expect(options[:signal]).to eq("INT")
    end

    # notifications

    it "rejects --no-growl" do
      options = nil
      expect do
        options = Options.parse args: %w[--no-growl echo foo]
      end.to output(/use --no-notify/).to_stderr

      expect(options).to be_nil
    end

    it "defaults to --notify true (meaning 'use what works')" do
      options = Options.parse args: %w[echo foo]
      expect(options[:notify]).to eq(true)
    end

    it "accepts bare --notify" do
      options = Options.parse args: %w[--notify -- echo foo]
      expect(options[:notify]).to eq(true)
    end

    %w[growl osx].each do |notifier|
      it "accepts --notify #{notifier}" do
        options = Options.parse args: ["--notify", notifier, "echo foo"]
        expect(options[:notify]).to eq(notifier)
      end
    end

    it "accepts --no-notify" do
      options = Options.parse args: %w[--no-notify echo foo]
      expect(options[:notify]).to eq(false)
    end

    describe 'reading from a config file' do
      around do |example|
        Tempfile.create('rerun-config') do |file|
          file.write("--quiet\n--pattern **/*.foo\n")
          file.flush
          @config_file = file.path
          example.run
        end
      end

      let(:config_file) { @config_file }

      it 'uses the config file\'s values over the defaults' do
        o = Options.parse(args: [], config_file: config_file)
        expect(o[:quiet]).to be_truthy
        expect(o[:pattern]).to eq('**/*.foo')
      end

      it 'uses the command-line args over the config file\'s' do
        o = Options.parse(args: %w{--no-quiet --pattern **/*.bar --verbose},
                          config_file: config_file)
        expect(o[:verbose]).to eq(true)
        expect(o[:quiet]).to be_falsey
        expect(o[:pattern]).to eq('**/*.bar')
      end
    end

    describe 'Usage' do
      it "is displayed when no args are given" do
        expect(Options).to receive(:puts) do |args|
          expect(args.to_s).to match(/^Usage/)
        end

        Options.parse(args: [])
      end

      it "is not displayed when args are given" do
        expect(Options).not_to receive(:puts)

        Options.parse args: ["--name", "echo foo"]
      end
    end
  end
end
