class TestModel < ActiveRecord::Base
  include SwifterEnum #Note - this is done automatically in a real rails app

  swifter_enum :status, StatusEnum
end
