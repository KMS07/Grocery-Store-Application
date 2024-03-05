import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import org.w3c.dom.*;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


import com.mysql.cj.protocol.Resultset;

import jakarta.servlet.ServletContext;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

@WebServlet("/mergestock")
public class mergestockentries extends HttpServlet{
	private static final long serialVersionUID = 1L;
	public static String title="";
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession();
		String url1 = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		ArrayList<Item> items = new ArrayList<Item>();
		System.out.println(items.size());
		String read = "select * from amazon_rcvdstock";
		try(Connection con = DriverManager.getConnection(url1,usr,password);){
			PreparedStatement p = con.prepareStatement(read);
			ResultSet rs = p.executeQuery();
			
			// Create a list of products
			if(rs.next()) {
				do {
					int sameItem = -4;
					// Check if the new product name is already there
					for(int i = 0;i < items.size();i++) {
						if(items.get(i).getName().toLowerCase().equals(rs.getString(4).toLowerCase()) && (int)items.get(i).getPrice()== rs.getInt(5)) {
							sameItem = i;
							break;
						}
					}
					if(sameItem > 0) {
						items.get(sameItem).setQuantity(items.get(sameItem).getQuantity() + rs.getInt(2)); //Merging same items and increase the quantities
					}else {
						// Add to the items list if new item
						Item itemread = new Item();
						itemread.setId(rs.getInt(1));
						itemread.setQuantity(rs.getInt(2));
						itemread.setShopUsr(rs.getString(3));
						itemread.setName(rs.getString(4));
						itemread.setPrice(rs.getInt(5));
						items.add(itemread);
					}
				}while(rs.next()); // Created a list of products
				
				JsonObject rootObject = new JsonObject();
			    JsonArray itemsArray = new JsonArray();

			    for (Item item : items) {
			        JsonObject itemObject = new JsonObject();
			        itemObject.addProperty("id", item.getId());
			        itemObject.addProperty("item_name", item.getName());
			        itemObject.addProperty("price", item.getPrice());
			        itemObject.addProperty("quantity", item.getQuantity());
			        itemObject.addProperty("sp_usrname", item.getShopUsr());

			        itemsArray.add(itemObject);
			    }

			    rootObject.add("grocerystore", itemsArray);

			    Gson gson = new Gson();
			    
			    synchronized(session) {
			    	session.setAttribute("mergemsg",gson.toJson(rootObject));
			    }
			    
			    // Writing to JSON file
			    String directorypath ="/home/vboxuser/eclipse-workspace/Lab_Assignment2/src/main/webapp";
			    
			    File directory = new File(directorypath);
			    if(!directory.exists()) {
			    	directory.mkdir();
			    }
			    
			    String jsonfilepath = directorypath + File.separator + "stockdata.json";
			    
			    try(BufferedWriter writer = new BufferedWriter(new FileWriter(jsonfilepath))){
			    	writer.write(gson.toJson(rootObject));
			    	System.out.println("JSON file generated");
			    }
			    response.sendRedirect("amazonserver.jsp?mergestock=true");
				
			}else {
				synchronized(session) {
					session.setAttribute("mergemsg","No items there");
				}
				response.sendRedirect("amazonserver.jsp?mergestock=true");
			}
			
		}catch(SQLException e) {
			System.out.println(e);
			response.sendRedirect("amazonserver.jsp");
		}
	}
}
