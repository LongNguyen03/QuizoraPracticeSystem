package DAO;

import Model.FavoriteQuiz;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class FavoriteQuizDAOTest {

    static FavoriteQuizDAO dao;

    static int testAccountId = 1;  // ID user test (đảm bảo tồn tại)
    static int testQuizId = 2;     // ID quiz test (đảm bảo tồn tại)

    @BeforeAll
    static void setup() {
        dao = new FavoriteQuizDAO();
    }

    @Test
    void testAddToFavoritesAndIsFavorite() {
        // Xóa trước nếu đã có
        dao.removeFromFavorites(testAccountId, testQuizId);

        // Ban đầu chưa có
        boolean exists = dao.isFavorite(testAccountId, testQuizId);
        assertFalse(exists, "Favorite chưa xóa sạch!");

        // Thêm
        boolean added = dao.addToFavorites(testAccountId, testQuizId);
        assertTrue(added, "Thêm favorite thất bại!");

        // Kiểm tra tồn tại
        assertTrue(dao.isFavorite(testAccountId, testQuizId), "Favorite phải tồn tại sau khi thêm!");
    }

    @Test
    void testGetFavoriteQuizzesByAccountId() {
        // Đảm bảo đã add trước
        dao.addToFavorites(testAccountId, testQuizId);

        List<FavoriteQuiz> list = dao.getFavoriteQuizzesByAccountId(testAccountId);
        assertNotNull(list, "Danh sách không được null");
        assertTrue(list.size() > 0, "Danh sách phải có ít nhất 1");

        boolean found = list.stream().anyMatch(f -> f.getQuizId() == testQuizId);
        assertTrue(found, "QuizId test không nằm trong danh sách yêu thích!");
    }

    @Test
    void testRemoveFromFavorites() {
        // Đảm bảo có trước
        dao.addToFavorites(testAccountId, testQuizId);

        boolean removed = dao.removeFromFavorites(testAccountId, testQuizId);
        assertTrue(removed, "Xóa favorite thất bại!");

        assertFalse(dao.isFavorite(testAccountId, testQuizId), "Favorite vẫn còn sau khi xóa!");
    }

}
