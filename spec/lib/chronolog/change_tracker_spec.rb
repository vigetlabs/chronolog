require 'spec_helper'

RSpec.describe Chronolog::ChangeTracker do
  let!(:admin) { create(:admin_user) }
  let!(:post)  { create(:post, title: 'Wow, Very Post') }

  let(:params) do
    {
      action:     'create',
      admin_user: admin,
      old_state:  {},
      new_state:  { 'body' => 'SHABOOSH' },
      target:     post
    }
  end

  describe "#identifier" do
    context "when target exists" do
      subject { described_class.new(params) }

      it { expect(subject.identifier).to eq 'Wow, Very Post (Post)' }
    end

    context "when identifier is specified" do
      subject { described_class.new(params.merge(identifier: 'Blargh')) }

      it { expect(subject.identifier).to eq 'Blargh' }
    end
  end

  describe "#changeset" do
    subject { described_class.new(params) }

    context "given valid attributes" do
      it "creates a changeset" do
        expect { subject.changeset }.to change { Chronolog::Changeset.count }.by 1
      end
    end

    context "given invalid attributes" do
      before do
        params[:action] = 'craziness'
      end

      it "raises an error" do
        expect { subject.changeset }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
