require 'gherkin_lint/linter'
require 'gherkin_lint/linter/tag_collector'

module GherkinLint
  # service class to lint for tags on separate lines
  class FSOnSeparateLines < Linter
    include TagCollector

    def initialize
      super
    end

    def lint
      features do |file, feature|
        references = [reference(file)]
        description = 'One feature switch per line'
        fs_locations = gather_fs_locations(feature).map { |tag| tag[:location] }.compact
        _check_fs_locations(fs_locations, references, description)
      end
    end

    def _check_fs_locations(fs_locations, references, description)
      return unless fs_locations.uniq.length == 1 && fs_locations.length > 1
      add_error(references, description)
    end
  end
end
