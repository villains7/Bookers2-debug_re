class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = @book.favorites.new(user_id: current_user.id)
    favorite.save
    #redirect_to request.referer
    @book.create_notification_by(current_user)
    respond_to do |format|
      format.html{redirect_to request.request.referer}
        format.js
      end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = @book.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    #redirect_to request.referer
  end
end
