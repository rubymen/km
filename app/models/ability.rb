class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.class.name === 'Users::Admin'
    end

    if user && user.class.name === 'Users::Contributor'
    end

    if user && user.class.name === 'Users::Member'
    end
  end
end
