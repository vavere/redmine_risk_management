class RemoveNumberFromRisks < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :risks, :number
  end

  def self.down
    add_column :risks, :number, :integer
  end
end
