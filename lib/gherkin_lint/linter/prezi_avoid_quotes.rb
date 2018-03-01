require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoiding quotes
  class PreziAvoidQuotes < Linter
    def initialize
      super
    end

    def lint
      background_and_scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          quotes = %w[" ']
          counts = Hash.new 0
          quotes.each do |quote|
            add_warning(references, 'Avoid using quotes in steps') if step[:text].scan(/(?=#{quote})/).count > 1
            counts[quote] += 1 if step[:text].include? quote
          end
        end
      end
    end
  end
end
