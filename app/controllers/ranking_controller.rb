class RankingController < ApplicationController
  def have
    @items = Item.all.order("have_rank DESC").limit(30)
  end

  def want
  end
end
