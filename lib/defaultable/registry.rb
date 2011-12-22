require 'active_support/core_ext/hash'

module Defaultable
	class Registry
		def initialize
			@table = {}
		end

		def add(key, value)
			@table[key] = value
		end

		def as_hash
			@table.inject({}) do |hash, (key, val)|
        if val.kind_of?(Defaultable::Settings)
          val = val.registry.as_hash
        else
          val
        end

        hash[key] = val
        hash
      end
		end

		# def diff(defaults)
		# 	settings = self.as_hash

		# 	settings.diff(defaults)
		# end
	end
end