# frozen_string_literal: true

require_relative "topic"

require "pathname"

class CategoryLoader
  def self.from_hash(hash, &topic_resolver)
    hash.reject { |key, _| key.start_with?(".") }.map do |name, topic_names|
      Category.new(name, topics: topic_resolver.call(*topic_names))
    end
  end

  def self.from_file(category_file, &topic_resolver)
    hash = YAML.safe_load(Pathname(category_file).read, aliases: true)
    from_hash(hash, &topic_resolver)
  end
end
