module Defaultable
	class Serialization
		cattr_accessor :settings_class

	  # Called to deserialize data to ruby object.
	  def load(data)
	  	overrides = {}

	  	if data
	    	obj = raw_load(data)
	    	raise TypeError, "Deserialized object is not of type #{self.class.settings_class.name}. Got #{obj.class}" unless obj.is_a?(self.class.settings_class)
	    	overrides = obj.as_hash
	    end

    	self.settings_class.new(overrides)
	  end

	  # Called to convert from ruby object to serialized data.
	  def dump(obj)
	  	raise TypeError, "Serialization failed: Object is not of type #{self.class.settings_class.name}." if !obj.is_a?(self.class.settings_class) && !obj.nil?

	  	if obj.nil?
	  		self.class.settings_class.new
	    else
	    	obj.class.new(obj.registry.as_hash).to_yaml if obj
		  end
	  end

	  def raw_load(data)
	  	YAML.load(data)
	  end
	end
end