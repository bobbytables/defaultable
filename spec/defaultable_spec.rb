require 'spec_helper'

describe Defaultable::Settings do
	before :each do
		Defaultable::Settings.set_defaults({})
	end

	it "should not have a parent" do
		setting = Defaultable::Settings.new
		setting.has_parent?.should be_false
	end

	it "should initialize with a hash" do
		setting = Defaultable::Settings.new({:child => 'Bobert'})
		setting.child.should eq('Bobert')
	end

	it "should be able to set nonexsistent keys" do
		setting = Defaultable::Settings.new
		setting.child = 'Bri Bri'
		setting.child.should eq('Bri Bri')
	end

	it "should be able to set nonexsistent keys to another setting" do
		setting = Defaultable::Settings.new
		setting.child = Defaultable::Settings.new
		setting.child.name = 'Mocha'
		setting.child.name.should eq('Mocha')
	end

	it "should accept nested hashes" do
		setting = Defaultable::Settings.new({:parent => {:child => 'Rob'}})
		setting.parent.child.should eq('Rob')
	end

	it "should have default settings" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'
		Defaultable::Settings.defaults.should be_kind_of(Defaultable::Settings)
	end

	it "should have a default setting for a key" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Settings.new
		setting.grandparent.should be_kind_of Defaultable::Settings
	end

	it "should have another key for another setting" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Settings.new
		setting.grandparent.child.grandchild1.should eq('robert')
	end

	it "should set a key but still have defaults" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Settings.new({
			:grandparent => {
				:child => {
					:grandchild3 => 'hurdur'
				}
			}
		})

		setting.grandparent.child.grandchild3.should eq('hurdur')
		setting.grandparent.child.grandchild2.should eq('brian')
	end

	it "should be able to overwrite a default" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Settings.new({
			:grandparent => {
				:child => {
					:grandchild3 => 'hurdur'
				}
			}
		})

		setting.grandparent.child.grandchild3.should eq('hurdur')
		setting.grandparent.child.grandchild2 = 'drpepper'
		setting.grandparent.child.grandchild2.should eq('drpepper')
	end

	it "should be able to set a key in the middle of defaults" do
		Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Settings.new({
			:grandparent => {
				:child => {
					:grandchild3 => 'hurdur'
				}
			}
		})

		setting.grandparent.child.grandchild3.should eq('hurdur')
		setting.grandparent.someotherkey = 'saweet'
		setting.grandparent.someotherkey.should eq('saweet')
	end

	it "should be able to set a hash for defaults" do
		Defaultable::Settings.set_defaults :child => 'sxephil'

		setting = Defaultable::Settings.new
		setting.child.should eq('sxephil')
	end

	it "should be extendable" do
		class DummySetting < Defaultable::Settings
			set_defaults :movie => 'Iron Man'
		end

		setting = DummySetting.new
		setting.movie.should eq('Iron Man')
	end
end