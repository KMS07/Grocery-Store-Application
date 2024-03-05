
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;
import java.time.LocalDate;
import java.io.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@jakarta.servlet.annotation.WebServlet("/newuser")
public class newuserreg extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Database details;
    	String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try(Connection con = DriverManager.getConnection(url,usr,password);){
			String template = "INSERT INTO registration VALUES(?, ?, ?,?)";
				try (PreparedStatement inserter = con.prepareStatement(template);) {
					inserter.setString(1, request.getParameter("usr"));
		            inserter.setString(2, request.getParameter("passwd"));
		            inserter.setString(3,request.getParameter("type"));
		            inserter.setString(4,request.getParameter("email"));
	                inserter.executeUpdate();
	                
	                PrintWriter out = response.getWriter();
	                out.println("<html><body>");
	                out.println("<h1>Successfully registered.</h1>");
	                out.println("<a href=\"login_page.html\">Go to login page</a>");
	                out.println("</body></html>");
	            }catch (SQLException e) {
	            	handleSQLException(e, response,request);
	            }
		}catch(SQLException ef) {
			ef.printStackTrace();
		}
	}
	private void handleSQLException(SQLException e, HttpServletResponse response,HttpServletRequest request) throws IOException {
        if (e.getSQLState().startsWith("23")) {// SQL state code for integrity constraint violation
        	response.sendRedirect("register.html?error=true");
        }
        //for logging to the terminal
        e.printStackTrace();
    }

}
