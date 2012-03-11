# Defaultable
#### Defaultable allows you to create settings with defaults easily

```
setting = Defaultable::Settings.new
setting.site_name = 'Example'
setting.site_name # => Example
```

## Creating your own defaultable settings class

To create a settings class, just extend Defaultable::Settings

```
class MySetting < Defaultable::Settings
	set_defaults :site_name => 'Example'
end

setting = MySetting.new
setting.site_name # => Example

setting.site_name = 'Different Name'
setting.site_name # => Different Name
```

## Creating your own defaultable settings from a YAML file

```
class MySetting < Defaultable::Settings
	set_defaults "#{Rails.root}/config/settings.yml"
end

class MySetting < Defaultable::Settings
	set_defaults "#{Rails.root}/config/settings.yml", Rails.env
end

```

The second parameter of ```set_defaults``` is the environment variable you'd like to use from the file. For example "development".


## Serialization

Sometimes we want to store settings for a database record in the actual schema. To do that, use the ```Defaultable::Serialization``` class.
We'll use ```ActiveRecord::Base#serialize``` method in this example.

First create a model for your settings by extending ```Defaultable::Settings```.

```
class UserSetting < Defaultable::Settings
  include Defaultable::Serialization
end
```

Now on your User model, setup the settings class on it.

```
class User < ActiveRecord::Base
	serialize :settings, UserSetting
end
```

#### What we just accomplished

Now we have the ability to setup user settings on creation and updating.

```
user = User.new
user.settings.newsletter = true
user.save


User.find(1).settings.newsletter # => true
```

Defaultable won't store settings that are defaults until overridden but you may use them otherwise. Meaning that it'll retain defaults on save.

## Other methods you may find useful

Defaultable has some other methods you may want to use:

Defaultable::Settings#as_hash
```
irb(main):007:0> a.settings.as_hash
=> {"blah"=>"stuff", "foo"=>{"bar"=>"foo"}}
```

It returns a recursive hash of settings. It works on all levels however, such as ```a.settings.foo.as_hash```

Defaultable::Settings#recursive_hash_assignment
```
irb(main):009:0> settings.recursive_hash_assignment :foo => {:bar => {:foo => 'bar'}}
=> {:foo=>{:bar=>{:foo=>"bar"}}}

irb(main):011:0> settings.foo.bar.foo
=> "bar"
```

And a few others, sorry for the lack of RDoc =(