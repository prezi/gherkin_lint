require 'gherkin_lint/linter'
require 'engtagger'

module GherkinLint
  class AvoidCharactersInOutlineExample < Linter
    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? :examples
        scenario[:examples].each do |example|
          next unless example.key? :tableHeader

          headers = example[:tableHeader][:cells].map { |cell| cell[:value] }
          headers.each do |value|
            if value_contains_non_alpha(value)
              references = [reference(file, feature, scenario)]
              add_error(references, "Outline example header contains character '#{value}'")
            end
          end

          example[:tableBody].each do |row|
            body = row[:cells].map { |cell| cell[:value] }
            body.each do |value|
              if value_contains_non_alpha(value)
                references = [reference(file, feature, scenario)]
                add_error(references, "Outline example cell contains character '#{value}'")
              end
            end
          end
        end
      end
    end

    def value_contains_non_alpha(value)
      if value.nil?
        return false
      end
      value = value.delete "\s\n"
      unless value.match(/^[[:alpha:]]+$/)
        return true
      end
    end
  end
end
