module Users
  class Member < User
    def self.model_name
      User.model_name
    end
  end
end
