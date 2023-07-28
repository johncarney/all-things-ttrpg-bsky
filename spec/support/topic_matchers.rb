# frozen_string_literal: true

module TopicMatchers
  extend RSpec::Matchers::DSL

  matcher :a_topic do
    match do |actual|
      actual.is_a?(Topic) &&
        matches_name?(actual) &&
        matches_patterns?(actual)
    end

    def matches_name?(actual)
      return true unless defined?(@topic_name)

      actual.name == @topic_name
    end

    def matches_patterns?(actual)
      return true unless defined?(@patterns)

      actual.patterns.sort == @patterns.sort
    end

    chain :named do |topic_name|
      @topic_name = topic_name
    end

    chain :with_patterns do |*patterns|
      @patterns = patterns
    end

    chain :with_no_patterns do
      @patterns = []
    end
  end

  alias_matcher :be_a_topic, :a_topic
end
