require 'spec_helper'

describe Defaultable::Settings do
  before :each do
    Defaultable::Settings.set_defaults({})
  end

  it "should initialize with a hash." do
    setting = Defaultable::Settings.new({:child => 'Bobert'})
    setting.child.should eq('Bobert')
  end

  it "should be able to set nonexsistent keys." do
    setting = Defaultable::Settings.new
    setting.child = 'Bri Bri'
    setting.child.should eq('Bri Bri')
  end

  it "should be able to set nonexsistent keys to another setting." do
    setting = Defaultable::Settings.new
    setting.child = Defaultable::Settings.new
    setting.child.name = 'Mocha'
    setting.child.name.should eq('Mocha')
  end

  it "should accept nested hashes." do
    setting = Defaultable::Settings.new({:parent => {:child => 'Rob'}})
    setting.parent.child.should eq('Rob')
  end

  it "should have a question mark method for keys." do
    setting = Defaultable::Settings.new(:foo => 'bar')
    setting.foo?.should be_true
  end

  it ".empty? should return true" do
    setting = Defaultable::Settings.new
    setting.should be_empty
  end

  it '.delete should return the value and delete it from the settings' do
    setting = Defaultable::Settings.new
    setting.foo = 'bar'
    setting.delete(:foo).should eq 'bar'
    setting.foo.should be_nil
  end

  it ".empty? should return false" do
    setting = Defaultable::Settings.new(:foo => 'bar')
    setting.should_not be_empty
  end

  describe "Defaults." do
    it "should have default settings." do
      Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'
      Defaultable::Settings.defaults.should be_kind_of(Hash)
    end

    it "should have a default setting for a key." do
      Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

      setting = Defaultable::Settings.new
      setting.grandparent.should be_kind_of Defaultable::Settings
    end

    it "should have another key for another setting." do
      Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/test.yml'

      setting = Defaultable::Settings.new
      setting.grandparent.child.grandchild1.should eq('robert')
    end

    it "should set a key but still have defaults." do
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

    it "should be able to overwrite a default." do
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

    it "should be able to set a key in the middle of defaults." do
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

    it "should be able to set a hash for defaults." do
      Defaultable::Settings.set_defaults :child => 'sxephil'

      setting = Defaultable::Settings.new
      setting.child.should eq('sxephil')
    end

    it "should accept a filename with an environment." do
      Defaultable::Settings.set_defaults File.expand_path('../', __FILE__) + '/env_test.yml', 'development'

      setting = Defaultable::Settings.new
      setting.setting_key.should eq('somevalue')
    end
  end

  describe "Extendable." do
    it "should be extendable." do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => 'Iron Man'
      end

      setting = DummySetting.new
      setting.movie.should eq('Iron Man')
    end

    it "should return settings the same class of the extension for detauls." do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => 'Iron Man'
      end

      DummySetting.defaults.should be_a Hash
    end
  end

  describe "Hashes." do
    it ".as_hash should return a hash." do
      Defaultable::Settings.set_defaults :child => 'sxephil'
      setting = Defaultable::Settings.new

      setting.name = 'Robert'
      setting.as_hash.should be_kind_of Hash
    end

    it ".as_hash should return a hash with the correct keys." do
      Defaultable::Settings.set_defaults :child => 'sxephil'
      setting = Defaultable::Settings.new

      setting.name = 'Robert'
      setting.as_hash['name'].should eq('Robert')
    end
  end

  describe "Defaults." do
    before(:each) do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => {:name => 'Iron Man' }
      end
    end

    it "should have a key from defaults on initialization." do
      setting = DummySetting.new
      setting.movie?.should be_true
    end

    it "should have a hash with a length from defaults on initialization." do
      setting = DummySetting.new
      setting.as_hash.length.should eq(1)
    end

    it "should mash defaults together with new settings." do
      setting = DummySetting.new(:movie => { :genre => 'asdf' })
    end
  end

  describe Defaultable::Registry do
    before(:each) do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => {:name => 'Iron Man' }
      end
    end

    it "should not include defaults in the registry." do
      setting = DummySetting.new
      setting.registry.as_hash.has_key?(:movie).should be_false
    end

    it "should not include defaults in the registry unless overwritten." do
      setting = DummySetting.new
      setting.movie = 'asdf'
      setting.registry.as_hash.has_key?(:movie).should be_false
    end

    it "should be able to overwrite nested defaults." do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => {:name => 'Iron Man', :genre => 'Action Adventure'}
      end
      setting = DummySetting.new
      setting.movie.genre = 'Unable to put into mongodb gridfs'

      setting.registry.as_hash['movie'].has_key?('genre').should be_true
      setting.registry.as_hash['movie'].has_key?('name').should be_false
    end

    it "should be able to overwrite multiple nested defaults." do
      class DummySetting < Defaultable::Settings
        set_defaults :movie => {:name => 'Iron Man', :genre => 'Action Adventure'}
      end
      setting = DummySetting.new
      setting.movie.genre = 'Unable to put into mongodb gridfs'
      setting.movie.name = 'Independence Day'

      setting.registry.as_hash['movie'].has_key?('genre').should be_true
      setting.registry.as_hash['movie'].has_key?('name').should be_true
    end
  end
end