require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for invalid tag/fs order
  class TagsFeatureSwitchOrder < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      background_and_scenarios do |file, feature, scenario|
        last_tag_location = _get_last_tag_location(feature, scenario)

        references = [reference(file, feature, scenario)]
        feature_switches = gather_fs_locations(feature)
        _check_fs_tag_order(references, last_tag_location, feature_switches)

        feature_switches = gather_fs_locations(scenario)
        _check_fs_tag_order(references, last_tag_location, feature_switches)
      end
    end

    def _get_last_tag_location(feature, scenario)
      tag_locations_feature = gather_tag_locations(feature).map { |tag| tag[:location] }.compact
      tag_locations_scenario = gather_tag_locations(scenario).map { |tag| tag[:location] }.compact
      tag_locations = tag_locations_feature + tag_locations_scenario
      tag_locations.max
    end

    def _check_fs_tag_order(references, last_tag_location, feature_switches)
      feature_switches.each do |fs|
        if last_tag_location > fs[:location]
          add_error(references, "@#{fs[:name]} not enabled/disabled after tags")
        end
      end
    end
  end
end
