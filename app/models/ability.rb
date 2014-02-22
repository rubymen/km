class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.class.name === 'Users::Admin'
      can :manage, :all
    end

    if user && user.class.name === 'Users::Contributor'
      can :create, Document
      can [:update, :destroy, :comment], Document, id: user.document_ids, state: ['wip', 'in_review']
      can [:read, :update, :destroy], User, id: user.id
    end

    if user && user.class.name === 'Users::Member'
      can :read, Document
      can [:read, :update, :destroy], User, id: user.id
    end
  end
end
