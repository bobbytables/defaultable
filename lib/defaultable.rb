require "defaultable/version"
require 'ostruct'
require 'yaml'
require 'active_support/core_ext/class/attribute'

require 'pry'

module Defaultable
	class Setting
		class_attribute :defaults_file
		class_attribute :defaults_hash
		defaults_hash = {}

		attr_accessor :root_key, :parent

	  def initialize(hash=nil, root_key=nil, parent=nil)
	    @table = {}

	    if root_key
	    	self.root_key = root_key
	    end

	    if parent
	    	self.parent = parent
	    end
	    
	    if !hash.nil? && hash.kind_of?(Hash)
		    hash.each do |key, value|
		      if value.kind_of?(Hash)
		        send("#{key}=", Defaultable::Setting.new(value, key, self))
		      else
		        self.send("#{key}=", value)
		      end
		    end
		  end
	  end
	  
	  def method_missing(message, *args, &block)
	  	# puts "Message: #{message}", "Args: #{args}", "\n"

	  	if !(message.to_s =~ /^(.*)=$/) && @table.has_key?(message.to_s)
	  		@table[message.to_s]
	  	elsif message.to_s =~ /^(.*)=$/
	  		@table[message.to_s.gsub(/=$/, '')] = args.first
	  	elsif !(message.to_s =~ /^(.*)=$/)
	  		# We're looking for a default
	  		default_settings = self.class.defaults

	  		# If we have a parent, we need to traverse to the top of all of the method calls (root_keys), then go back down them
	  		if self.parent
	  			root_keys = []
	  			current_parent = self
	  			while current_parent.has_parent? do
	  				root_keys << current_parent.root_key
	  				current_parent = current_parent.parent
	  			end

	  			root_keys.reverse.each do |key|
	  				default_settings = default_settings.send(key)
	  			end

	  			return default_settings.send(message)
	  		# If don't have a parent, just send the message to the defaults outright 
	  		else
	  			default_settings.send(message)
	  		end
	  	end
	  end
	  
	  def as_hash
	    @table
	  end

	  def has_parent?
	  	!!self.parent
	  end
	  
	  class << self
	    def defaults
	    	if self.defaults_file
	      	settings = YAML.load_file(defaults_file)
	      	return Defaultable::Setting.new(settings)
	      elsif !self.defaults_hash.empty? && self.defaults_hash.kind_of?(Hash)
	      	return Defaultable::Setting.new(self.defaults_hash)
	      end
	    end
	  end
	end
end