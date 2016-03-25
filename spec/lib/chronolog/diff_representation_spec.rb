require 'spec_helper'

RSpec.describe Chronolog::DiffRepresentation do
  describe "#attributes" do
    let!(:post) { create(:post, published_date: Date.new(2016, 3, 25)) }
    let!(:tag)  { create(:tag, post: post) }

    subject { described_class.new(post) }

    it "returns the appropriate set of attributes and values for use in a diff" do
      expect(subject.attributes).to eq(
        'title'          => 'Such Post',
        'body'           => 'Oh wow such post body.',
        'author'         => 'Randy Savage',
        'published_date' => 'Friday March 25, 2016'
      )
    end

    context "when passed included associations" do
      subject { described_class.new(post, include: [:tags, :photos]) }

      before do
        post.photos << create(:photo, url: 'shazamm.com')
      end

      it "returns the appropriate set of attributes and values for use in a diff" do
        expect(subject.attributes).to eq(
          'title'          => 'Such Post',
          'body'           => 'Oh wow such post body.',
          'author'         => 'Randy Savage',
          'published_date' => 'Friday March 25, 2016',
          'tags'           => [{ 'value' => 'Hot Dang' }],
          'photos'         => [{ 'url' => 'shazamm.com' }]
        )
      end

      context "but there are no associated records" do
        subject { described_class.new(post, include: [:tags, :photos]) }

        before do
          post.photos.destroy_all
        end

        it "returns the appropriate set of attributes and values for use in a diff" do
          expect(subject.attributes).to eq(
            'title'          => 'Such Post',
            'body'           => 'Oh wow such post body.',
            'author'         => 'Randy Savage',
            'published_date' => 'Friday March 25, 2016',
            'tags'           => [{ 'value' => 'Hot Dang' }]
          )
        end
      end
    end

    context "when passed ignored attributes" do
      subject { described_class.new(post, ignore: [:user_id]) }

      it "returns the appropriate set of attributes and values for use in a diff" do
        expect(subject.attributes).to eq(
          'title'          => 'Such Post',
          'body'           => 'Oh wow such post body.',
          'published_date' => 'Friday March 25, 2016',
        )
      end
    end

    context "when passed methods" do
      it 'includes methods + values in response' do
        subject = described_class.new(post, methods: [:to_s])

        expect(subject.attributes).to eq(
          'title'          => 'Such Post',
          'body'           => 'Oh wow such post body.',
          'author'         => 'Randy Savage',
          'published_date' => 'Friday March 25, 2016',
          'to_s'           => 'Such Post'
        )
      end

      it "pulls in associated objects when method ends in _ids" do
        create(:tag, post: post, value: 'BOOM')

        subject = described_class.new(post, methods: :tag_ids)

        expect(subject.attributes).to eq(
          'title'          => 'Such Post',
          'body'           => 'Oh wow such post body.',
          'author'         => 'Randy Savage',
          'published_date' => 'Friday March 25, 2016',
          'tags'           => ['BOOM', 'Hot Dang']
        )
      end
    end
  end
end
