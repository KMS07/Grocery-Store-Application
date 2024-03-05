import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.JsonObject;

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


@jakarta.servlet.annotation.WebServlet("/searchskatoc")
public class searchskatoc extends HttpServlet{
	private static final long serialVersionUID = -3558363834837116663L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		String itemIdStr = request.getParameter("cid");
        int itemId = Integer.parseInt(itemIdStr);
        	String usrname;
        synchronized (session) {
        	usrname = (String)session.getAttribute("username");
		}
        
        
        String squan = request.getParameter("squan");
        int selectedQuantity = Integer.parseInt(squan);
        
    	// Database details;
    	String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		String insert_query = "insert into usr_cart values(?,?,?,?,?,?,?,?)";
		String retrieve_query = "select * from stock where item_id = ?";
		try(Connection con = DriverManager.getConnection(url,usr,password);){
			System.out.println(itemId);
			PreparedStatement ps1 = con.prepareStatement(retrieve_query);
            ps1.setInt(1,itemId);
            
            ResultSet rs = ps1.executeQuery();
            
            PreparedStatement ps2 = con.prepareStatement(insert_query);
            //inserting to the cart database
            if(rs.next()) {
	            int stock = rs.getInt(5);
	        	if(stock >= selectedQuantity) {
	            	try {
	                	ps2.setString(1,usrname);
	                	ps2.setInt(2,rs.getInt("item_id"));
	                	ps2.setInt(3,rs.getInt("Quantity"));
	                	ps2.setInt(4,rs.getInt("price_per_unit"));
	                	ps2.setInt(5, selectedQuantity*rs.getInt("price_per_unit"));
	                	ps2.setString(6,rs.getString("image_url"));
	                	ps2.setInt(7, selectedQuantity);
	                	ps2.setString(8, rs.getString("shop_usrname"));
	                	ps2.executeUpdate();
	                	synchronized(session) {
	                		session.setAttribute("searchatocmsg", "Added to cart");
	                	}
	                	response.sendRedirect("shopkeepersearch.jsp");
	            	}catch(Exception e) {
	            		System.out.println(e);
	            		synchronized(session) {
	            			session.setAttribute("searchatocmsg", "Already in cart");
	            		}
	            		response.sendRedirect("shopkeepersearch.jsp");
	            	}
	        	}else {
	        		synchronized(session) {
	        			session.setAttribute("searchatocmsg", "Stock available is "+stock);
	        		}
	        		response.sendRedirect("shopkeepersearch.jsp");
	        	}
            }
		}catch(SQLException e) {
			e.printStackTrace();
			response.sendRedirect("shopkeepersearch.jsp");
		}
	}
}
