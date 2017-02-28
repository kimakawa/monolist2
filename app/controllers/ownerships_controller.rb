class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    logger.debug("ownerships.create is called =======")
    if params[:item_code]
      # logger.debug("if params[:item_code] is #{params[:item_code]} =======")
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
      p @item.inspect
    else
      # logger.debug("if params[:item_code] is #{params[:item_code]} =======")
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合は楽天のデータを登録する。
    if @item.new_record?
      logger.debug("if item is new_record =======")
      items = RakutenWebService::Ichiba::Item.search(itemCode: @item.item_code)
      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.save!
    end

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
    if params[:type] == "Want"
      logger.debug("if type is #{params[:type]} =======")
      current_user.want(@item)
    elsif params[:type] == "Have"
      logger.debug("if type is #{params[:type]} =======")
      current_user.have(@item)
    end

  end

  def destroy
    @item = Item.find(params[:item_id])

    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。
    if params[:type] == "Want"
      # want = current_user.want_items.find(params[:item_code])
      # @item = want.item_id
      current_user.unwant(@item)
    elsif params[:type] == "Have"
      # have = current_user.have_items.find(params[:item_code])
      # @item = have.item_id
      current_user.unhave(@item)
    end
  end
end
