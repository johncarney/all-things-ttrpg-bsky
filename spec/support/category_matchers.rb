# frozen_string_literal: true

module CategoryMatchers
  extend RSpec::Matchers::DSL

  matcher :a_category do
    match do |actual|
      actual.is_a?(Category) && matches_name? && matches_topics?
    end

    def matches_name?
      return true unless defined?(@category_name)

      match(@category_name).matches? actual.name
    end

    def matches_topics?
      return true unless defined?(@topics)

      match_array(@topics).matches? actual.topics
    end

    chain :named do |category_name|
      @category_name = category_name
    end

    chain :with_topics do |*topics|
      @topics = topics
    end

    chain :with_no_topics do
      @topics = []
    end
  end

  alias_matcher :be_a_category, :a_category
end
