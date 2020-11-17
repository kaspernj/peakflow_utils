require "rails_helper"

describe PeakFlowUtils::NotifierErrorParser do
  let(:environment) do
    {
      "REMOTE_ADDR" => "127.0.0.1",
      "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36",
      "SERVER_PORT" => 443,
      "HTTP_HOST" => "www.example.com",
      "REQUEST_URI" => "/users/5?first_name=Kasper"
    }
  end

  let(:error_parser) do
    PeakFlowUtils::NotifierErrorParser.new(
      backtrace: [
        "/home/dev/Development/nemoa/app/api_maker/commands/competitions/teams_for_user.rb:6:in `block in execute!'"
      ],
      error: RuntimeError.new("stub"),
      environment: environment
    )
  end

  describe "#file_path" do
    it "parses a block string" do
      expect(error_parser.file_path).to eq "/home/dev/Development/nemoa/app/api_maker/commands/competitions/teams_for_user.rb"
    end
  end

  describe "#line_number" do
    it "detects the line number from a block" do
      expect(error_parser.line_number).to eq 6
    end
  end

  describe "#remote_ip" do
    it "detects the remote ip" do
      expect(error_parser.remote_ip).to eq "127.0.0.1"
    end

    it "uses the forwarded address if given" do
      environment["HTTP_X_FORWARDED_FOR"] = "10.0.0.5"
      expect(error_parser.remote_ip).to eq "10.0.0.5"
    end
  end

  describe "#url" do
    it "returns the url" do
      expect(error_parser.url).to eq "https://www.example.com/users/5?first_name=Kasper"
    end
  end

  describe "#user_agent" do
    it "returns the user agent" do
      expect(error_parser.user_agent).to eq(
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36"
      )
    end
  end
end
