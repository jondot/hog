class PigUdf
  def self.outputSchema(str)

  end
end

class DataBag
  attr_reader :data
  def initialize
    @data = []
  end
  def add(el)
    @data << el
  end
end

