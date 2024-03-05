
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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.http.HttpServlet;

import java.time.LocalDate;
import java.util.Date;
import java.util.Date.*;

/**
 * Servlet implementation class orderItem
 */
@jakarta.servlet.annotation.WebServlet("/orderItems")
public class orderItem extends HttpServlet {
	private static final long serialVersionUID = 1L;
     public static String msg ="";
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String buyer_id = request.getParameter("buyername");
		
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try(Connection con = DriverManager.getConnection(url,usr,password);){
				
				String query = "select * from usr_cart where username = ?";
				try(PreparedStatement p = con.prepareStatement(query);){
						p.setString(1,buyer_id);
						ResultSet r = p.executeQuery();
				
						con.setAutoCommit(false);
						
						while(r.next()) {
						
								int item_id = r.getInt(2);
								String q2 = "select * from stock where item_id= ?";
								PreparedStatement p1 = con.prepareStatement(q2);
								p1.setInt(1, item_id);
								ResultSet r2 = p1.executeQuery();
								r2.next();
								int stock = r2.getInt(5);
								int selectedqty = r.getInt(7);
								String status = "Ordered";
								int total_price = r.getInt(5);
						
								if(stock >= selectedqty) {
							
										String template = "INSERT INTO orders(order_date,status,buyer_name,item_id,quantity,total_price,sellername) values(?,?,?,?,?,?,?)";
										PreparedStatement ins = con.prepareStatement(template);
										ins.setDate(1,java.sql.Date.valueOf(LocalDate.now()));
										ins.setString(2,status);
										ins.setString(3,buyer_id);
										ins.setInt(4, item_id);
										ins.setInt(5, selectedqty);
										ins.setInt(6, total_price);
										ins.setString(7, r2.getString(7));
										ins.executeUpdate();
								
										String q3 = "update stock set Quantity = Quantity - ? where item_id = ?";
										PreparedStatement p2 = con.prepareStatement(q3);
										p2.setInt(1,selectedqty);
										p2.setInt(2,item_id);
										p2.executeUpdate();
										msg="Thank you for shopping with us";
								
								}else {
										msg = r2.getString(2)+" is not available\n";
								}
						
						
						
						}
						String q4 = "delete from usr_cart where username= ?";
						PreparedStatement s4 = con.prepareStatement(q4);
						s4.setString(1, buyer_id);
						s4.executeUpdate();
						synchronized(session) {
							session.setAttribute("msgOrder", msg);
						}
						response.sendRedirect("cart.jsp");
						con.commit();
				
				}catch(SQLException ex) {
					try{
						con.rollback();
					}catch(SQLException ex2){
						msg = "Transaction failed\n";
						synchronized(session) {
							session.setAttribute("msgOrder", msg);
						}
					}
				}
				con.close();
		}catch(SQLException e) {
			
			msg="Connection error\n";
			synchronized(session) {
				session.setAttribute("msgOrder", msg);
			}
			response.sendRedirect("cart.jsp");
		}
		
				
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
