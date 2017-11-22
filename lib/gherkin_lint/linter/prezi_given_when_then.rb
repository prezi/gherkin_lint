require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoid scripting
  class UseGivenWhenThenOnce < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        counts = Hash.new 0

        backgrounds do |file, feature, background|
          background[:steps].map { |step| counts['Given'] += 1 if step[:keyword] == 'Given ' }.compact
          background[:steps].map { |step| counts['When'] += 1 if step[:keyword] == 'When ' }.compact
          background[:steps].map { |step| counts['Then'] += 1 if step[:keyword] == 'Then ' }.compact
        end

        scenario[:steps].map { |step| counts['Given'] += 1 if step[:keyword] == 'Given ' }.compact
        scenario[:steps].map { |step| counts['When'] += 1 if step[:keyword] == 'When ' }.compact
        scenario[:steps].map { |step| counts['Then'] += 1 if step[:keyword] == 'Then ' }.compact

        if counts['Given'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Given steps')
        end

        if counts['When'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple When steps')
        end

        if counts['Then'] > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Then steps')
        end
      end
    end
  end
end
