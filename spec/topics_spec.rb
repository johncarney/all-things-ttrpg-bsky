# frozen_string_literal: true

require "pathname"
require "yaml"

RSpec.describe "topics.yml" do
  subject(:topics_file) { Pathname("topics.yml") }

  it { is_expected.to be_exist }

  it "is valid YAML" do
    expect { YAML.load_file(topics_file, aliases: true) }.not_to raise_error
  end

  describe "topic patterns" do
    subject(:topic_patterns) do
      YAML.load_file(topics_file, aliases: true).except("Macros").flat_map do |category, topics|
        topics.flat_map do |topic, patterns|
          patterns.map { |pattern| [category, topic, Array(pattern).join] }
        end
      end
    end

    matcher :be_valid_regular_expression do
      match do |(category, topic, pattern)|
        Regexp.new(pattern)
        true
      rescue RegexpError => e
        @exception = e
        false
      end

      failure_message do |(category, topic, pattern)|
        "Got #{@exception.class}: #{@exception} in #{category} #{topic.inspect}"
      end
    end

    specify "all patterns are valid regular expressions" do
      expect(topic_patterns).to all(be_valid_regular_expression)
    end
  end
end
