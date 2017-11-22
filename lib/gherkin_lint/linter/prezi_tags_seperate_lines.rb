require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  class TagsOnSeperateLines < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      features do |file, feature|
        references = [reference(file)]

        tag_locations = gather_tag_locations(feature).map { |tag|  tag[:location]}.compact

        if tag_locations.uniq.length == 1 and tag_locations.length > 1
          add_error(references, "One tag per line")
        end

        fs_locations = gather_fs_locations(feature).map { |tag|  tag[:location]}.compact

        if fs_locations.uniq.length == 1 and fs_locations.length > 1
          add_error(references, "One feature switch per line")
        end
      end
    end
  end
end
