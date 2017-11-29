require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for invalid characters in outline
  class AvoidCharactersInOutlineExample < Linter
    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? :examples
        scenario[:examples].each do |example|
          next unless example.key? :tableHeader
          references = [reference(file, feature, scenario)]
          _check_example_header(references, example)
          _check_example_body(references, example)
        end
      end
    end

    def _value_contains_non_alpha(value)
      return if value.nil?
      value = value.delete "\s\n"
      value = value.tr('0-9', '')
      true unless /^[[:alpha:]]+$/ =~ value
    end

    def _check_example_header(references, example)
      headers = example[:tableHeader][:cells].map { |cell| cell[:value] }
      headers.each do |value|
        if _value_contains_non_alpha(value)
          add_error(references, "Outline example header contains character '#{value}'")
        end
      end
    end

    def _check_example_body(references, example)
      example[:tableBody].each do |row|
        body = row[:cells].map { |cell| cell[:value] }
        body.each do |value|
          if _value_contains_non_alpha(value)
            add_error(references, "Outline example cell contains character '#{value}'")
          end
        end
      end
    end
  end
end
