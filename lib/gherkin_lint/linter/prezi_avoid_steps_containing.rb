require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for invalid strings
  class PreziAvoidStepsContaining < Linter
    def initialize
      super
    end

    def lint
      background_and_scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          description = 'Avoid steps containing with "I click", "I see", "I should", "I go to", "I fill"'
          bad_words = %w[I\ click I\ see I\ should I\ go\ to I\ fill]
          bad_words.each do |bad_word|
            add_warning(references, description) if step[:text].include? bad_word
          end
        end
      end
    end
  end
end