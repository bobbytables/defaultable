module Defaultable
	class Serialization
		class_attribute :settings_class

	  # Called to deserialize data to ruby object.
	  def load(data)
	  	if data
	    	obj = YAML.load(data)

	    	raise TypeError, "Deserialized object is not of type #{self.class.settings_class.name}. Got #{obj.class}" unless obj.is_a?(self.class.settings_class)

	    	# The reason we do the following is because defaults may have changed
	    	# after the point of serialization. To avoid not having them, we instantiate the class
	    	# again, we the previous values. This prevents not having data.
	    	obj.class.new(obj.as_hash)
	    end
	  end

	  # Called to convert from ruby object to serialized data.
	  def dump(obj)
	  	raise TypeError, "Serialization failed: Object is not of type #{self.class.settings_class.name}." unless obj.is_a?(self.class.settings_class)
	    obj.to_yaml if obj
	  end
	end
end