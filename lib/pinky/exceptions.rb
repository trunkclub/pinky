module Pinky
  class NotFoundException < StandardError
  end

  class TooManyFoundException < StandardError
  end

  class ItemFetchException < StandardError
  end
end
