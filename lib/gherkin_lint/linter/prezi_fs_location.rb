require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for invalid feature switch location
  class FeatureSwitchInsideFeature < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      background_and_scenarios do |file, feature, scenario|
        _check_fs_locations(file, feature, scenario)
        _check_fs_inside_steps(file, feature, scenario)
      end
    end

    def _check_fs_locations(file, feature, scenario)
      feature_location = feature[:location][:line]

      references = [reference(file, feature, scenario)]
      fs_locations = gather_fs_locations(feature)
      _check_fs_location(references, feature_location, fs_locations)

      fs_locations = gather_fs_locations(scenario)
      _check_fs_location(references, feature_location, fs_locations)
    end

    def _check_fs_location(references, feature_location, fs_locations)
      fs_locations.each do |fs|
        if feature_location < fs[:location]
          add_error(references, "@#{fs[:name]} not enabled/disabled at top of the page")
        end
      end
    end

    def _check_fs_inside_steps(file, feature, scenario)
      scenario[:steps].each do |step|
        references = [reference(file, feature, scenario, step)]
        description = 'Avoid enabling/disabling feature switches in steps'
        fs_words = %w[enable disable]
        fs_words.each do |fs_word|
          add_error(references, description) if step[:text].include? fs_word
        end
      end
    end
  end
end
