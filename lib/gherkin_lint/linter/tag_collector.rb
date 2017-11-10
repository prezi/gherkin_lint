module GherkinLint
  # Mixin to lint for tags based on their relationship to eachother
  module TagCollector
    def gather_tags(element)
      return [] unless element.include? :tags
      tags = element[:tags].map { |tag| tag[:name][1..-1] }
      feature_switches = %w[enable-fs disable-fs]
      feature_switches.each do |fs|
        tags.each do |tag|
          if tag.include? fs
            tags -= [tag]
          end
        end
      end
      return tags
    end

    def gather_feature_switches(element)
      return [] unless element.include? :tags
      tags = element[:tags].map { |tag| tag[:name][1..-1] }
      feature_switches = %w[enable-fs disable-fs]
      feature_switches.each do |fs|
        tags.each do |tag|
          unless tag.include? fs
            tags -= [tag]
          end
        end
      end
      return tags
    end
  end
end
