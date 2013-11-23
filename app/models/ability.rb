class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show], OpmlFile
    can [:index, :show], Source

    if user && user.opml_files.count > 0
      can :add, Source
      can :add_to_opml, Source
      can :remove_from_opml, Source
    end
  end
end
