require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  class TagsFeatureSwitchOrder < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        tag_locations = gather_tag_locations(feature).map { |tag|  tag[:location]}.compact + gather_tag_locations(scenario).map { |tag|  tag[:location]}.compact
        last_tag_locations = tag_locations.max

        references = [reference(file, feature, scenario)]

        tags = gather_fs_locations(feature)
        tags.each do |tag|
          if last_tag_locations > tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled after tags")
          end
        end

        tags = gather_fs_locations(scenario)
        tags.each do |tag|
          if last_tag_locations > tag[:location]
            add_error(references, "@#{tag[:name]} not enabled/disabled after tags")
          end
        end
      end
    end

  end
end
