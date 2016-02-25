
module MethodLoggingFramework
  def self.log(object, name, args, keyword_args, block)
    puts "#{object}##{name}(#{args}, #{keyword_args}, #{block})"
  end
end

class Object
  def self.log_method_call(name, class_method: false)
    m = class_method ? singleton_method(name) : instance_method(name)

    method_defining_method = class_method ? method(:define_singleton_method) : method(:define_method)

    method_defining_method.call(name) do |*args, **keyword_args, &block|
      MethodLoggingFramework.log(self, name, args, keyword_args, block)

      if class_method
        m.call(*args, &block)
      else
        bound_method = m.bind(self)
        bound_method.call(*args, &block)
      end
    end
  end

  def self.method_added(name)
    return if name.to_s == 'method_added'
    return if method_has_been_added?(name)


    record_method_adding(name)

    log_method_call(name, class_method: false)
  end

  def self.method_has_been_added? name
    return unless defined? @@added_methods
    return unless @@added_methods[self]
    @@added_methods[self][name]
  end

  def self.record_method_adding(name)
    #puts "recording method addition for #{self} #{name}"
    @@added_methods ||= {}
    @@added_methods[self] ||= {}
    @@added_methods[self][name]=true
  end
end

class BasicObject
  def self.singleton_method_added(name)
    return if name.to_s == 'singleton_method_added'
    return if method_has_been_added?(name)


    record_method_adding(name)

    log_method_call(name, class_method: true)
  end
end

class Example
  def some_method(_some_arg)
    @some_instance_variable = 1
  end
  def another_method(*_args_name)
    2
  end
end

class Egg
  def self.a_class_method
  end
  def another(param, *args, qwer: 3)
    yield 1
  end
end

Example.new.some_method "asdf"

Egg.new.another("asdf", 1,2,3, {qwer: 2}) do |asdf|
  "asdf"
end

Egg.a_class_method
