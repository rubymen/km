module Users
  class Contributor < User
    def self.model_name
      User.model_name
    end
  end
end
