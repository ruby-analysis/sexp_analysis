require_relative "neo4j_informer"

describe Neo4jInformer do
  #class_method        false
  #args                []
  #keyword_args        {}

  #calling_klass       Recommendations::RecommendedProduct
  #calling_file        app/models/product.rb
  #calling_line_number 701
  #calling_method      url

  #called_klass       Partner
  #called_file        app/models/partner.rb
  #called_line_number 710
  #called_method      to_param
  it "with zero args" do
    class_method        = false
    args                = []
    keyword_args        = {}

    calling_klass       = "A"
    calling_file        = "a.rb"
    calling_line_number = "4"
    calling_method      = "method_a"

    called_klass        = "B"
    called_file         = "b.rb"
    called_line_number  = "2"
    called_method       = "method_b"


    query = Neo4jInformer.query_for(class_method, args, keyword_args, 
                                    calling_klass,calling_file, calling_line_number, calling_method,
                                    called_klass, called_file,  called_line_number,  called_method
                                   )

    expected = <<-QUERY
      MERGE (k1:A)
      MERGE (k1)-[:OWNS]->(m1:InstanceMethod{name: "method_a"})
      MERGE (m1)<-[:CALLED_BY]-(mc:MethodCall{file: "a.rb", line_number: "4"})

      MERGE (mc)-[:CALLS]->(m2:InstanceMethod{name: "method_b"})
      MERGE (k2:B)
      MERGE (k2)-[:OWNS]->(m2)

      SET m2.file = "b.rb"
      SET m2.line_number = "2"
    QUERY

    expect(strip_whitespace query).to eq strip_whitespace(expected)
  end

  def strip_whitespace(s)
    s.gsub("  ", " ").gsub("\n\n", "\n")
  end
end
