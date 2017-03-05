class AddRankToItems < ActiveRecord::Migration
  def change
    add_column :items, :rank, :integer
  end
end
