class EfferentCoupling
  def instance_coupling(instance)
    instance.this_message
    instance.that_message
    instance.tons_more
  end

  def more_instance_coupling(instance, another)
    instance.this_message
    instance.another_message
    instance.yet_more
    instance.here_we_go

    another.message
    another.second_message
  end
end
