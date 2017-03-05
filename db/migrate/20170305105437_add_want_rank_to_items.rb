class AddWantRankToItems < ActiveRecord::Migration
  def change
    add_column :items, :want_rank, :integer
  end
end
