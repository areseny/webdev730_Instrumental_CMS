class Admin::TvFeaturesController < AdminController

  def index
  end

  def datatable
    @tv_features = TvFeature.order("debuts_at desc")
  end

  def new
    @tv_feature = TvFeature.new(debuts_at: Date.today + 21.hours + 30.minutes)
  end

  def create
    @tv_feature = TvFeature.new(tv_feature_params)
    if @tv_feature.save!
      invalidate_cache
      flash[:success] = "admin.tv_features.create"
      redirect_to admin_tv_features_path
    else
      render :new
    end
  end

  def edit
    @tv_feature = TvFeature.find(params[:id])
  end

  def update
    @tv_feature = TvFeature.find(params[:id])
    if @tv_feature.update_attributes(tv_feature_params)
      invalidate_cache
      flash[:success] = "admin.tv_features.update"
      redirect_to admin_tv_features_path
    else
      render :edit
    end
  end

  def destroy
    @tv_feature = TvFeature.find(params[:id])
    @tv_feature.destroy!
    invalidate_cache
    flash[:success] = "admin.tv_features.destroy"
    redirect_to admin_tv_features_path
  end

  private

  def tv_feature_params
    params[:tv_feature][:debuts_at] = DateTime.parse(params[:tv_feature][:debuts_at])
    params.require(:tv_feature).permit(:debuts_at, :show_id, :description)
  end

  def invalidate_cache
    expire_fragment("tv-features-datatable")
    expire_fragment("tv-features-homepage")
  end

end
