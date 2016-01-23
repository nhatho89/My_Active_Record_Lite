class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}") do
        instance_variable_get("@#{name}")
      end
    end

    names.each do |name|
      define_method("#{name}=") do |el|
        instance_variable_set("@#{name}", el)
      end
    end
  end
end
