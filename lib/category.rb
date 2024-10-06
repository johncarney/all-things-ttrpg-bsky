# frozen_string_literal: true

class Category
  attr_reader :name, :topics

  def initialize(name, topics:)
    @name = name
    @topics = topics
  end

  def matches?(string)
    string.casecmp?(name)
  end
end
