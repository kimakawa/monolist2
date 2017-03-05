class RemoveRankFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :rank, :integer
  end
end
