# frozen_string_literal: true

require "pathname"
require "yaml"

RSpec.describe "topics.yml" do
  subject(:topics_file) { Pathname("topics.yml") }

  it { is_expected.to be_exist }

  it "is valid YAML" do
    expect { YAML.load_file(topics_file, aliases: true) }.not_to raise_error
  end

  matcher :be_a_valid_regular_expression do
    match do |pattern|
      Regexp.new(pattern)
      true
    rescue RegexpError => e
      @exception = e
      false
    end

    failure_message do |(category, topic, pattern)|
      "Got #{@exception.class}: #{@exception}"
    end
  end

  YAML.load_file(Pathname("topics.yml"), aliases: true).except("Macros").each do |category, topics|
    topics.each do |topic, patterns|
      patterns.map { |pattern| Array(pattern).join }.each do |pattern|
        describe "#{pattern.inspect} for #{category.downcase} #{topic.inspect}" do
          subject { pattern }

          it { is_expected.to be_a_valid_regular_expression }
        end
      end
    end
  end
end
