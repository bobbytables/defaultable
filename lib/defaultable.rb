require "defaultable/version"
require 'yaml'
require 'active_support/core_ext/class/attribute'
require 'active_support/concern'

module Defaultable
  autoload :Serialization, 'defaultable/serialization'
  autoload :Settings, 'defaultable/settings'
  autoload :Registry, 'defaultable/registry'
end