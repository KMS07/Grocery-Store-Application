
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
import javafiles.Purchases;

@WebServlet("/searchUsr")
public class usersearch extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public static String msg="";
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String sellername = (String)session.getAttribute("sellername");
		String buyername = (String)request.getParameter("bname");

		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		List<Purchases> purchases = new ArrayList<>();
		String query = "SELECT username, order_id, order_date, status, buyer_name, item_id, quantity, total_price FROM registration AS r INNER JOIN orders AS o ON r.username = o.buyer_name where r.user_type = 'Buyer' and o.sellername = ? and r.username = ?";
		try(Connection con = DriverManager.getConnection(url,usr,password);){
			PreparedStatement p = con.prepareStatement(query);
			p.setString(1, sellername);
			p.setString(2, buyername);
			ResultSet rs = p.executeQuery();
			
			if(!rs.next()) {
				msg = "This buyer hasnt purchased from you or does not exist";
				synchronized(session) {
					session.setAttribute("error", msg);
				}
				response.sendRedirect("userpurchases.jsp?searchusrhist=true");
			}else {
				do{
				    Purchases pur = new Purchases();
				    pur.setOrderId(rs.getInt("order_id"));
				    pur.setOrderDate(rs.getDate("order_date"));
				    pur.setStatus(rs.getString("status"));
				    pur.setBuyerName(rs.getString("buyer_name"));
				    pur.setItemId(rs.getInt("item_id"));
				    pur.setQuantity(rs.getInt("quantity"));
				    pur.setTotalPrice(rs.getInt("total_price"));
				    purchases.add(pur);
				}while(rs.next());
				synchronized(session) {
					session.setAttribute("purchases", purchases);
				}
				response.sendRedirect("userpurchases.jsp?searchusrhist=true");
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
}
