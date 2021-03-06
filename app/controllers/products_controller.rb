class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def landing
    @products = Product.all
  end

  def new
    if session[:current_user_id]
      @categories = Category.all
      @product = Product.new
    else
      redirect_to products_path
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all.where.not(id: @product.categories.map { |category| category.id })

    find_user
    if !@user || @product.user_id != @user.id
      redirect_to products_path
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
      if @product.update(params.require(:product).permit(:name, :price, :description, :image_url, :stock, :is_active, :user_id, :is_retired))
        redirect_to products_path, notice: "Product was successfully updated."
      else
        render :edit
      end
  end

  def create
    @product = Product.new(params.require(:product).permit(:name, :price, :description, :image_url, :stock, :is_active, :user_id, :is_retired))
    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      render :new
    end
  end

  def destroy
    @product = Product.all.find(params[:id])
    find_user
    if !@user || @product.user_id != @user.id
      redirect_to products_path
    else
      @product.destroy
      redirect_to products_path, notice: "Product was successfully destroyed."
    end
  end

  def search
    @search = "%#{params[:search]}%"
    @products = Product.where('lower(name) LIKE ? or lower(description) LIKE ?', @search.downcase, @search.downcase)
    render :search
  end

  def searchby
    @category = Category.all
    @userall = User.all
  end

  def create_category
     @product = Product.find(params[:id])
     @productcategory = Productcategory.new
     @productcategory.category_id = params[:category_id]
     @productcategory.product_id = @product.id
     @productcategory.save
     redirect_to edit_product_path(@product, :anchor => "category")
  end

  def destroy_category
    @product = Product.find(params[:id])
    Productcategory.find_by(product_id: params[:id], category_id: params[:category_id]).destroy
    redirect_to edit_product_path(@product, :anchor => "category")
  end

end
