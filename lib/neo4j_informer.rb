module Neo4jInformer
  def self.query_for(
    class_method, args, keyword_args,
    calling_klass,calling_file, calling_line_number, calling_method,
    called_klass, called_file,  called_line_number,  called_method
  )

     <<-QUERY
      MERGE (k1:#{calling_klass})
      MERGE (k1)-[:OWNS]->(m1:InstanceMethod{name: "#{calling_method}"})
      MERGE (m1)<-[:CALLED_BY]-(mc:MethodCall{file: "#{calling_file}", line_number: "#{calling_line_number}"})

      MERGE (mc)-[:CALLS]->(m2:InstanceMethod{name: "#{called_method}"})
      MERGE (k2:#{called_klass})
      MERGE (k2)-[:OWNS]->(m2)

      SET m2.file = "#{called_file}"
      SET m2.line_number = "#{called_line_number}"
    QUERY
  end

  def self.execute_query(
    class_method, args, keyword_args,
    calling_klass,calling_file, calling_line_number, calling_method,
    called_klass, called_file,  called_line_number,  called_method
  )
    query = query_for(
      class_method, args, keyword_args,
      calling_klass,calling_file, calling_line_number, calling_method,
      called_klass, called_file,  called_line_number,  called_method
    )

    Neo4j::Session.query(query)
  end
end
