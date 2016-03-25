require 'spec_helper'

RSpec.describe Chronolog::Changeset, type: :model do
  it { should belong_to(:changeable) }
  it { should belong_to(:admin_user) }

  it { should validate_presence_of(:changeset) }
  it { should validate_presence_of(:identifier) }

  it { should validate_inclusion_of(:action).in_array(Chronolog::Model::ACTIONS) }

  describe ".recent" do
    let!(:oldest) { create(:changeset, created_at: 1.week.ago) }
    let!(:older)  { create(:changeset, created_at: 3.days.ago) }
    let!(:newest) { create(:changeset, created_at: 2.days.ago) }

    it "returns changesets sorted by the most recent" do
      expect(Chronolog::Changeset.recent).to eq [newest, older, oldest]
    end
  end
end
