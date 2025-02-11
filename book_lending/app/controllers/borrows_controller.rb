class BorrowsController < ApplicationController
  before_action :require_authentication

  def index
    @borrows = Current.user.borrows.includes(:book)
  end

  def create
    book = Book.find(params[:book_id])

    if book.available?
      borrow = Current.user.borrows.create(book: book, borrowed_at: Time.zone.now, due_date: 2.weeks.from_now)
      
      if borrow.persisted?
        flash[:notice] = "You have successfully borrowed '#{book.title}'. Due date: #{borrow.due_date.strftime('%Y-%m-%d')}."
      else
        flash[:alert] = "Something went wrong. Please try again."
      end
    else
      flash[:alert] = "This book is already borrowed."
    end

    redirect_to book_path(book)
  end

  def update
    borrow = Current.user.borrows.find(params[:id])

    if borrow.returned_at.nil?
      borrow.update(returned_at: Time.zone.now)
      flash[:notice] = "You have successfully returned '#{borrow.book.title}'."
    else
      flash[:alert] = "This book has already been returned."
    end

    redirect_to borrows_path
  end
end
