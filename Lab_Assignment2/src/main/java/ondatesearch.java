
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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.http.HttpServlet;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Date.*;

@WebServlet("/ondateSearch")
public class ondatesearch extends HttpServlet{
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();	
		String s1 = (String)request.getParameter("odate");
		System.out.println(s1);
		if(s1.equals("")) {
			response.sendRedirect("userpurchases.jsp?ondate=true");
		}else {
			String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String usr = "root";
			String password = "password";
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		
			try(Connection con = DriverManager.getConnection(url,usr,password);){
					synchronized(session) {
						session.setAttribute("singleDate", s1);
					}
					response.sendRedirect("userpurchases.jsp?ondate=true");
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	

}
