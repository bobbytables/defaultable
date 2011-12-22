require "defaultable/version"
require 'yaml'
require 'active_support/core_ext/class/attribute'

module Defaultable
  autoload :Serialization, 'defaultable/serialization'
  autoload :Settings, 'defaultable/settings'
  autoload :Registry, 'defaultable/registry'
end