# frozen_string_literal: true

describe "Fetch Ads", type: :request do
  subject(:fetch_ads) { get "/?per_page=2" }

  let(:db) { Container["persistence.db"] }

  before do
    (1..3).each do |i|
      db[:ads].insert(user_id: i, title: "Title #{i}", city: "City #{i}", description: "Text #{i}")
    end
  end

  after do
    # drop data
    db[:ads].delete
  end

  it "responds with 200" do
    fetch_ads
    expect(response_status).to eq(200)
  end

  it "renders first page" do
    fetch_ads
    expect(response_json["data"].size).to eq(2)
  end

  it "renders meta and links" do
    fetch_ads
    expect(response_json["meta"]).to eq({ "total" => 3 })
    expect(response_json["links"].keys).to eq(%w[first self next last])
  end
end
