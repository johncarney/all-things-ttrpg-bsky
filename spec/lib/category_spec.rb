# frozen_string_literal: true

require "category"

require "faker"

RSpec.describe Category do
  describe "#matches?" do
    subject(:matches?) { category.matches?(string) }

    let(:category) { described_class.new(Faker::Lorem.word.upcase, topics: []) }

    context "given a string matching the category name" do # rubocop:todo RSpec/ContextWording
      let(:string) { category.name.downcase }

      it { is_expected.to be_truthy }
    end

    context "given a string that does not match the topic name or any of its patterns" do # rubocop:todo RSpec/ContextWording
      let(:string) { "not a match" }

      it { is_expected.to be_falsey }
    end
  end
end
