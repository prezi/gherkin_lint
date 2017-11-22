require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoid scripting
  class UseGivenWhenThenOnce < Linter
    def lint
      counts_background = Hash.new 0
      background_and_scenarios do |file, feature, scenario, steps|
        counts = Hash.new 0
        if scenario[:type] == :Background
          scenario[:steps].map { |step| counts_background['Given'] += 1 if step[:keyword] == 'Given ' }.compact
          scenario[:steps].map { |step| counts_background['When'] += 1 if step[:keyword] == 'When ' }.compact
          scenario[:steps].map { |step| counts_background['Then'] += 1 if step[:keyword] == 'Then ' }.compact
        else
          scenario[:steps].map { |step| counts['Given'] += 1 if step[:keyword] == 'Given ' }.compact
          scenario[:steps].map { |step| counts['When'] += 1 if step[:keyword] == 'When ' }.compact
          scenario[:steps].map { |step| counts['Then'] += 1 if step[:keyword] == 'Then ' }.compact
        end

        if counts['Given'] + counts_background['Given'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Given steps')
        end

        if counts['When'] + counts_background['When'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple When steps')
        end

        if counts['Then'] + counts_background['Then'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Then steps')
        end
      end
    end
  end
end
