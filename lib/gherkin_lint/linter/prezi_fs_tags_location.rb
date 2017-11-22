require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  class FeatureSwitchInsideFeature < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          description = 'Avoid enabling/disabling feature switches in steps'
          bad_words = %w[enable disable]
          bad_words.each do |bad_word|
            add_warning(references, description) if step[:text].include? bad_word
          end
        end

        backgrounds do |file, feature, background|
          background[:steps].each do |step|
            references = [reference(file, feature, scenario, step)]
            description = 'Avoid enabling/disabling feature switches in steps'
            bad_words = %w[enable disable]
            bad_words.each do |bad_word|
              add_warning(references, description) if step[:text].include? bad_word
            end
          end
        end

        # Todo: put the next section into a different rule
        feature_location = feature[:location][:line]
        references = [reference(file, feature, scenario)]

        tag_locations = gather_tag_locations(feature)
        tag_locations.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not at top of the page")
          end
        end

        tag_locations = gather_tag_locations(scenario)
        tag_locations.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not at top of the page")
          end
        end

        fs_locations = gather_fs_locations(feature)
        fs_locations.each do |fs|
          if feature_location < fs[:location]
            add_error(references, "@#{fs[:name]} not enabled/disabled at top of the page")
          end
        end

        fs_locations = gather_fs_locations(scenario)
        fs_locations.each do |fs|
          if feature_location < fs[:location]
            add_error(references, "@#{fs[:name]} not enabled/disabled at top of the page")
          end
        end
      end
    end

  end
end
