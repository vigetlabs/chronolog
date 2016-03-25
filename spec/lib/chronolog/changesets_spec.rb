require 'spec_helper'

RSpec.describe Post, type: :model do
  let!(:admin) { create(:admin_user) }

  subject { create(:post) }

  it { should have_many(:changesets).dependent(:nullify) }

  describe "#created_by" do
    let!(:created) { create(:changeset, :create, changeable: subject, admin_user: admin) }

    it { expect(subject.created_by).to eq admin }
  end

  describe "#last_modified_by" do
    let!(:old_update) { create(:changeset, :update, changeable: subject, admin_user: create(:admin_user), created_at: 1.week.ago) }
    let!(:new_update) { create(:changeset, :update, changeable: subject, admin_user: admin, created_at: 2.days.ago) }

    it { expect(subject.last_modified_by).to eq admin }
  end
end
