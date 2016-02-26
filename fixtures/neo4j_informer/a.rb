class A
  def method_a
    b = B.new
    b.method_b
  end
end

a = A.new
a.method_a
