# SwifterEnum

SwifterEnum brings Swift-style enums to Ruby on Rails, allowing you to encapsulate behavior within your enum types rather than scattering it throughout your application.

## Why SwifterEnum?

In Swift, enums are first-class types that can have methods, computed properties, and associated values. SwifterEnum brings this powerful pattern to Rails by replacing simple string/integer enums with proper objects that can carry their own behavior.

### Key Benefits

**1. Encapsulated Behavior** - Your enum knows how to handle itself:

```ruby
# In your model - looks just like a regular Rails enum. No change needed to the db column.
class Order < ApplicationRecord
  swifter_enum :payment_status, PaymentStatusEnum
end

# Define your enum with its behavior
class PaymentStatusEnum < SwifterEnum::Base
  set_values ({
    pending: 0,
    processing: 10,
    completed: 20,
    failed: 30,
    refunded: 40
  })

  def completed?
    [:completed, :refunded].include?(value)
  end

  def can_refund?
    value == :completed
  end

  def icon
    case value
    when :pending then "clock"
    when :processing then "spinner"
    when :completed then "check-circle"
    when :failed then "x-circle"
    when :refunded then "rotate-left"
    end
  end

  def color
    case value
    when :pending then "gray"
    when :processing then "blue"
    when :completed then "green"
    when :failed then "red"
    when :refunded then "orange"
    end
  end
end

# Use it naturally - the enum is part of your model
order = Order.find(1)
order.payment_status.completed?       # => true
order.payment_status.can_refund?      # => true
order.payment_status.icon             # => "check-circle"
order.payment_status.color            # => "green"
```

**2. Type Safety** - Catch invalid values at runtime:

```ruby
# Safe access with bracket notation - raises error for invalid values
status = PaymentStatusEnum[:completed]  # ✓ Returns enum instance
status = PaymentStatusEnum[:invalid]    # ✗ Raises ArgumentError

# Validation in models
class Order < ApplicationRecord
  swifter_enum :payment_status, PaymentStatusEnum
  validates :payment_status, swifter_enum: true
end
```

**3. Smart Enum Objects with Flexible Equality** - Returns enum instances that work naturally with symbols and strings:

```ruby
order.payment_status  # => #<PaymentStatusEnum @value=:completed>

# Flexible equality checking - all of these work:
order.payment_status == :completed           # => true (symbol comparison)
order.payment_status == "completed"          # => true (string comparison)
order.payment_status == other.payment_status # => true (enum instance comparison)

# Use in case statements naturally
case order.payment_status
when :pending    then "Waiting for payment"
when :completed  then "All done!"
when :failed     then "Something went wrong"
end

# Or in arrays
[:completed, :refunded].include?(order.payment_status)  # => true
```

**4. Seamless Rails Integration** - All standard Rails enum features continue to work:

```ruby
# Familiar Rails enum syntax
class Order < ApplicationRecord
  swifter_enum :payment_status, PaymentStatusEnum
  swifter_enum :priority, PriorityEnum
end

# Standard Rails enum features work unchanged:
order.payment_status = :processing        # Set with symbol, string, or enum instance
order.payment_status = "processing"       # String works too
order.payment_status = PaymentStatusEnum[:processing]  # Or enum instance
order.completed!                          # Bang method sets and saves
order.completed?                          # => true (query method)
order.not_completed?                      # => false (negative query)

Order.completed                           # Scope returning all completed orders
Order.not_completed                       # Scope returning all non-completed orders
```

**5. Progressive Migration** - Adopt incrementally without breaking existing code:

```ruby
order.payment_status      # => #<PaymentStatusEnum @value=:completed>

# Both setters work
order.payment_status = :pending           # Symbol
order.payment_status = PaymentStatusEnum[:pending]  # Enum instance

# Raw methods provide an 'escape hatch' to standard Rails enum handling
order.payment_status_raw  # => "completed" (original Rails enum value)
Order.payment_status_raws  # => {"pending"=>0, "processing"=>10, ...}
```

## Real-World Example

Consider a subscription system where enum behavior naturally belongs with the enum itself:

```ruby
class SubscriptionTierEnum < SwifterEnum::Base
  set_values ({
    free: 0,
    basic: 10,
    pro: 20,
    enterprise: 30
  })

  def price
    case value
    when :free then 0
    when :basic then 9.99
    when :pro then 29.99
    when :enterprise then 99.99
    end
  end

  def features
    case value
    when :free then ["5 projects", "Basic support"]
    when :basic then ["20 projects", "Email support", "API access"]
    when :pro then ["Unlimited projects", "Priority support", "Advanced API"]
    when :enterprise then ["Everything in Pro", "SSO", "Dedicated support", "SLA"]
    end
  end

  def can_upgrade_to?(other_tier)
    return false unless other_tier.is_a?(self.class)
    self.class.values[other_tier.value] > self.class.values[value]
  end

  def badge_color
    case value
    when :free then "gray"
    when :basic then "blue"
    when :pro then "purple"
    when :enterprise then "gold"
    end
  end
end

# Clean, expressive code in your views and controllers
current_user.subscription_tier.price           # => 29.99
current_user.subscription_tier.features        # => ["Unlimited projects", ...]
current_user.subscription_tier.can_upgrade_to?(SubscriptionTierEnum[:enterprise])  # => true

# In your views
<span class="badge badge-<%= current_user.subscription_tier.badge_color %>">
  <%= current_user.subscription_tier.t %>
</span>
<ul>
  <% current_user.subscription_tier.features.each do |feature| %>
    <li><%= feature %></li>
  <% end %>
</ul>
```

This approach eliminates helper methods, reduces case statements scattered across your codebase, and keeps related logic together where it belongs.


## Installation

Add this line to your application's Gemfile:

    gem 'swifter_enum'

## Usage

### Basic Setup

Define your enum class inheriting from `SwifterEnum::Base`:

```ruby
class CameraEnum < SwifterEnum::Base
  # Using integers for database storage (most common)
  set_values ({ videographer: 0, handcam: 1 })

  # Or use strings for database storage (see "Using string values to store Enum" section)
  # set_values [:videographer, :handcam]

  def icon
    case @value
    when :videographer then "icons/video-camera"
    when :handcam then "icons/hand-stop"
    end
  end
end
```

Use it in your model:

```ruby
class Video < ApplicationRecord
  swifter_enum :camera, CameraEnum

  # Optional validation
  validates :camera, swifter_enum: true
end
```

### Working with Enum Values

```ruby
video = Video.first

# Getter returns an enum instance (not a string/symbol)
video.camera                    # => #<CameraEnum:0x000... @value=:handcam>
video.camera.value              # => :handcam (access underlying symbol)

# Multiple ways to set values
video.camera = :videographer                    # Symbol
video.camera = "videographer"                   # String
video.camera = CameraEnum[:videographer]        # Enum instance
video.camera = other_video.camera              # Copy from another instance

# Call your custom methods
video.camera.icon               # => "icons/video-camera"

# Works naturally with conditionals
if video.camera == :handcam
  # Do something
end
```

### Safe Value Access with Bracket Notation

You can use bracket notation to safely access enum values, which will raise an error if you try to access a non-existent value:

    # Access enum values with bracket notation
    emotion = EmotionEnum[:happy]
    emotion => #<EmotionEnum:0x0000000134c7c290 @value=:happy>

    # Raises ArgumentError for invalid values
    EmotionEnum[:invalid]  # ArgumentError: Unknown enum value: :invalid

    # Must use symbols, not strings
    EmotionEnum["happy"]   # ArgumentError: Enum key must be a Symbol, got String

This is useful when you want to ensure you're only using valid enum values, such as when processing user input or configuration:

    # Example: Setting a model attribute with validation
    video.camera = CameraEnum[:videographer]  # Safe - will raise if :videographer doesn't exist

    # Example: Using with dynamic values
    status_key = params[:status].to_sym
    model.status = StatusEnum[status_key]  # Will raise error if status_key is invalid


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
      set_values ({ videographer: 0, handcam: 1 })

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
      set_values ({
                    waiting_for_footage: 0,
                    waiting_for_upload: 10,
                    uploading: 20,
                    processing_preview: 24,
                    delivered_preview: 26,
                    processing_paid: 30,
                    delivered_paid: 50,
                    processing_failed: 60
                  })
    end

Now replace the definition in your model file with

    swifter_enum :album_status, AlbumStatusEnum, prefix: true

(note - prefix: optional. I'm adding it here because it was an option I used on my original standard Rails enum)

Optionally, add

    validates :album_status, swifter_enum: true

Run your tests and fix any issues. 

The main change is where you were assuming that your enum would return a string value. 

Typically, in my code, I would convert these to a symbol before comparing. So, I have to remove `album_status.to_sym` calls.

Now I can use `album_status.value` to get a symbol value, 

    album_status.value => :uploading

or if I'm doing a comparison - I can just use `album_status`.

    if album_status == :uploading {} #works as expected
    if album_status == 'uploading' {} #also works as expected


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
      set_values <<Your Values Here>>
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

### Using string values to store Enum

DHH has described using integer values for enums as a mistake he regrets.

He has shown code like

    enum direction: %w[ up down left right ].index_by(&:itself)

which uses string values in the db by generating the hash `{"up"=>"up", "down"=>"down", "left"=>"left", "right"=>"right"}`

Swifter enum allows the same - but lets you simply set your values using an array of strings or symbols

    set_values %w[ up down left right]
    #or
    set_values [:up,:down,:left,:right]


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

so, for my Administrate dashboard, I would use

    album_status_raw: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),

## More Info

See the tests folder for more examples of usage.

## Contributing

Bug reports and pull requests are welcome

## Testing

Test multiple rails versions with

  `bundle exec appraisal rake test`
