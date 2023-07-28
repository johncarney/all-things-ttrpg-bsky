# frozen_string_literal: true

class Topic
  attr_reader :name, :patterns

  def initialize(name, patterns:)
    @name = name
    @patterns = patterns
  end

  def errors
    patterns.map do |pattern|
      Regexp.new(pattern)
      nil
    rescue RegexpError => e
      "#{e.class}: #{e} for #{name.inspect}"
    end.compact
  end
end