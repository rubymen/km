class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.class.name === 'Users::Admin'
      can :manage, :all
    end

    if user && user.class.name === 'Users::Contributor'
      can :create, Document
      can :state, Document, id: user.document_ids, state: ['wip']
      can [:update, :comment], Document, id: user.document_ids, state: ['in_review', 'wip']
      can [:read, :update, :destroy], User, id: user.id

      can :read, Comment do |comment|
        (comment.readable? || comment.document.user_ids.include?(user.id)) || comment.readable?
      end

      can :read, Document do |document|
        document.state.include?('archive') || document.state.include?('validate') || user.document_ids.include?(document.id)
      end
    end

    if user && user.class.name === 'Users::Member'
      can :read, Document, state: ['archive', 'validate']
      can [:read, :update, :destroy], User, id: user.id

      can :read, Comment do |comment|
        (comment.readable? || comment.document.user_ids.include?(user.id)) || comment.readable?
      end
    end
  end
end
