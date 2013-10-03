java_import java.util.LinkedHashMap
java_import java.util.Collections

module Pinky
  class LruCache < LinkedHashMap
    attr_reader :maxEntries

    def initialize(maxEntries)
      super(maxEntries + 1, 1, true)
      @maxEntries = maxEntries;
    end

    def removeEldestEntry(map)
      return true if size > @maxEntries
    end
  end
end