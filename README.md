# SwifterEnum

SwifterEnum is a Ruby gem for creating enumerated types (enums) in Ruby on Rails applications. 
It is inspired by Swift's enums, and allows for more expressive and feature-rich enums in your models.

Rather than simply having a key/value, enums are Classes, and can have defined methods.

so - after defining

    class Video < ApplicationRecord
      swifter_enum :camera, CameraEnum
    end

you can then define and access methods on your enum like

`video.camera.icon`
or `video.camera.default_exposure`


## Installation

Add this line to your application's Gemfile:

    gem 'swifter_enum'

And then execute:

    bundle install

## Usage

### Basic Enum Creation

To create a new enum, subclass `SwifterEnum::Base` and define a `values` class method returning a hash where the keys are symbolic names and the values are integers.

Example:

    class CameraEnum < SwifterEnum::Base
      def self.values
        { videographer: 0, handcam: 1 }.freeze
      end

      def icon
        case @value
        when :videographer
          "icons/video-camera"
        when :handcam
          "icons/hand-stop"
        end
      end
    end

### Using Enums in ActiveRecord Models

To use an enum in an ActiveRecord model, use the `swifter_enum` class method provided by the gem.

Example:

    class Video < ApplicationRecord
      swifter_enum :camera, CameraEnum
    end

Models are by convention stored in /models/swifter_enum/your_model_enum.rb

### Translation and Display

SwifterEnum supports i18n out of the box. Define translations in your locale files, and use the `.t` method on your enum instances to get the translated string.

Locale file example (`config/locales/en.yml`):

    en:
      swifter_enum:
        enums:
          camera_enum:
            videographer: "Videographer"
            handcam: "Handheld Camera"

## Generator Usage

SwifterEnum provides a Rails generator to easily create new enum classes. To generate an enum, use the following command:

    rails g swifter_enum:enum [EnumName]

Replace `[EnumName]` with the desired name for your enum. This will create a new enum file in the `app/models` directory.

For example, to create a `CameraEnum`, run:

    rails g swifter_enum:enum Camera

This command will generate a file `app/models/swifter_enum/camera_enum.rb` with the following structure:

    class CameraEnum < SwifterEnum::Base
      def self.values
        # Insert your values here. e.g. { foo: 1, bar: 2 }.freeze
        { }.freeze
      end
    end

After generating your enum, you can add your specific enum values and use it in your ActiveRecord models.


### Raw Value Escape Hatch

This is useful for cases like an administrate dashboard. Simply use the [name]_raw method
This also provides the keys method for select forms, so form builders should work (though the label will be incorrect)

SwifterEnum provides a `_raw` escape hatch for cases where you need to work with the underlying integer values directly, such as when using the Administrate gem.

Example:

    # Accessing the raw value
    camera.kind_raw # => 0 or 1

    # Setting the raw value
    camera.kind_raw = 1

    # Getting the mapping
    Camera.kind_raws # => { videographer: 0, handcam: 1 }

## Contributing

Bug reports and pull requests are welcome
