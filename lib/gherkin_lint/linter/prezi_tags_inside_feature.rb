require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for invalid feature switch location
  class PreziTagsInsideFeature < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      background_and_scenarios do |file, feature, scenario|
        _check_tags_locations(file, feature, scenario)
      end
    end

    def _check_tags_locations(file, feature, scenario)
      feature_location = feature[:location][:line]

      references = [reference(file, feature, scenario)]
      tag_locations = gather_tag_locations(feature)
      _check_tags_location(references, feature_location, tag_locations)

      tag_locations = gather_tag_locations(scenario)
      _check_tags_location(references, feature_location, tag_locations)
    end

    def _check_tags_location(references, feature_location, tag_locations)
      tag_locations.each do |tag|
        add_error(references, "@#{tag[:name]} not at top of the page") if feature_location < tag[:location]
      end
    end
  end
end
