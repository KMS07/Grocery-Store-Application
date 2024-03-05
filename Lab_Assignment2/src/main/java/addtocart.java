
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addtocart")
public class addtocart extends HttpServlet {
	private static final long serialVersionUID = -3558363834837116663L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String itemIdStr = request.getParameter("itemId");
        int itemId = Integer.parseInt(itemIdStr);
        
        String usrname = request.getParameter("usr");
        
        String squan = request.getParameter("squan");
        int selectedQuantity = Integer.parseInt(squan);
        
        String sellername = request.getParameter("sname");
        
        JsonObject jsonResponse = new JsonObject();
        
        try {
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
    		String updatecart_query = "update usr_cart set squan = squan + ? where item_id = ? and username = ?";
    		String updatestock_query = "update stock set Quantity = Quantity - ? where item_id = ?";
    		try(Connection con = DriverManager.getConnection(url,usr,password);){
                PreparedStatement ps1 = con.prepareStatement(retrieve_query);
                ps1.setInt(1,itemId);
                
                ResultSet rs = ps1.executeQuery();// select the cart item from stock
                
                PreparedStatement ps2 = con.prepareStatement(insert_query);
                // inserting to the cart database
                if(rs.next()) {
                	int stock = rs.getInt(5);
                	PreparedStatement cartquan_retrieval = con.prepareStatement("select squan from usr_cart where item_id = ? and username = ?");
                	cartquan_retrieval.setInt(1, itemId);
                	cartquan_retrieval.setString(2, usrname);
                	ResultSet rs2 = cartquan_retrieval.executeQuery();
                	
                	if(rs2.next()) {
	                	if(stock >= selectedQuantity+rs2.getInt(1)) {
		                	try {
		                		PreparedStatement retrieveitemfromcart = con.prepareStatement("select * from usr_cart where item_id = ? and username = ?");
		                		retrieveitemfromcart.setInt(1,itemId);
		                		retrieveitemfromcart.setString(2, usrname);
		                		ResultSet rs1 = retrieveitemfromcart.executeQuery();
		                		
		                		if(rs1.next()){ // that means item exists so we have to update the existing cart item
		                			PreparedStatement updatecart = con.prepareStatement(updatecart_query);
		                			updatecart.setInt(1,selectedQuantity);
		                			updatecart.setInt(2, itemId);
		                			updatecart.setString(3,usrname);
		                			updatecart.executeUpdate(); // updated the quantity
		                			jsonResponse.addProperty("Stock", true);
				                	jsonResponse.addProperty("sameitem", false);
		                			
		                		}else {// new item so add new item in cart
				                	ps2.setString(1,usrname);
				                	ps2.setInt(2,rs.getInt("item_id"));
				                	ps2.setInt(3,rs.getInt("Quantity"));
				                	ps2.setInt(4,rs.getInt("price_per_unit"));
				                	ps2.setInt(5, selectedQuantity*rs.getInt("price_per_unit"));
				                	ps2.setString(6,rs.getString("image_url"));
				                	ps2.setInt(7, selectedQuantity);
				                	ps2.setString(8, sellername);
				                	ps2.executeUpdate();
				                	jsonResponse.addProperty("Stock", true);
				                	jsonResponse.addProperty("sameitem", false);
		                		}
		                	}catch(Exception e) {
		                		jsonResponse.addProperty("sameitem", true);
		                		jsonResponse.addProperty("Stock", true);
		                	}
	                	} else {
	                		jsonResponse.addProperty("Stock", false);
	                	}
                	}else {
                		if(stock >= selectedQuantity) {
		                	try {
		                		PreparedStatement retrieveitemfromcart = con.prepareStatement("select * from usr_cart where item_id = ? and username = ?");
		                		retrieveitemfromcart.setInt(1,itemId);
		                		retrieveitemfromcart.setString(2, usrname);
		                		ResultSet rs1 = retrieveitemfromcart.executeQuery();
		                		
		                		if(rs1.next()){ // that means item exists so we have to update the existing cart item
		                			PreparedStatement updatecart = con.prepareStatement(updatecart_query);
		                			updatecart.setInt(1,selectedQuantity);
		                			updatecart.setInt(2, itemId);
		                			updatecart.setString(3,sellername);
		                			updatecart.executeUpdate(); // updated the quantity
		                			jsonResponse.addProperty("Stock", true);
				                	jsonResponse.addProperty("sameitem", false);
		                			
		                		}else {// new item so add new item in cart
				                	ps2.setString(1,usrname);
				                	ps2.setInt(2,rs.getInt("item_id"));
				                	ps2.setInt(3,rs.getInt("Quantity"));
				                	ps2.setInt(4,rs.getInt("price_per_unit"));
				                	ps2.setInt(5, selectedQuantity*rs.getInt("price_per_unit"));
				                	ps2.setString(6,rs.getString("image_url"));
				                	ps2.setInt(7, selectedQuantity);
				                	ps2.setString(8, sellername);
				                	ps2.executeUpdate();
				                	jsonResponse.addProperty("Stock", true);
				                	jsonResponse.addProperty("sameitem", false);
		                		}
		                	}catch(Exception e) {
		                		jsonResponse.addProperty("sameitem", true);
		                		jsonResponse.addProperty("Stock", true);
		                	}
	                	} else {
	                		jsonResponse.addProperty("Stock", false);
	                	}
                	}
                }
                
    		}
    		catch(SQLException e) {
    			e.printStackTrace();
    		}
            
            jsonResponse.addProperty("success", true);
//            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("errorMessage", e.getMessage());
//            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
		
	}
}
