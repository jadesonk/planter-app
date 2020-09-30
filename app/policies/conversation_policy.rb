class ConversationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    listing_owner = record.listing.user
    user == listing_owner || user.id == record.initiating_user_id
  end
end
