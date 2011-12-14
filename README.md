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

The second parameter of ```set_defaults``` is the environment variable you'd like to use from the file.