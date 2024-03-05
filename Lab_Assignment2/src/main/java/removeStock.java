
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import java.util.Scanner;
import java.time.LocalDate;
import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@jakarta.servlet.annotation.WebServlet("/removeStock")
public class removeStock extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		HttpSession usrsession = request.getSession(false);
		String sellername;
		synchronized(usrsession) {
			sellername = (String) usrsession.getAttribute("sellername");
		}
		int item_id = Integer.parseInt(request.getParameter("rid"));
		String removeQuery = "delete from stock where item_id = ?";
		try(Connection con = DriverManager.getConnection(url,usr,password);PreparedStatement p1 = con.prepareStatement(removeQuery);){
			p1.setInt(1, item_id);
			p1.executeUpdate();
			con.close();
			response.sendRedirect("shopkeeper.jsp?showItems=true");
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
