class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:pageviews_remaining] ||= 3
    article = Article.find(params[:id])
    session[:pageviews_remaining] -= 1
    session[:pageviews_remaining] > 0 ? (render json: article) : (render json: { error: "Maximum pageview limit reached" }, status: :unauthorized)
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
