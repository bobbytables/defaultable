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
end
```

Second, create an initializer. We need this to setup the serialization class for ActiveRecord.

```
Defaultable::Serialization.settings_class = UserSetting
```

Now on your User model, setup the serialization class on it.

```
class User < ActiveRecord::Base
	serialize :settings, Defaultable::Serialization
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






