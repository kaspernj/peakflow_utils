require "rails_helper"

describe PeakFlowUtils::RspecHelper do
  it "forwards the tag command to rspec" do
    helper = PeakFlowUtils::RspecHelper.new(groups: 4, group_number: 2, tag: "asd")
    command = helper.__send__(:dry_result_command)
    expect(command).to eq "bundle exec rspec --dry-run --format json --tag asd"
  end

  it "doesnt include the tag argument if nothing is given" do
    helper = PeakFlowUtils::RspecHelper.new(groups: 4, group_number: 2)
    command = helper.__send__(:dry_result_command)
    expect(command).to eq "bundle exec rspec --dry-run --format json"
  end

  it "selects only given types" do
    helper = PeakFlowUtils::RspecHelper.new(groups: 4, group_number: 2, only_types: ["system"])

    ignore_models = helper.__send__(:ignore_type?, "models")
    ignore_system = helper.__send__(:ignore_type?, "system")

    expect(ignore_models).to eq true
    expect(ignore_system).to eq false
  end
end
