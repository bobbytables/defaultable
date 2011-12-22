require 'spec_helper'

describe Defaultable::Serialization do
	before(:each) do
		class DummySetting < Defaultable::Settings; end
		Defaultable::Serialization.settings_class = DummySetting
	end

	after(:each) do
		DummySetting.set_defaults Hash.new
	end

	it "should set a class for settings" do
		Defaultable::Serialization.settings_class.should eq(DummySetting)
	end

	it "should serialize a settings object" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = encoder.dump(settings)
		serialized.should be_a String
	end

	it "should deserialize a settings object back to a kind of Defaultable::Settings" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = encoder.dump(settings)

		encoder.load(serialized).should be_kind_of Defaultable::Settings
	end

	it "should throw an exception when the class doesn't match the settings class on load" do
		encoder = Defaultable::Serialization.new

		lambda { encoder.load('adfghjsfjdhg') }.should raise_error TypeError
	end

	it "should throw an exception when the class doesn't match the settings class on dump" do
		encoder = Defaultable::Serialization.new

		lambda { encoder.dump('adfghjsfjdhg'.to_yaml) }.should raise_error TypeError
	end

	it "should load with keys still in tact" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized   = encoder.dump(settings)
		unserialized = encoder.load(serialized)

		unserialized.foo.should eq('bar')
	end

	it "should load defaults in after the fact" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = encoder.dump(settings)

		DummySetting.set_defaults :bobby => 'tables'

		unserialized = encoder.load(serialized)
		unserialized.bobby?.should be_true
	end

	it "should not serialize defaults that didn't get overwritten" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = encoder.dump(settings)

		DummySetting.set_defaults :bobby => 'tables'

		unserialized = encoder.raw_load(serialized)
		unserialized.bobby?.should be_false
	end

	it "should not serialize nested defaults that didn't get overwritten" do
		encoder  = Defaultable::Serialization.new
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = encoder.dump(settings)

		DummySetting.set_defaults :bobby => {:effing => 'tables'}

		unserialized = encoder.raw_load(serialized)
		unserialized.bobby?.should be_false
	end

	it "should not serialize nested defaults that didn't get overwritten (but other values did)" do
		encoder  = Defaultable::Serialization.new
		DummySetting.set_defaults :bobby => {:effing => 'tables'}
		settings = DummySetting.new

		settings.bobby = 'tables'
		serialized = encoder.dump(settings)

		unserialized = encoder.raw_load(serialized)
		unserialized.bobby?.should be_true
	end
end