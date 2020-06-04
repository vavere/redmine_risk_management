class RemoveActionFromRisks < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :risks, :action
  end

  def self.down
    add_column :risks, :action, :text
  end
end
