# frozen_string_literal: true

describe "Update Ad", type: :request do
  subject(:update_ad) { patch "/ads/#{id}", params }

  let(:db) { Container["persistence.db"] }
  let(:ads_repo) { Container["contexts.bulletin_board.repositories.ad"] }
  let(:ad) do
    ads_repo.create(
      user_id: 1,
      title: Faker::Lorem.sentence,
      city: Faker::Address.city,
      description: Faker::Lorem.sentence
    )
  end
  let(:id) { ad.id }

  context "with valid params" do
    let(:params) do
      {
        coordinates: {
          latitude: 12.2,
          longitude: 23.1
        }
      }
    end

    it "responds with 200" do
      update_ad
      expect(response_status).to eq(200)
    end

    it "updates ad" do
      update_ad
      updated = ads_repo.find(ad.id)
      expect(updated.latitude).to eq(12.2)
      expect(updated.longitude).to eq(23.1)
    end

    it "renders updated ad" do
      update_ad

      expect(response_json["data"]["attributes"]["latitude"]).to eq(12.2)
      expect(response_json["data"]["attributes"]["longitude"]).to eq(23.1)
    end
  end

  context "with invalid params" do
    let(:params) do
      {
        coordinates: {
          latitude: 12.2,
          longitude: nil
        }
      }
    end

    it "responds with 422" do
      update_ad
      expect(response_status).to eq(422)
    end

    it "renders error" do
      update_ad
      expect(response_json["errors"]).to eq("coordinates" => { "longitude" => ["must be a float"] })
    end
  end

  context "when record does not exist" do
    let(:id) { 999 }
    let(:params) do
      {
        coordinates: {
          latitude: 12.2,
          longitude: 34.1
        }
      }
    end

    it "responds with 404" do
      update_ad
      expect(response_status).to eq(404)
    end

    it "renders error" do
      update_ad
      expect(response_json["error"]).to eq("Record #999 does not exist")
    end
  end
end
