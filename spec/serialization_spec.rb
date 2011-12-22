require 'spec_helper'

describe Defaultable::Serialization do
	before(:each) do
		class DummySetting < Defaultable::Settings; end
	end

	it "should set a class for settings" do
		Defaultable::Serialization.settings_class = DummySetting
		Defaultable::Serialization.settings_class.should eq(DummySetting)
	end
end