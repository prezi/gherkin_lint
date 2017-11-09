require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for bad scenario names
  class BadScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next if scenario[:name].empty?
        references = [reference(file, feature, scenario)]
        description = 'avoid scenario names containing with "test", "verify", "check"'
        bad_words = %w[test verif check]
        bad_words.each do |bad_word|
          add_warning(references, description) if scenario[:name].downcase.include? bad_word
        end
      end
    end
  end
end
