module GherkinLint
  # Mixin to lint for tags based on their relationship to eachother
  module TagCollector
    def gather_tags(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag|  tag[:name][1..-1] unless tag[:name].include? '-fs' }.compact
    end

    def gather_fs(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| tag[:name][1..-1]if tag[:name].include? '-fs' }.compact
    end

    def gather_tag_locations(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag|  {:name => tag[:name][1..-1], :location => tag[:location][:line]} unless tag[:name].include? '-fs' }.compact
    end

    def gather_fs_locations(element)
      return {} unless element.include? :tags
      element[:tags].map { |tag| {:name => tag[:name][1..-1], :location => tag[:location][:line]} if tag[:name].include? '-fs' }.compact
    end
  end
end
