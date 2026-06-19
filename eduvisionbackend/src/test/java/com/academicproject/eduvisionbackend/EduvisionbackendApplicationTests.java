package com.academicproject.eduvisionbackend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import com.academicproject.eduvisionbackend.repository.BookRepository;
import com.academicproject.eduvisionbackend.entity.Book;
import java.util.List;

@SpringBootTest
class EduvisionbackendApplicationTests {

	@Autowired
	private BookRepository bookRepository;

	@Test
	void contextLoads() {
		System.out.println("====== START PRINTING BOOKS ======");
		List<Book> books = bookRepository.findAll();
		for (Book book : books) {
			System.out.println("ID: " + book.getId() + 
							   ", Title: " + book.getTitle() + 
							   ", FilePath: " + book.getFilePath() + 
							   ", FileName: " + book.getFileName());
		}
		System.out.println("====== END PRINTING BOOKS ======");
	}

}
