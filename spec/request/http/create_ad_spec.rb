# frozen_string_literal: true

describe "Create Ad", type: :request do
  include ExternalRequestHelper

  subject(:create_ad) { post "/ads", params }

  let(:db) { Container["persistence.db"] }

  before do
    stubs.post("/coordinates", { city: "Limassol" }.to_json) do
      [200, { "Content-Type" => "application/json" }, { latitude: 34.707130, longitude: 33.022617 }.to_json]
    end

    stubs.post("/coordinates", { city: "Unknown" }.to_json) do
      [404, { "Content-Type" => "application/json" }, { error: "Cannot locate 'Unknown'" }.to_json]
    end

    Container.stub("geocoder.client", Geocoder::Client.new(connection))
  end

  context "with valid params" do
    let(:params) do
      {
        user_id: 1,
        title: "Flat for sale",
        city: "Limassol",
        description: "New flat near the sea"
      }
    end

    it "responds with 200" do
      create_ad
      expect(response_status).to eq(200)
    end

    it "creates new record" do
      expect { create_ad }.to change { db[:ads].count }.by(1)
    end

    it "renders created ad" do
      create_ad

      expected_ad_object = params.merge(latitude: 34.707130, longitude: 33.022617)

      expect(response_json["data"]["type"]).to eq("ads")
      expect(response_json["data"]["attributes"].transform_keys(&:to_sym)).to eq(expected_ad_object)
    end
  end

  context "when geocoder failed" do
    let(:params) do
      {
        user_id: 1,
        title: "Flat for sale",
        city: "Unknown",
        description: "New flat near the sea"
      }
    end

    it "responds with 200" do
      create_ad
      expect(response_status).to eq(200)
    end

    it "creates new record" do
      expect { create_ad }.to change { db[:ads].count }.by(1)
    end

    it "renders created ad" do
      create_ad

      expected_ad_object = params.merge(latitude: nil, longitude: nil)

      expect(response_json["data"]["type"]).to eq("ads")
      expect(response_json["data"]["attributes"].transform_keys(&:to_sym)).to eq(expected_ad_object)
    end
  end

  context "with invalid params" do
    let(:params) do
      {
        user_id: 1,
        title: "Flat for sale",
        description: "New flat near the sea"
      }
    end

    it "responds with 422" do
      create_ad
      expect(response_status).to eq(422)
    end

    it "does not create new record" do
      expect { create_ad }.not_to(change { db[:ads].count })
    end

    it "renders errors" do
      create_ad
      expect(response_json["errors"]).to eq("city" => ["is missing"])
    end
  end
end
