class AddDefaultRiskStatusToRisks < ActiveRecord::Migration[4.2]

  def change
    default_risk_status = RiskStatus.default
    Risk.where(risk_status_id: nil).update_all(risk_status_id: default_risk_status.id)
  end

end