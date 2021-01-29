class User < ApplicationRecord
  devise :timeoutable, :omniauthable
end
