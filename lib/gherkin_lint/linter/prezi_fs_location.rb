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
          description = 'Avoid enabling/disabling feature switches in steps.'
          bad_words = %w[enable disable]
          bad_words.each do |bad_word|
            add_warning(references, description) if step[:text].include? bad_word
          end
        end

        feature_location = feature[:location][:line]

        tag_locations = gather_tag_locations(feature).map { |tag|  tag[:location]}.compact + gather_tag_locations(scenario).map { |tag|  tag[:location]}.compact
        last_tag_locations = tag_locations.max

        references = [reference(file, feature, scenario)]

        tags = gather_tag_locations(feature)
        tags.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled at top of the page.")
          end
        end

        tags = gather_tag_locations(scenario)
        tags.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled at top of the page.")
          end
        end

        tags = gather_fs_locations(feature)
        tags.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled at top of the page.")
          end
          if last_tag_locations > tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled after tags.")
          end
        end

        tags = gather_fs_locations(scenario)
        tags.each do |tag|
          if feature_location < tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled at top of the page.")
          end
          if last_tag_locations > tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled after tags.")
          end
        end
      end
    end

  end
end
