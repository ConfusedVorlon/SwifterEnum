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

### Overview


SwifterEnums act like a normal Rails enum - except that instead of returning symbol values, they return an instance of your selected class

We have a Video ActiveModel with an enum defined by

    class Video < ApplicationRecord
      swifter_enum :camera, CameraEnum
    end

CameraEnum is a class like the following

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

This provides a richer approach to enums:

    v = Video.first
    v.camera => #<CameraEnum:0x0000000134c7c290 @value=:handcam> 
    v.camera.value => :handcam 

    #you can set values directly
    v.camera = :videographer
    v.camera => #<CameraEnum:0x000000013385f078 @value=:videographer> 

    #the purpose of this gem is that you can now define and access methods on the CameraEnum
    v.camera.icon => "icons/video-camera" 


### Using Enums in ActiveRecord Models

To use an enum in an ActiveRecord model, use the `swifter_enum` class method provided by the gem in exactly the same way that you would normally use `enum`

Example:

    class Video < ApplicationRecord
      swifter_enum :camera, CameraEnum

      #optional validation
      validates :camera, swifter_enum: true
    end

Models are by convention stored in `/models/swifter_enum/your_model_enum.rb`


### Enum Class 

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

The only requirements for your enum class are

* Inherit from SwifterEnum::Base
* Define self.values which returns a hash of `{symbol: Integer}`

You can then add whatever methods are useful to you.

### Migrating an existing enum

let's say you have an existing enum

    enum :album_status, {
      waiting_for_footage: 0,
      waiting_for_upload: 10,
      uploading: 20,
      processing_preview: 24,
      delivered_preview: 26,
      processing_paid: 30,
      delivered_paid: 50,
      processing_failed: 60
    }, prefix: true

run the generator to create an appropriate enum class

`rails g swifter_enum:enum AlbumStatus`

Insert the values of your enum into `models/swifter_enum_album_status_enum.rb`

    class AlbumStatusEnum < SwifterEnum::Base
      def self.values
        {
          waiting_for_footage: 0,
          waiting_for_upload: 10,
          uploading: 20,
          processing_preview: 24,
          delivered_preview: 26,
          processing_paid: 30,
          delivered_paid: 50,
          processing_failed: 60
        }.freeze
      end
    end

Now replace the definition in your model file with

    swifter_enum :album_status, AlbumStatusEnum, prefix: true

Optionally, add

    validates :album_status, swifter_enum: true

Run your tests and fix any issues. For me, the most common issue is where I was previously using `album_status.to_sym`. 

Now I can use `album_status.value` to get a symbol value, 

    album_status.value => :uploading

or if I'm doing a comparison - I can just use `album_status`.

    if album_status == :uploading {} #works as expected


Now I'm ready to use my enum class by defining new methods.

For example

    class AlbumStatusEnum < SwifterEnum::Base

      #values set as above

      def delivered?
        [:delivered_paid, :delivered_preview].include? self.value
      end

    end

which allows me to use `model.album_status.delivered?`


### Generator Usage

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

### Translation and Display

SwifterEnum supports i18n out of the box. Define translations in your locale files, and use the `.t` method on your enum instances to get the translated string.

Locale file example (`config/locales/en.yml`):

    en:
      swifter_enum:
        enums:
          camera_enum:
            videographer: "Videographer"
            handcam: "Handheld Camera"

    #example usage
    v.camera.t => "Videographer"

### Raw Value Escape Hatch

SwifterEnum is built on top of the normal Rails enum functionality.

If you're using a framework that needs to access this (Like Administrate), then you can use the `[name]_raw` method

This also provides the keys method for select forms, so form builders should work (though the label will be `[name]_raw` rather than `[name]`)

So, if you define Video.camera as a CameraEnum, then Video.camera_raw returns the standard Rails enum which lies beneath.

Example:

    v.camera  => #<CameraEnum:0x000000013385f078 @value=:videographer> 

    # Accessing the raw value
    v.camera_raw  => "videographer" 

    # Setting the raw value
    v.camera_raw = "handcam" #or =:handcam
    v.camera =  => #<CameraEnum:0x000000016f7223e0 @value=:handcam> 

    v.camera_raw = 0
    v.camera =  => #<CameraEnum:0x000000016f7223e0 @value=:videographer> 

    # Getting the mapping
    Video.camera_raws # => { videographer: 0, handcam: 1 }

## Contributing

Bug reports and pull requests are welcome
