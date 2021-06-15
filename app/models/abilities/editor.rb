module Abilities
  class Editor
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)
      
      can :create, Legislation::Proposal
      can :show, Legislation::Proposal
      can :proposals, ::Legislation::Process

      can :restore, Legislation::Proposal
      cannot :restore, Legislation::Proposal, hidden_at: nil

      can :confirm_hide, Legislation::Proposal
      cannot :confirm_hide, Legislation::Proposal, hidden_at: nil

      can :comment_as_administrator, [Debate, Comment, Proposal, Poll::Question, Budget::Investment,
                                      Legislation::Question, Legislation::Proposal, Legislation::Annotation, Topic]

      can [:search, :index], ::User

      can :manage, Dashboard::Action

      can [:read, :edit, :update, :add_question, :search_booths, :search_officers, :booth_assignments], Poll, id: user.editor.poll_ids if user.editor.present?
      can [:manage], Poll::Question::Answer, poll_id: user.editor.poll_ids if user.editor.present?
      can [:manage], Poll::ElectoralCollege
      can [:manage], Poll::Elector
      can [:create, :read], Poll::Electors::Import

      can :access, :ckeditor
      can :manage, Ckeditor::Picture

      can [:manage], ::Legislation::Process, editors: { user_id: user.id }
      can [:manage], ::Legislation::DraftVersion
      can [:manage], ::Legislation::Question
      can [:manage], ::Legislation::Proposal
      can [:manage], ::Legislation::Topic
      cannot :comment_as_moderator, [::Legislation::Question, Legislation::Annotation, ::Legislation::Proposal]

      can [:create], Document
      can [:destroy], Document, documentable_type: "Poll::Question::Answer"
      can [:create, :destroy], DirectUpload
    end
  end
end
