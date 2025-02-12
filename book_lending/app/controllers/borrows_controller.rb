class BorrowsController < ApplicationController
  before_action :require_authentication

  def index
    @borrows = Current.user.borrows.includes(:book).order(borrowed_at: :desc).group_by{|borrow| borrow.book_id}
  end

  def create
    book = Book.find(params[:book_id])
    borrow = Current.user.borrows.new(book: book)

    # Check if user already borrowed this book and hasn't returned it
    existing_borrow = Current.user.borrows.find_by(book: book, returned_at: nil)

    if existing_borrow
      flash[:alert] = "You have already borrowed this book and must return it first."
    else
      borrow = Current.user.borrows.new(book: book)  

      if borrow.save
        flash[:notice] = "You have successfully borrowed '#{book.title}'. Due date: #{borrow.due_date.strftime('%%d-%m-%Y %I:%M %p')}."
      else
        flash[:alert] = borrow.errors.full_messages.to_sentence
      end
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
