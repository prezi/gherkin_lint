require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for too long steps
  class TooLongStep < Linter
    def lint
      steps do |file, feature, scenario, step|
        next if step[:text].length < 113
        references = [reference(file, feature, scenario, step)]
        add_error(references, "Used #{step[:text].length} characters (max 112)")
      end
    end
  end
end
