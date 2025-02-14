# Book Lending Application

This is a simple Ruby on Rails 8 book lending system where users can register, borrow and return books. It includes basic features like authentication, book management, and borrowing system with due dates.

## Features

- User authentication with the default authentication system (registration/login).
- Book management (adding, viewing, listing, and borrowing).
- Borrowing system with due dates.
- Returning system with return dates.
- User profile dashboard showing borrowed books,due books,summary of user activity and book recommendations.
- Flash messages and error handling.
- Validations (e.g., unique ISBN, required fields , you cant borrow a book if you haven't returned it,etc.).
- Admin CRUD operations.

## Requirements

- Ruby 3.4.1
- Rails 8.0.1
- PostgreSQL 16.6 (or your preferred database)

## Setup

1. Clone this repository:
    git clone https://github.com/NatashaJWangui/Books-Lending-App.git

2. Navigate to the project folder:
    cd railsprojects
    cd book_lending

3. Install dependencies:
    bundle install

4. Setup the database:
    rails db:create db:migrate

    # Optional: If you have seed data, you can populate the database using:
    # rails db:seed

5. Start the server :
    rails server

Open your browser and visit http://localhost:3000. It will initially redirect you to http://localhost:3000/sign_in.

### Admin CRUD Operations

To edit, add, or delete a book, you'll need an admin user. Create one with the following credentials:

- **Name**: Admin
- **Email**: admin@example.com
- **Password**: password123 (or any password you prefer).
    
# Main Routes
   * /books
   * /borrows

# Run Tests
This app uses the default Rails testing framework.
1. To run all tests:
    rails test

2. To run tests for specific controllers, views, or models, use:
    bin/rails test test/views/books/books_edit_test.rb

# Contributing
Feel free to open issues or submit pull requests for any improvements!
