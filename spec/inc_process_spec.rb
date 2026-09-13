require_relative 'spec_helper'
require_relative 'inc_process'

describe IncProcess do
  it "only signals known child processes during cleanup" do
    inc = IncProcess.allocate
    allow(inc).to receive(:windows?).and_return(false)
    allow(Process).to receive(:kill)
    allow(Process).to receive(:wait)

    [nil, 0, -123, Process.pid].each do |pid|
      inc.instance_variable_set(:@inc_pid, pid)
      inc.instance_variable_set(:@inc_parent_pid, pid)
      inc.instance_variable_set(:@rerun_pid, 12345)

      inc.kill
    end

    expect(Process).to have_received(:kill).with("INT", 12345).exactly(4).times
    expect(Process).to have_received(:kill).exactly(4).times
    expect(Process).to have_received(:wait).with(12345).exactly(4).times
    expect(Process).to have_received(:wait).exactly(4).times
  end
end
