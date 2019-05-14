module OrchestrionHelper
  def orchestrion_number(orchestrion)
    if orchestrion.order.present?
      orchestrion.order.to_s.rjust(3, '0')
    else
      "\u2014"
    end
  end

  def orchestrion_check_box(orchestrion)
    owned = @orchestrion_ids.include?(orchestrion.id)
    path = polymorphic_path(orchestrion, action: owned ? :remove : :add)
    check_box_tag(orchestrion.id, nil, owned, class: 'own', data: { path: path })
  end
end
