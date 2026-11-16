class User < ActiveRecord::Base
  has_surveys
end

class StiUser < User
end
