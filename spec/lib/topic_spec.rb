# frozen_string_literal: true

require "topic"

require "faker"

RSpec.describe Topic do
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
