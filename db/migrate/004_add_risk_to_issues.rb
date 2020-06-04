class AddRiskToIssues < ActiveRecord::Migration[4.2]
  def change
    add_column :issues, :risk_id, :integer
    add_index :issues, :risk_id
  end
end
