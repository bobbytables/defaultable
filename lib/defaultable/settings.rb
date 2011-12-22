module Defaultable
	class Settings
    class_attribute :defaults
    attr_accessor :registry_enabled
    attr_reader   :registry

    attr_accessor :parent, :root_key

    def initialize(hash=nil, skip_defaults=false, enable_registry=true)
      @table    = {}
      @registry = Registry.new

      if !skip_defaults && !self.class.defaults.nil?
      	self.registry_enabled = false
        recursive_hash_assignment self.class.defaults
      end

      # Enable the registry so we know what actually was set beyond defaults
      self.registry_enabled = enable_registry
      
      if !hash.nil? && hash.kind_of?(Hash)
        recursive_hash_assignment hash
      end
    end
    
    def method_missing(message, *args, &block)
      # puts "Message: #{message}", "Args: #{args}", "\n"

      if !(message.to_s =~ /^(.*)=$/) && @table.has_key?(message.to_s)
        @table[message.to_s]
      elsif message.to_s =~ /^(.*)\?$/
        @table.has_key?(message.to_s.gsub(/\?$/, ''))
      elsif message.to_s =~ /^(.*)=$/
        key = message.to_s.gsub(/=$/, '')
        value = args.first

        if self.registry_enabled
        	self.registry.add(key, value)
        end

        if value.kind_of?(Defaultable::Settings)
        	value.root_key = key
        	value.parent   = self
        end

        if self.parent && self.parent.registry_enabled
        	self.registry.add(key, value)
        	self.parent.registry.add(self.root_key, self.class.new(self.registry.as_hash))
        end

        @table[key] = value
      end
    end
    
    def as_hash
      @table.inject({}) do |hash, (key, val)|
        if val.kind_of?(Defaultable::Settings)
          val = val.as_hash
        else
          val
        end

        hash[key] = val
        hash
      end
    end

    def recursive_hash_assignment(hash)
      hash.each do |key, value|
        if value.kind_of?(Hash)
          key_aware_assignment(key, value)
        else
          self.send("#{key}=", value)
        end
      end
    end

    def key_aware_assignment(key, hash)
      if self.send("#{key}?")
        instance = self.send(key)

        if instance.kind_of?(Defaultable::Settings)
          instance.recursive_hash_assignment(hash)
          self.send("#{key}=", instance)
        else
          self.send("#{key}=", hash)
        end
      else
        self.send("#{key}=", self.class.new(hash, true, self.registry_enabled))
      end
    end
    
    class << self
      def set_defaults(settings, env=nil)
        case settings
        when Hash
          self.defaults = settings
        when String
          yaml = YAML.load_file(settings)
          yaml = yaml[env] if env
          self.defaults = yaml
        else
          raise ArgumentError, "You must supply a hash or a file name for default settings"
        end
      end
    end
  end
end