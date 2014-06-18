# Hog

Supercharge your Ruby Pig UDFs with Hog.  


## Why Use Hog?

Use Hog when you want to process (map) tuples with Hadoop, and generally
belive that:

* It's too much overhead to write custom M/R code
* You're too lazy to process with Pig data pipes and sprinkled custom UDFs, and they're not powerful
  enough anyway.
* Data processing with Hive queries is wrong
* Cascading is an overkill for your case
* Streaming Hadoop (unix processes) is the last resort

And instead want to develop within your familiar Ruby ecosystem but
also:

* Control and tweak job parameters via Pig
* Use Pig's job management
* Use Pig's I/O (serdes) easily

And you also want to use gems, jars, and everything Ruby (JRuby) has to offer for a really quick turn-around and pleasent development experience.


## Quickstart

Let's say you want to perform geolocation, detect a device's form
factor, and shove bits and fields from the nested structure into a Hive table to be able to query
it efficiently.

This is your raw event:

```javascript
{
  "x-forwarded-for":"8.8.8.8",
  "user-agent": "123",
  "pageview": {
    "userid":"ud-123",
    "timestamp":123123123,
    "headers":{
      "user-agent":"...",
      "cookies":"..."
    }
  }
}
```

To do this with Pig alone, you would need:

* A pig UDF for geolocation
* A pig UDF for form-factor detection
* A way to extract JSON fields from a tuple in Pig
* Combine everything in Pig code

And you'll give up

* Testability
* Maintainability
* Development speed
* Eventually, sanity


#### Using Hog

With Hog, you'll mostly feel you're _describing_ how you want the data to be
shaped, and it'll do the heavy lifting. 

You always have the option to 'drop' to code with the `prepare`
block.


```ruby
# gem install hog
require 'hog'

TupleProcessor = Hog.tuple "mytuple" do

  # Your own custom feature extraction. This can be any free style
  # Ruby or Java code
  #
  prepare do |hsh|
    loc = ip2location(hsh["x-forwarded-for"])
    hsh.merge!(loc)

    form_factor = formfactor(hsh["user-agent"])
    hsh.merge!(form_factor)
  end


  # Describe your data columns (i.e. for Hive), and how you'd like
  # to pull them out of your nested data.
  #
  # You can also put a fixed value, or serialize a sub-nested
  # structure as-is for later use with Hive's json_object
  #
  chararray :id, :path => 'pageview.userid'
  chararray :created_at, :path => 'pageview.timestamp', :with_nil => ''
  float :sampling, :value => 1.0
  chararray :ev_type, :value => 'pageview'
  chararray :ev_info, :json => 'pageview.headers', :default => {}
end
```

As you'll notice - there's very little code, and you specify the bare
essentials -- which you would have had to specify (types and fields) with Pig in any way you'd try to use it.


Hog will generate a `TupleProcessor` that conforms to your description and logic.


#### Testing

To test your mapper, just use `TupleProcessor` within your specs and
give it a raw event. It's plain Ruby.


#### Hadoop

To hookup with Hadoop, rig `TupleProcessor` within a Pig JRuby UDF shell like so:

```
require 'tuple_processor'
require 'pigudf'

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
```


## Gems and Jars

So you can't really use gems or jars with Pig Ruby UDFs unless all machines have
them; and then it becomes ugly to manage really.

The solution is neat: pack everything as you would with a JRuby project,
for example, use `warbler`; and your job code becomes a standalone-jar
which you deploy, version, and possibly generate via CI.


## Related Projects

* PigPen - https://github.com/Netflix/PigPen
* datafu - https://github.com/linkedin/datafu


# Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).

# Copyright

Copyright (c) 2014 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.


