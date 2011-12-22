module Defaultable
	class Serialization
		class_attribute :settings_class

	  # Called to deserialize data to ruby object.
	  def load(data)
	  	if data
	    	obj = YAML.parse(data)

	    	raise TypeError, "Deserialized object is not of type #{self.class.settings_class.name}." unless obj.is_a?(self.class.settings_class)
	    	obj.class.new(obj.as_hash)
	    end
	  end

	  # Called to convert from ruby object to serialized data.
	  def dump(obj)
	  	raise TypeError, "Serialization failed: Object is not of type #{self.class.settings_class.name}." unless obj.is_a?(self.class.settings_class)
	    YAML.load(obj) if obj
	  end
	end
end