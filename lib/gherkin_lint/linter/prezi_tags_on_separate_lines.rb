require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for tags on separate lines
  class PreziTagsOnSeparateLines < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      features do |file, feature|
        references = [reference(file)]
        description = 'One tag per line'
        tag_locations = gather_tag_locations(feature).map { |tag| tag[:location] }.compact
        _check_tag_locations(tag_locations, references, description)
      end
    end

    def _check_tag_locations(tag_locations, references, description)
      return unless tag_locations.uniq.length == 1 && tag_locations.length > 1
      add_error(references, description)
    end
  end
end
