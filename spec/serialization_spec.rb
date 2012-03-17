require 'spec_helper'

describe Defaultable::Serialization do
	before(:each) do
		class DummySetting < Defaultable::Settings
			include Defaultable::Serialization
		end
	end

	after(:each) do
		DummySetting.set_defaults Hash.new
	end


	it "should serialize a settings object." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = DummySetting.dump(settings)
		serialized.should be_a String
	end

	it "should deserialize a settings object back to a kind of Defaultable::Settings." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = DummySetting.dump(settings)

		DummySetting.load(serialized).should be_kind_of Defaultable::Settings
	end

	it "should throw an exception when the class doesn't match the settings class on load." do
		lambda { DummySetting.load('adfghjsfjdhg') }.should raise_error TypeError
	end

	it "should throw an exception when the class doesn't match the settings class on dump." do
		lambda { DummySetting.dump('adfghjsfjdhg'.to_yaml) }.should raise_error TypeError
	end

	it "should load with keys still in tact." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized   = DummySetting.dump(settings)
		unserialized = DummySetting.load(serialized)

		unserialized.foo.should eq('bar')
	end

	it "should load defaults in after the fact." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = DummySetting.dump(settings)

		DummySetting.set_defaults :bobby => 'tables'

		unserialized = DummySetting.load(serialized)
		unserialized.bobby?.should be_true
	end

	it "should not serialize defaults that didn't get overwritten." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = DummySetting.dump(settings)

		DummySetting.set_defaults :bobby => 'tables'

		unserialized = DummySetting.raw_load(serialized)
		unserialized.bobby?.should be_false
	end

	it "should not serialize nested defaults that didn't get overwritten." do
		settings = DummySetting.new

		settings.foo = 'bar'
		serialized = DummySetting.dump(settings)

		DummySetting.set_defaults :bobby => {:effing => 'tables'}

		unserialized = DummySetting.raw_load(serialized)
		unserialized.bobby?.should be_false
	end

	it "should not serialize nested defaults that didn't get overwritten (but other values did)." do
		DummySetting.set_defaults :bobby => {:effing => 'tables'}
		settings = DummySetting.new

		settings.bobby = 'tables'
		serialized = DummySetting.dump(settings)

		unserialized = DummySetting.raw_load(serialized)
		unserialized.bobby?.should be_true
		unserialized.bobby.should eq('tables')
	end

	it "should serialize really nested defaults that were overwritten." do
		DummySetting.set_defaults :bobby => {:effing => {:stillgoing => 'tables'}}
		settings = DummySetting.new

		settings.bobby.effing.stillgoing = 'ross'
		serialized = DummySetting.dump(settings)

		unserialized = DummySetting.raw_load(serialized)
		unserialized.bobby.effing.stillgoing?.should be_true
		unserialized.bobby.effing.stillgoing.should eq('ross')
	end
end