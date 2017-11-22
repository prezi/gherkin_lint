require 'gherkin_lint/linter'

module GherkinLint
  class AvoidSentencesContaining < Linter
    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          description = 'Avoid steps containing with "I click...", "I see...", "I should...", "I go to...", "I fill"'
          bad_words = %w[I\ click I\ see I\ should I\ go\ to I\ fill]
          bad_words.each do |bad_word|
            add_warning(references, description) if step[:text].include? bad_word
          end
        end
      end
    end
  end
end
