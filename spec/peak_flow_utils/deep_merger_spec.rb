require "rails_helper"

describe PeakFlowUtils::DeepMerger do
  it "merges given hashes" do
    hash1 = {
      people: {
        kasper: {
          name: "Kasper",
          children: ["Storm", "Lisa"]
        }
      }
    }
    hash2 = {
      people: {
        christina: {
          name: "Christina",
          children: ["Karl"]
        }
      }
    }
    hash3 = {
      people: {
        kasper: {
          children: ["Karl"]
        },
        christina: {
          children: ["Storm", "Lisa"]
        }
      }
    }

    result = PeakFlowUtils::DeepMerger.execute!(hashes: [hash1, hash2, hash3])

    expect(result).to eq(
      people: {
        kasper: {
          name: "Kasper",
          children: ["Karl"]
        },
        christina: {
          name: "Christina",
          children: ["Storm", "Lisa"]
        }
      }
    )
    expect(hash1).to eq(
      people: {
        kasper: {
          name: "Kasper",
          children: ["Storm", "Lisa"]
        }
      }
    )
    expect(hash2).to eq(
      people: {
        christina: {
          name: "Christina",
          children: ["Karl"]
        }
      }
    )
  end
end
