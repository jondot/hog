require 'pigudf'
require 'tuple_processor'

class TupleProcessorUdf < PigUdf
  # TupleProcessor will automatically generate your UDF schema!, no matter how complex or
  # convoluted.
  outputSchema TupleProcessor.schema

  # Use TupleProcessor as the processing logic.
  def process(line)
    # since 1 raw json can output several rows, 'process' returns
    # an array. we pass that to Pig as Pig's own 'DataBag'.
    # You can also do without and just return whatever TupleProcessor#process returns.
    databag = DataBag.new
    TupleProcessor.process(line).each do |res|
      databag.add(res)
    end

    databag
  end
end

