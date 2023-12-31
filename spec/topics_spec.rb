# frozen_string_literal: true

require "pathname"
require "yaml"

RSpec.describe "topics.yml" do # rubocop:todo RSpec/DescribeClass
  subject(:topics_file) { Pathname("topics.yml") }

  it { is_expected.to be_exist }

  it "is valid YAML" do
    expect { YAML.load_file(topics_file, aliases: true) }.not_to raise_error
  end

  YAML.load_file(Pathname("topics.yml"), aliases: true).reject { |k, _| k.start_with?(".") }.each do |topic, patterns|
    patterns.map { |pattern| Array(pattern).join }.each do |pattern|
      describe "'#{pattern}' for #{topic.inspect}" do
        it "is a valid regular expression" do
          expect(pattern).to be_a_valid_regular_expression
        end
      end
    end
  end

  matcher :be_a_valid_regular_expression do
    match do |pattern|
      Regexp.new(pattern)
      true
    rescue RegexpError => e
      @exception = e
      false
    end

    failure_message do
      "Got #{@exception.class}: #{@exception}"
    end
  end
end
