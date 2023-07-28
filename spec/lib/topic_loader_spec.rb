# frozen_string_literal: true

require "topic_loader"

require "faker"

RSpec.describe TopicLoader do
  include TopicMatchers

  describe ".from_hash" do
    subject(:topics) { described_class.from_hash(hash) }

    let(:hash) do
      {
        "A Topic"       => ["a pattern"],
        "Another Topic" => ["another pattern", "a third pattern"]
      }
    end

    it "builds topics from the hash" do
      expect(topics).to contain_exactly(
        a_topic.named("A Topic").with_patterns("a pattern"),
        a_topic.named("Another Topic").with_patterns("another pattern", "a third pattern")
      )
    end

    context "when a pattern is an array" do
      let(:hash) { { "the topic" => [%w[An Array Pattern]] } }

      it "joins the array into a string" do
        expect(topics).to contain_exactly a_topic.named("the topic").with_patterns("AnArrayPattern")
      end
    end

    context "when a key starts with a dot" do
      let(:hash) { { ".#{Faker::Lorem.word.downcase}" => ["a pattern"], "an actual topic" => ["another pattern"] } }

      it "ignores it" do
        expect(topics).to contain_exactly(
          a_topic.named("an actual topic").with_patterns("another pattern")
        )
      end
    end

    context "when a topic has nil patterns" do
      let(:hash) { { "an empty topic" => nil } }

      it "creates the topic with no patterns" do
        expect(topics).to contain_exactly a_topic.named("an empty topic").with_no_patterns
      end
    end

    context "when a topic has a string instead of an array" do
      let(:hash) { { "a topic" => "the pattern" } }

      it "creates the topic with a single pattern" do
        expect(topics).to contain_exactly a_topic.named("a topic").with_patterns("the pattern")
      end
    end
  end

  describe ".from_file" do
    subject(:topics) { described_class.from_file(topic_file) }

    let(:topic_file) { fixture("example-topics.yml") }

    it "loads the topics from the file" do # rubocop:todo RSpec/ExampleLength
      expect(topics).to contain_exactly(
        a_topic.named("First topic").with_patterns("a pattern", "a pattern with a macro"),
        a_topic.named("Second topic").with_patterns("another pattern"),
        a_topic.named("Empty topic").with_no_patterns,
        a_topic.named("Single-pattern topic").with_patterns("the pattern")
      )
    end
  end
end
