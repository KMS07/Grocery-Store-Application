import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;


@WebServlet("/searchskjson")
public class searchskjson extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
		String url1 = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		ArrayList<Item> items = new ArrayList<Item>(); 
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
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
						items.get(sameItem).setQuantity(items.get(sameItem).getQuantity() + rs.getInt(5)); //Merging same items and increase the quantities
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
			}else {
				synchronized (session) {
					session.setAttribute("searchmsg","No items there");
				}
				response.sendRedirect("amazonserver.jsp?mergestock=true");
			}
    	response.setContentType("application/json");

    	 JsonObject requestBody = new JsonParser().parse(request.getReader()).getAsJsonObject();

    	 String shopkeeperName = requestBody.get("shopkeeperName").getAsString();

        List<Item> matchingItems = new ArrayList<>();
        for (Item item : items) {
            if (item.getShopUsr().equalsIgnoreCase(shopkeeperName)) {
                matchingItems.add(item);
            }
        }

        // Create a JSON object for the matching items
        JsonObject jsonResponse = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        for (Item item : matchingItems) {
            JsonObject itemObject = new JsonObject();
            itemObject.addProperty("id", item.getId());
            itemObject.addProperty("item_name", item.getName());
            itemObject.addProperty("price", item.getPrice());
            itemObject.addProperty("quantity", item.getQuantity());
            itemObject.addProperty("sp_usrname", item.getShopUsr());
            jsonArray.add(itemObject);
        }

        jsonResponse.add("grocerystore", jsonArray);

        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }

//        // Print the table
//        out.println("<table class='amazon-style-table'>");
//        out.println("<tr><th>ID</th><th>Item Name</th><th>Price</th><th>Quantity</th><th>Shop Keeper</th></tr>");
//
//        for (JsonElement itemElement : jsonArray) {
//            JsonObject itemObject = itemElement.getAsJsonObject();
//            int id = itemObject.get("id").getAsInt();
//            String itemName = itemObject.get("item_name").getAsString();
//            double price = itemObject.get("price").getAsDouble();
//            int quantity = itemObject.get("quantity").getAsInt();
//            String spUsername = itemObject.get("sp_usrname").getAsString();
//
//            out.println("<tr><td>" + id + "</td><td>" + itemName + "</td><td>" + price + "</td><td>" + quantity + "</td><td>" + spUsername + "</td></tr>");
//        }
//
//        out.println("</table>");
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }
    }catch(SQLException e) {
    	e.printStackTrace();
    }
    }
}
