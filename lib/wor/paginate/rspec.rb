CHAINABLE_FIELDS = %w[total_count count total_pages current_page next_page previous_page].freeze

class MockedAdapter < Wor::Paginate::Adapters::Base
  def initialize
    super(nil, 1, 1)
  end

  def count
    3
  end

  def total_count
    5
  end

  def total_pages
    10
  end

  def next_page
    2
  end

  def page
    1
  end

  def paginated_content
    []
  end
end

class PaginatedAssertion
  attr_reader :failures, :formatted_keys

  def initialize(response, formatter, expectations)
    @response = response
    formatted = formatter.new(MockedAdapter.new, _current_url: 'http://example.com/')
    @formatted_keys = formatted.format.as_json.keys
    @failures = key_failures + field_failures(expectations)
  end

  def pass?
    @failures.empty?
  end

  private

  def key_failures
    return [] if @response.keys == @formatted_keys

    ["expected keys #{@formatted_keys} but got #{@response.keys}"]
  end

  def field_failures(expectations)
    CHAINABLE_FIELDS.filter_map do |field|
      expected = expectations[field]
      next if expected.nil?

      actual = @response[field]
      next if actual == expected

      "expected #{field} to be #{expected.inspect} but got #{actual.inspect}"
    end
  end
end

RSpec::Matchers.define :be_paginated do
  match do |actual_response|
    formatter = @custom_formatter || Wor::Paginate::Formatters::Base
    expectations = CHAINABLE_FIELDS.index_with { |f| instance_variable_get(:"@expected_#{f}") }
    @assertion = PaginatedAssertion.new(parse_response(actual_response), formatter, expectations)
    @assertion.pass?
  end

  def parse_response(response)
    response.is_a?(Hash) ? response : JSON.parse(response.body)
  end

  chain(:with) { |formatter| @custom_formatter = formatter }

  CHAINABLE_FIELDS.each do |field|
    chain(:"with_#{field}") { |value| instance_variable_set(:"@expected_#{field}", value) }
  end

  failure_message { |_| @assertion.failures.join("\n") }

  failure_message_when_negated do |actual_response|
    "expected that #{parse_response(actual_response)} not " \
     "to be paginated with keys #{@assertion.formatted_keys}"
  end
end
