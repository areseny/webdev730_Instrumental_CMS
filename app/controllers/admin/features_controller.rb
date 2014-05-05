class Admin::FeaturesController < AdminController

  def index
    @features = Feature.order(:priority)
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = Feature.new(feature_params)
    if @feature.save
      flash[:success] = "Destaque criado com sucesso!"
      redirect_to admin_features_path
    else
      render :new
    end
  end

  def edit
    @feature = Feature.find(params[:id])
  end

  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(feature_params)
      flash[:success] = "Destaque alterado com sucesso!"
      redirect_to admin_features_path
    else
      render :edit
    end
  end

  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy!
    flash[:success] = "Destaque removido com sucesso!"
    redirect_to admin_features_path
  end

  private

  def feature_params
    params.require(:feature)
          .permit(:title, :url, :priority, :description, :banner, :enabled)
  end

  def invalidate_cache
    expire_fragment("soundcheck-home-page-features")
    expire_fragment("home-page-features")
  end

end
