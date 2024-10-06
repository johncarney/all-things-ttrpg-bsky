# frozen_string_literal: true

require "topic"

require "faker"

RSpec.describe Topic do
  describe "#matches?" do
    subject(:matches?) { topic.matches?(string) }

    let(:topic) do
      described_class.new(
        Faker::Lorem.word.upcase,
        patterns: %w[a\s*pattern another\s*pattern]
      )
    end

    context "given a string matching the topic name" do # rubocop:todo RSpec/ContextWording
      let(:string) { topic.name.downcase }

      it { is_expected.to be_truthy }
    end

    context "given a string matching one of its patterns" do # rubocop:todo RSpec/ContextWording
      let(:string) { ["A   Pattern", "aNother\tpAttErn"].sample }

      it { is_expected.to be_truthy }
    end

    context "given a string that does not match the topic name or any of its patterns" do # rubocop:todo RSpec/ContextWording
      let(:string) { "not a match" }

      it { is_expected.to be_falsey }
    end
  end

  describe "#errors" do
    subject(:errors) { topic.errors }

    context "when all patterns are valid" do
      let(:topic) { described_class.new("topic", patterns: ["valid\spat{2}ern"]) }

      it { is_expected.to be_empty }
    end

    context "when some patterns are invalid" do
      let(:topic) { described_class.new("topic", patterns:) }

      let(:patterns) { ["valid pat{2}ern", "invalid pattern)", "another invalid pat[tern"] }

      it "returns the errors" do
        expect(errors).to contain_exactly(
          %r{/invalid pattern\)/ for "topic"},
          %r{/another invalid pat\[tern/ for "topic"}
        )
      end
    end
  end
end
