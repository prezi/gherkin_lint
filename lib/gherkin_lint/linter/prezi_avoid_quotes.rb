require 'gherkin_lint/linter'

module GherkinLint
  class AvoidQuotes < Linter
    def initialize
      super
    end

    def lint
      scenarios do |file, feature, scenario|
        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          description = 'Avoid using quotes in steps'
          quotes = %w[" ']
          counts = Hash.new 0
          quotes.each do |quote|
            add_warning(references, description) if step[:text].scan(/(?=#{quote})/).count > 1
            counts[quote] += 1 if step[:text].include? quote
          end
        end
      end
    end
  end
end