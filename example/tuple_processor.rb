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

