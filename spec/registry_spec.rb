require 'spec_helper'

describe Defaultable::Registry do
	before(:each) do
		class DummySetting < Defaultable::Settings; end
	end

	after(:each) do
		DummySetting.set_defaults Hash.new
	end

	it "should log settings to the registry" do
		setting = DummySetting.new
		setting.blah = 'asdf'

		setting.registry.as_hash.should have_key('blah')
	end

	it "should not log defaults to the registry" do
		DummySetting.set_defaults :foo => 'bar'

		setting = DummySetting.new
		setting.registry.as_hash.should_not have_key('foo')
	end

	it "should set registry values for nested attributes" do
		setting = DummySetting.new(:stuff => {:bar => 'foo'})
		setting.registry.as_hash['stuff'].should have_key('bar')
	end

	it "should not set nested attributes registry values even in nested defaults" do
		DummySetting.set_defaults :values => {:foo => 'bar'}

		DummySetting.new.registry.as_hash.should_not have_key('values')
	end

	it "should set nested attributes registry values even in nested defaults" do
		DummySetting.set_defaults :values => {:foo => 'bar'}

		setting = DummySetting.new(:values => {:bar => 'foo'})
		setting.registry.as_hash.should have_key('values')
		setting.values.bar?.should be_true
	end

	it "should set nested attributes registry values and retain nested defaults" do
		DummySetting.set_defaults :values => {:foo => 'bar'}

		setting = DummySetting.new(:values => {:bar => 'foo'})
		setting.registry.as_hash.should have_key('values')
		setting.values.bar?.should be_true
		setting.values.foo?.should be_true
	end
end