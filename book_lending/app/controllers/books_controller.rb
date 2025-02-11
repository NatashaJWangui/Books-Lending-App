class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    if params[:query].present?
      @books = Book.where("title ILIKE ? OR author ILIKE ? OR isbn ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      @books = Book.all
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book deleted successfully."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
  

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :available)
  end
end
