require 'spec_helper'

describe Defaultable::Setting do
	it "should not have a parent" do
		setting = Defaultable::Setting.new
		setting.has_parent?.should be_false
	end

	it "should initialize with a hash" do
		setting = Defaultable::Setting.new({:child => 'Bobert'})
		setting.child.should eq('Bobert')
	end

	it "should be able to set nonexsistent keys" do
		setting = Defaultable::Setting.new
		setting.child = 'Bri Bri'
		setting.child.should eq('Bri Bri')
	end

	it "should be able to set nonexsistent keys to another setting" do
		setting = Defaultable::Setting.new
		setting.child = Defaultable::Setting.new
		setting.child.name = 'Mocha'
		setting.child.name.should eq('Mocha')
	end

	it "should accept nested hashes" do
		setting = Defaultable::Setting.new({:parent => {:child => 'Rob'}})
		setting.parent.child.should eq('Rob')
	end

	it "should have default settings" do
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'
		Defaultable::Setting.defaults.should be_kind_of(Defaultable::Setting)
	end

	it "should have a default setting for a key" do
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Setting.new
		setting.grandparent.should be_kind_of Defaultable::Setting
	end

	it "should have another key for another setting" do
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Setting.new
		setting.grandparent.child.grandchild1.should eq('robert')
	end

	it "should set a key but still have defaults" do
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Setting.new({
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
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Setting.new({
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
		Defaultable::Setting.defaults_file = File.expand_path('../', __FILE__) + '/test.yml'

		setting = Defaultable::Setting.new({
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
end