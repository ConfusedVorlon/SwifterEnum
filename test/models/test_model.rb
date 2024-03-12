class TestModel < ActiveRecord::Base
  include SwifterEnum # Note - this is done automatically in a real rails app

  swifter_enum :emotion, EmotionEnum
  swifter_enum :size, SizeEnum, prefix: true

  validates :emotion, swifter_enum: true
  validates :size, swifter_enum: true, allow_nil: true
end
