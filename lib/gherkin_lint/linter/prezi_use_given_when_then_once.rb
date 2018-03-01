require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for invalid steps
  class PreziUseGivenWhenThenOnce < Linter
    def lint
      background_and_scenarios do |file, feature, scenario|
        references = [reference(file, feature, scenario)]
        counts = Hash.new 0
        counts[:background] = Hash.new 0
        counts[:scenario] = Hash.new 0
        if scenario[:type] == :Background
          counts[:background] = _count_occurrences_in_scenario(scenario)
        else
          counts[:scenario] = _count_occurrences_in_scenario(scenario)
        end

        _iterate_over_steps(references, counts)
      end
    end

    def _count_occurrences_in_scenario(scenario)
      counts = Hash.new 0
      steps = %w[Given When Then]
      steps.each do |starts_with|
        _counter(scenario, counts, starts_with)
      end
      counts
    end

    def _counter(scenario, counts, starts_with)
      scenario[:steps].map { |step| counts[starts_with] += 1 if step[:keyword] == starts_with + ' ' }.compact
    end

    def _iterate_over_steps(references, counts)
      steps = %w[Given When Then]
      steps.each do |starts_with|
        _check_steps(references, counts, starts_with)
      end
    end

    def _check_steps(references, counts, starts_with)
      return unless counts[:scenario][starts_with] + counts[:background][starts_with] > 1
      add_error(references, "Multiple #{starts_with} steps")
    end
  end
end
