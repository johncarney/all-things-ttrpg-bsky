# frozen_string_literal: true

require "category_loader"
require "topic"

require "faker"

RSpec.describe CategoryLoader do
  include CategoryMatchers
  include TopicMatchers

  describe ".from_hash" do
    subject(:categories) { described_class.from_hash(hash, &topic_resolver) }

    let(:hash) do
      {
        "A Category"       => ["a topic"],
        "Another Category" => ["another topic", "a third topic"]
      }
    end

    let(:topic_resolver) { ->(name) { [Topic.new(name.upcase, patterns: [])] } }

    it "builds categories from the hash" do
      expect(categories).to contain_exactly(
        a_category.named("A Category"),
        a_category.named("Another Category")
      )
    end

    it "uses the topic resolver to build the topics" do
      expect(categories).to contain_exactly(
        a_category.named("A Category").with_topics(a_topic.named("A TOPIC")),
        a_category.named("Another Category").with_topics(a_topic.named("ANOTHER TOPIC"), a_topic.named("A THIRD TOPIC"))
      )
    end

    context "when the topic resolver returns a single topic" do
      subject(:category_topics) { categories.first.topics }

      let(:topic_resolver) { ->(name) { Topic.new(name.upcase, patterns: []) } }
      let(:hash)           { { "The Category" => ["a topic"] } }

      it "builds the category with a single topic" do
        expect(category_topics).to contain_exactly(a_topic.named("A TOPIC"))
      end
    end

    context "when the topic resolver returns nil" do
      subject(:category_topics) { categories.first.topics }

      let(:topic_resolver) { ->(_name) {} }
      let(:hash)           { { "The Category" => ["a topic"] } }

      it "builds the category with no topics" do
        expect(category_topics).to be_empty
      end
    end
  end

  describe ".from_file" do
    subject(:categories) { described_class.from_file(category_file, &topic_resolver) }

    let(:category_file)  { fixture("example-categories.yml") }
    let(:topic_resolver) { ->(name) { [Topic.new(name, patterns: [])] } }

    it "loads the categories from the file" do # rubocop:disable RSpec/ExampleLength
      expect(categories).to contain_exactly(
        a_category.named("First category").with_topics(a_topic.named("a topic")),
        a_category.named("Second category").with_topics(a_topic.named("another topic")),
        a_category.named("Empty category").with_no_topics,
        a_category.named("Single-topic category").with_topics(a_topic.named("the topic"))
      )
    end
  end
end
