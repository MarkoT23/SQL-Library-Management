-- This first instance creates a new Library if it already exists
DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- This table contains the book data constraints and necessary information to be provided
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    author VARCHAR(255),
    genre VARCHAR(100),
    publication_year INT,
    available_copies INT
);

-- This table contains the members data constraints and necessary information to be provided
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    membership_date DATE
);

-- Guess... jk, this table establishes constraints and necessary information for borrowing
CREATE TABLE Borrowing (
    borrowing_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- The following are example books to be organized and hopefully succesfully stored when run
INSERT INTO Books (title, author, genre, publication_year, available_copies)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 4),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 2),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 6);

-- Similar to books, these values are sample objects to sample members table
INSERT INTO Members (first_name, last_name, email, membership_date)
VALUES
('John', 'Doe', 'johndoe@example.com', '2023-01-15'),
('Jane', 'Smith', 'janesmith@example.com', '2022-12-05'),
('Alice', 'Johnson', 'alicej@example.com', '2024-02-20'),
('Bob', 'Williams', 'bobwilliams@example.com', '2021-09-10');

-- Similar to the other two examples, this is also a sample of the borrowing table
INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date)
VALUES
(1, 1, '2024-03-01', '2024-03-15'),
(1, 3, '2024-03-02', '2024-03-12'),
(2, 2, '2024-01-10', '2024-01-20'),
(3, 4, '2024-03-05', '2024-03-20'),
(4, 5, '2024-03-08', '2024-03-22');

-- Here we test to see if George Orwell is an author we have in our collection
SELECT title, author FROM Books
WHERE author = 'George Orwell';

-- Here we test to see if fiction is a genre of which we have books in
SELECT title, genre FROM Books
WHERE genre = 'Fiction';

-- Here we test to see if anyone has borrowed The Great Gatsby
SELECT m.first_name, m.last_name
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
WHERE bk.title = 'The Great Gatsby';

-- Here we are organizing the books by most borrowed and presenting said order
SELECT bk.title, COUNT(b.borrowing_id) AS borrow_count
FROM Books bk
LEFT JOIN Borrowing b ON bk.book_id = b.book_id
GROUP BY bk.book_id
ORDER BY borrow_count DESC;

-- Here we count how many books each member has borrowed and the order of who borrowed the most
SELECT m.first_name, m.last_name, COUNT(b.borrowing_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrowing b ON m.member_id = b.member_id
GROUP BY m.member_id
ORDER BY books_borrowed DESC;

-- Here we see who currently has a book borrowed out of our members
SELECT m.first_name, m.last_name, bk.title
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
ORDER BY m.last_name, m.first_name;

-- Here we see who has returned their borrowed book before a certain date
SELECT m.first_name, m.last_name, bk.title
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
WHERE (b.return_date < '2024-12-03' AND b.return_date IS NOT NULL);

-- Here we test to see if there are any books no-one has borrowed
SELECT 
    title
FROM
    Books bk
        LEFT JOIN
    Borrowing b ON bk.book_id = b.book_id
WHERE
    b.borrowing_id IS NULL;
