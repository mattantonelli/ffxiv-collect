module FreeCompaniesHelper
  def free_company_refreshable?(free_company)
    @free_company.syncable? && !@free_company.in_queue?
  end

  def free_company_collectable_td(character, collectable)
    owned = @owned_ids[character.id].include?(collectable.id)
    expansion = collectable.patch[0]

    content_tag(:td, fa_check(owned, false),
                class: "text-center #{owned ? 'text-success' : 'text-danger'} expansion-#{expansion}")
  end
end
