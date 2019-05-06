module OrchestrionHelper
  def orchestrion_number(orchestrion)
    if orchestrion.order.present?
      orchestrion.order.rjust(3, '0')
    else
      '-'
    end
  end
end
