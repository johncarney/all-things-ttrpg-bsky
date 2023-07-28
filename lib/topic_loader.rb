# frozen_string_literal: true

require_relative "topic"

require "pathname"

class TopicLoader
  def self.from_hash(hash)
    hash.reject { |key, _| key.start_with?(".") }.map do |name, patterns|
      patterns = Array(patterns).map { |pattern| Array(pattern).join }
      Topic.new(name, patterns:)
    end
  end

  def self.from_file(topic_file)
    hash = YAML.safe_load(Pathname(topic_file).read, aliases: true)
    from_hash(hash)
  end
end
