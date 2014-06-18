-- Since most work is in your TupleProcessor, this file serves as a simple shim
-- that loads data into raw lines, and sends them off to your UDF.
-- As a result, it will mostly stay the same.
-- You can tweak any M/R or Pig params here as well.

REGISTER 'your-warbled-dependencies-jar.jar'
REGISTER 'tuple_processor_udf.rb' USING jruby AS processor;

data = FOREACH ( LOAD '/raw-data' AS (line:CHARARRAY) )
        GENERATE flatten(process.process(line));

store data into '/out-data' USING PARQUETFILE

