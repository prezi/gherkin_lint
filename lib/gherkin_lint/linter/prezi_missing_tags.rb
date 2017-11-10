require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  class MissingTags < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        tags = gather_tags(feature) + gather_tags(scenario)

        platforms = %w[all-platforms desktop android iphone ipad]
        platforms.each do |platform|
          tags.each do |tag|
            if tag.include? platform
              platforms -= [platform]
            end
          end
        end

        if platforms.length == 5
          references = [reference(file, feature, scenario)]
          add_error(references, 'Missing platform tag')
        end

        teams = tags.map { |tag| tag.start_with?('team') }
        if teams.count(true) == 0
          references = [reference(file, feature, scenario)]
          add_error(references, 'Missing team tag')
        end
      end

    end
  end
end
