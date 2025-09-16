# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Testing
- Run all tests: `bundle exec appraisal rake test`
- Run specific test file: `bundle exec appraisal rake test TEST=test/path/to/test_file.rb`
- Test with specific Rails version: `bundle exec appraisal rails-7.1 rake test`

### Code Quality
- Run Standard Ruby linter: `standardrb`
- Auto-fix linting issues: `standardrb --fix`

### Building & Publishing
- Build gem: `rake build`
- Release new version: `rake release:publish` (builds, tags, and publishes to RubyGems)

## Architecture

SwifterEnum is a Ruby gem that extends Rails ActiveRecord enums by using classes instead of simple string/integer values. This allows encapsulating enum-related logic within the enum class itself.

### Core Components

1. **SwifterEnum::Base** (`lib/swifter_enum/base.rb`): Base class for all enum implementations. Key methods:
   - `set_values`: Defines enum values (accepts hash of symbol->integer or array of symbols/strings)
   - Instance comparison via `==` supports symbols, strings, and other enum instances
   - `t` method for i18n translations
   - `in?` method for collection checking

2. **SwifterEnum Module** (`lib/swifter_enum/swifter_enum.rb`): ActiveSupport::Concern that adds `swifter_enum` class method to ActiveRecord models. Creates:
   - Getter returning enum class instance
   - Setter accepting enum instances or raw values
   - `_raw` getter/setter for backward compatibility with standard Rails enums
   - `_raws` class method returning the value mappings

3. **SwifterEnumValidator** (`lib/swifter_enum/swifter_enum_validator.rb`): Custom validator for enum attributes

4. **Generator** (`lib/swifter_enum/generators/enum/enum_generator.rb`): Rails generator for creating new enum classes in `app/models/swifter_enum/`

### Integration Pattern

Models use `swifter_enum :attribute_name, EnumClass` instead of standard Rails `enum`. This maintains database compatibility while returning enum class instances that can have custom methods.

The gem maintains full backward compatibility through `_raw` accessors, making it easy to migrate existing Rails enums incrementally.