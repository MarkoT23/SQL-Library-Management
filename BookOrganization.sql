DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Creating the 'Books' table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    author VARCHAR(255),
    genre VARCHAR(100),
    publication_year INT,
    available_copies INT
);

-- Creating the 'Members' table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    membership_date DATE
);

-- Creating the 'Borrowing' table
CREATE TABLE Borrowing (
    borrowing_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Inserting sample data into 'Books'
INSERT INTO Books (title, author, genre, publication_year, available_copies)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 4),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 2),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 6);

-- Inserting sample data into 'Members'
INSERT INTO Members (first_name, last_name, email, membership_date)
VALUES
('John', 'Doe', 'johndoe@example.com', '2023-01-15'),
('Jane', 'Smith', 'janesmith@example.com', '2022-12-05'),
('Alice', 'Johnson', 'alicej@example.com', '2024-02-20'),
('Bob', 'Williams', 'bobwilliams@example.com', '2021-09-10');

-- Inserting sample data into 'Borrowing'
INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date)
VALUES
(1, 1, '2024-03-01', '2024-03-15'),
(1, 3, '2024-03-02', '2024-03-12'),
(2, 2, '2024-01-10', '2024-01-20'),
(3, 4, '2024-03-05', '2024-03-20'),
(4, 5, '2024-03-08', '2024-03-22');

-- Query to select books by 'George Orwell'
SELECT title, author FROM Books
WHERE author = 'George Orwell';

-- Query to select books in the 'Fiction' genre
SELECT title, genre FROM Books
WHERE genre = 'Fiction';

-- Query to find the member who borrowed 'The Great Gatsby'
SELECT m.first_name, m.last_name
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
WHERE bk.title = 'The Great Gatsby';

-- Query to count borrowings of each book, ordered by borrow count
SELECT bk.title, COUNT(b.borrowing_id) AS borrow_count
FROM Books bk
LEFT JOIN Borrowing b ON bk.book_id = b.book_id
GROUP BY bk.book_id
ORDER BY borrow_count DESC;

-- Query to count books borrowed by each member, ordered by count
SELECT m.first_name, m.last_name, COUNT(b.borrowing_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrowing b ON m.member_id = b.member_id
GROUP BY m.member_id
ORDER BY books_borrowed DESC;

-- Query to list members with their borrowed books, ordered by name
SELECT m.first_name, m.last_name, bk.title
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
ORDER BY m.last_name, m.first_name;

-- Query to list members who have returned books before a specific date
SELECT m.first_name, m.last_name, bk.title
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Books bk ON b.book_id = bk.book_id
WHERE (b.return_date < '2024-12-03' AND b.return_date IS NOT NULL);

-- Query to find books that have never been borrowed
SELECT 
    title
FROM
    Books bk
        LEFT JOIN
    Borrowing b ON bk.book_id = b.book_id
WHERE
    b.borrowing_id IS NULL;