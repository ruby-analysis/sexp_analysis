class EfferentCoupling
  def instance_coupling(some_instance)
    some_instance.this_message
    some_instance.that_message
    some_instance.tons_more
  end

  def more_instance_coupling(some_instance, another)
    some_instance.this_message
    some_instance.another_message
    some_instance.yet_more
    some_instance.here_we_go

    another.message
    another.second_message
  end
end
