require "rails_helper"

describe PeakFlowUtils::ParseJson do
  it "handles ActiveRecord objects" do
    user = User.create!(email: "donaldduck@example.com")
    data = {
      people: [
        {first_name: "Donald", last_name: "Duck", user: user}
      ]
    }

    result = PeakFlowUtils::ParseJson.new(data).parse

    expect(result).to eq(
      people: [
        {first_name: "Donald", last_name: "Duck", user: "#<User id: 1>"}
      ]
    )
  end
end
