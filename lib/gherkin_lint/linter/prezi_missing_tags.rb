require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for missing tags
  class MissingTags < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        references = [reference(file)]
        tags = gather_tags(feature) + gather_tags(scenario)

        _check_platform_tags(references, tags)
        _check_team_tags(references, tags)
      end
    end

    def _check_platform_tags(references, tags)
      platforms = %w[all-platforms desktop android iphone ipad]
      platforms.each do |platform|
        tags.each do |tag|
          next unless tag.include? platform
          platforms -= [platform]
        end
      end

      return unless platforms.length == 5
      add_error(references, 'Missing platform tag')
    end

    def _check_team_tags(references, tags)
      teams = tags.map { |tag| tag.start_with?('team') }
      return unless teams.count(true).zero?
      add_error(references, 'Missing team tag')
    end
  end
end
