require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  class TagsOnSeperateLines < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        references = [reference(file, feature, scenario)]

        tag_locations = gather_tag_locations(feature).map { |tag|  tag[:location]}.compact + gather_tag_locations(scenario).map { |tag|  tag[:location]}.compact

        if tag_locations.uniq.length == 1 and tag_locations.length > 1
          add_error(references, "One tag per line.")
        end

        tag_locations = gather_fs_locations(feature).map { |tag|  tag[:location]}.compact + gather_fs_locations(scenario).map { |tag|  tag[:location]}.compact

        if tag_locations.uniq.length == 1 and tag_locations.length > 1
          add_error(references, "One feature switch per line.")
        end
      end
    end
  end
end
