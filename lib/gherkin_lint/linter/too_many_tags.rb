require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for too many tags
  class TooManyTags < Linter
    include TagCollector

    def lint
      scenarios do |file, feature, scenario|
        tags = gather_tags(feature) + gather_tags(scenario)
        next unless tags.length >= 8
        references = [reference(file, feature, scenario)]
        add_warning(references, "Used #{tags.length} Tags")
      end
    end
  end
end
