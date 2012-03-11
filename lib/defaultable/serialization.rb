# Include this module to support ActiveRecord serialization

module Defaultable
	module Serialization
	  # Called to deserialize data to ruby object.
	  extend ActiveSupport::Concern

	  module ClassMethods
		  def load(data)
		  	overrides = {}

		  	if data
		    	obj = raw_load(data)
		    	raise TypeError, "Deserialized object is not of type #{self.name}. Got #{obj.class}" unless obj.kind_of?(self)
		    	overrides = obj.as_hash
		    end

	    	self.new(overrides)
		  end

		  # Called to convert from ruby object to serialized data.
		  def dump(obj)
		  	raise TypeError, "Serialization failed: Object is not of type #{self.name}." if !obj.kind_of?(self) && !obj.nil?

		  	if obj.nil?
		  		self.new
		    else
		    	obj.class.new(obj.registry.as_hash).to_yaml if obj
			  end
		  end

		  def raw_load(data)
		  	YAML.load(data)
		  end
		end
	end
end