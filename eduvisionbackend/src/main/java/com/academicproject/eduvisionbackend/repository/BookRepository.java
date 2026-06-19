package com.academicproject.eduvisionbackend.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.academicproject.eduvisionbackend.entity.Book;
import com.academicproject.eduvisionbackend.entity.User;

public interface BookRepository extends JpaRepository<Book, Long> {

    // All books for a user (paginated)
    Page<Book> findByUser(User user, Pageable pageable);

    // All books for a user (full list)
    List<Book> findByUser(User user);

    // Filter by category
    List<Book> findByUserAndCategoryIgnoreCase(User user, String category);

    // Filter by language
    List<Book> findByUserAndLanguageIgnoreCase(User user, String language);

    // Filter by author (partial match)
    List<Book> findByUserAndAuthorContainingIgnoreCase(User user, String author);

    // Favorites only
    List<Book> findByUserAndIsFavoriteTrue(User user);

    // Count books for a user
    long countByUser(User user);

    // Multi-field search: search by title OR author, optionally filtered by category and language
    @Query("SELECT b FROM Book b WHERE b.user = :user " +
           "AND (:query IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "    OR LOWER(b.author) LIKE LOWER(CONCAT('%', :query, '%'))) " +
           "AND (:category IS NULL OR LOWER(b.category) = LOWER(:category)) " +
           "AND (:author IS NULL OR LOWER(b.author) LIKE LOWER(CONCAT('%', :author, '%'))) " +
           "AND (:language IS NULL OR LOWER(b.language) = LOWER(:language))")
    List<Book> searchBooks(
            @Param("user") User user,
            @Param("query") String query,
            @Param("category") String category,
            @Param("author") String author,
            @Param("language") String language);

    // Get distinct categories for a user
    @Query("SELECT DISTINCT b.category FROM Book b WHERE b.user = :user AND b.category IS NOT NULL")
    List<String> findDistinctCategoriesByUser(@Param("user") User user);

    // Get distinct authors for a user
    @Query("SELECT DISTINCT b.author FROM Book b WHERE b.user = :user AND b.author IS NOT NULL")
    List<String> findDistinctAuthorsByUser(@Param("user") User user);

    // Get distinct languages for a user
    @Query("SELECT DISTINCT b.language FROM Book b WHERE b.user = :user AND b.language IS NOT NULL")
    List<String> findDistinctLanguagesByUser(@Param("user") User user);
}
