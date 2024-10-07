# frozen_string_literal: true

module TopicMatchers
  extend RSpec::Matchers::DSL

  matcher :a_topic do
    match do |actual|
      actual.is_a?(Topic) && matches_name? && matches_patterns?
    end

    def matches_name?
      return true unless defined?(@topic_name)

      match(@topic_name).matches? actual.name
    end

    def matches_patterns?
      return true unless defined?(@patterns)

      match_array(@patterns).matches? actual.patterns
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
