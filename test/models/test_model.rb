class TestModel < ActiveRecord::Base
  include SwifterEnum # Note - this is done automatically in a real rails app

  swifter_enum :emotion, EmotionEnum
  swifter_enum :size, SizeEnum, _prefix: true
end
