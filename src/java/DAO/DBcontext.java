/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Asus
 */
public class DBcontext implements Serializable {

    public Connection connection;

    public DBcontext() {
        try {
            //Change the username password and url to connect your own database
            String username = "sa";
            String password = "123"; // doi mat khau o day de run
            String url = "jdbc:sqlserver://localhost:1433;databaseName=Quizora_DB_Ver3;encrypt=true;trustServerCertificate=true";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBcontext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void main(String[] args) {
        try {
            DBcontext db = new DBcontext();
            if (db.connection != null && !db.connection.isClosed()) {
                System.out.println("Kết nối thành công đến SQL Server: " + db.connection);
            } else {
                System.out.println("Kết nối thất bại");
            }
        } catch (Exception e) {
            e.printStackTrace(); // In chi tiết lỗi nếu có
        }
    }
}
