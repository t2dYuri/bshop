class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    product = Product.find(params[:product_id])
    @line_item = current_cart.add_product(product.id, product.price)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to :back }
        format.js
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to current_cart }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { redirect_to current_cart }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      if current_cart.line_items.empty?
        current_cart.destroy
        session[:cart_id] = nil
        format.html { redirect_to store_url, notice: 'Your cart is empty' }
        format.js { flash[:notice] = 'Your cart is empty'; render action: 'destroy_last' }
      else
        format.html { redirect_to current_cart }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :quantity)
    end
end
