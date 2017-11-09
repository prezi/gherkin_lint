require 'gherkin_lint/linter'
require 'engtagger'

module GherkinLint
  class AvoidSentencesStartingWith < Linter
    def initialize
      super
    end

    def lint
      filled_scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          add_warning(references, 'avoid steps starting with "I click...", "I see...", "I should...", "I go to..."') unless words? step
        end
      end
    end

    def words?(step)
      tagged = tagger.add_tags step[:text]
      step_words = words tagged

      !step_words.empty?
    end

    def words(tagged_text)
      words =
        %i[
          'I click'
          'I see'
          'I should'
          'I go to'
        ]

      words.map { |words| tagger.send(words, tagged_text).keys }.flatten
    end

    def tagger
      @tagger = EngTagger.new unless instance_variable_defined? :@tagger

      @tagger
    end
  end
end
