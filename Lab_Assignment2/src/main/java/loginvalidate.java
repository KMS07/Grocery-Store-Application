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
import jakarta.servlet.http.HttpSession;


@jakarta.servlet.annotation.WebServlet("/loginvalidate")
public class loginvalidate extends HttpServlet{
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
			String query = "select * from registration";
			Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(query);
            
            boolean validLogin = false;
            while (rs.next()) {
                if(request.getParameter("usr").equals(rs.getString("username")) && request.getParameter("passwd").equals(rs.getString("password")) && rs.getString("user_type").equals("Buyer")) {
                	HttpSession usrsession = request.getSession(true);
                	synchronized (usrsession) {
                		usrsession.setAttribute("username",request.getParameter("usr"));
                        usrsession.setMaxInactiveInterval(1800); //session valid for 30 minutes
					}
                	RequestDispatcher dispatcher = request.getRequestDispatcher("buyer.jsp");
                    dispatcher.forward(request, response);
//                	response.sendRedirect("buyer.jsp");
                	validLogin = true;
                	break;
                }
                else if(request.getParameter("usr").equals(rs.getString("username")) && request.getParameter("passwd").equals(rs.getString("password")) && rs.getString("user_type").equals("Shopkeeper")) {
                	HttpSession sellersession = request.getSession(true);
                	synchronized(sellersession) {
	                    sellersession.setAttribute("sellername",request.getParameter("usr"));
	                    sellersession.setMaxInactiveInterval(1800); //session valid for 30 minutes
                	}
                	RequestDispatcher dispatcher = request.getRequestDispatcher("sellerprofile.jsp");
                    dispatcher.forward(request, response);
//                	response.sendRedirect("shopkeeper.html");
                	validLogin = true;
                	break;
                }else if(request.getParameter("usr").equals("Admin123") && request.getParameter("passwd").equals("Admin@1234")) {
                	HttpSession adminsession = request.getSession(true);
                	synchronized(adminsession) {
	                    adminsession.setAttribute("adminname",request.getParameter("usr"));
	                    adminsession.setMaxInactiveInterval(1800); //session valid for 30 minutes
                	}
                	response.sendRedirect("amazonserver.jsp");
                	validLogin = true;
                	break;
                }
            }
            if(!validLogin) {
            	response.sendRedirect("login_page.html?error=true");
            }
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
    }

}
