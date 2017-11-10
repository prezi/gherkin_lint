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
          next unless example.key? :tableBody
          example[:tableBody].each do |body|
            next unless body.key? :cells
            body[:cells].each do |cell|
              if body[:cells].empty?
                references = [reference(file, feature, scenario)]
                add_error(references, "Outline example is empty")
              end

              value = cell[:value].delete "\s\n"
              unless value.match(/^[[:alpha:]]+$/)
                references = [reference(file, feature, scenario)]
                add_error(references, "Outline example contains character '#{value}'")
              end
            end
          end
        end
      end
    end
  end
end
