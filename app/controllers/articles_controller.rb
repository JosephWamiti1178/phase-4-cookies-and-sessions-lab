class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # article = Article.find(params[:id])
    # render json: article

    #check if this is the first user first view and initialize the session counter
    session[:page_views] ||= 0

    #increment the session count for each view
    session[:page_views] += 1

    #check if the user has viewed more than 3 pages and render an error
    if session[:page_views] > 3
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    else
      #otherwise render the article data
      # article = Article.find(params[:id])
      # render json: articles, each_serializer: ArticleListSerializer
      article = Article.find(params[:id])
      render json: article
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
