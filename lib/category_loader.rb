# frozen_string_literal: true

require_relative "category"

require "pathname"

class CategoryLoader
  def self.from_hash(hash, &topic_resolver)
    hash.reject { |key, _| key.start_with?(".") }.map do |name, topic_names|
      topics = Array(topic_names).flat_map do |topic_name|
        Array(topic_resolver.call(topic_name))
      end
      Category.new(name, topics:)
    end
  end

  def self.from_file(category_file, &)
    hash = YAML.safe_load(Pathname(category_file).read, aliases: true)
    from_hash(hash, &)
  end
end
