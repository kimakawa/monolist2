class AddHaveRankToItems < ActiveRecord::Migration
  def change
    add_column :items, :have_rank, :integer
  end
end
