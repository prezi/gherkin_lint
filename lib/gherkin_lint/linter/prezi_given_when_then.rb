require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoid scripting
  class UseGivenWhenThenOnce < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        steps = scenario[:steps].map { |step| step[:keyword] == 'Given' }

        if steps.uniq.length > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Given steps.')
        end

        steps = scenario[:steps].map { |step| step[:keyword] == 'When' }

        if steps.uniq.length > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple When steps.')
        end

        steps = scenario[:steps].map { |step| step[:keyword] == 'Then' }

        if steps.uniq.length > 1
          references = [reference(file, feature, scenario)]
          add_error(references, 'Multiple Then steps.')
        end
      end
    end
  end
end
