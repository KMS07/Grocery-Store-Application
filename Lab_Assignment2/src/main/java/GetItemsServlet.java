
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetItemsServlet")
public class GetItemsServlet extends HttpServlet {
    private static final long serialVersionUID = -3558363834837116663L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
		    int numItems = Integer.parseInt(request.getParameter("numItems"));
		    int pageno = Integer.parseInt(request.getParameter("pageno"));
		    
		    List<Item> items = getItemsFromStore(numItems,pageno);
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    PrintWriter out = response.getWriter();
		    out.println(new Gson().toJson(items));
		    out.close();
		} catch (Exception e) {
		    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		    // Optionally: return a JSON object with an error message
		    response.getWriter().println("{ \"error\": \"" + e.getMessage() + "\" }");
		}
    }

    private List<Item> getItemsFromStore(int numItems,int pageno) {
    	 List<Item> items = new ArrayList<>();
         List<Item> selectitems = new ArrayList<>();
    	// Database details;
    	String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
//		final String SELECT_LIMIT_SQL = "SELECT * FROM stock LIMIT ?";
		final String SELECT_SQL = "SELECT * FROM stock ";
		try(Connection con = DriverManager.getConnection(url,usr,password);){
            PreparedStatement preparedStatement = con.prepareStatement(SELECT_SQL);
//            preparedStatement.setInt(1, numItems);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) { //FIll all the items
                    Item item_record = new Item();
                    item_record.setId(rs.getInt("item_id"));
                    item_record.setName(rs.getString("item_name"));
                    item_record.setPrice(rs.getInt("price_per_unit"));
                    item_record.setQuantity(rs.getInt("Quantity"));
                    item_record.setDescription(rs.getString("description"));
                    item_record.setShopUsr(rs.getString("shop_usrname"));
                    item_record.setImage(rs.getString("image_url"));
                    items.add(item_record);
                }

                // Retrieve those items
                int startingitem = ((pageno-1)* numItems) + 1;
                if(startingitem > items.size()) {
                	return selectitems;
                }else {
                	for(int i=startingitem -1;i< (pageno * numItems) ;i++){
                		Item item_record = new Item();
                        item_record.setId(items.get(i).getId());
                        item_record.setName(items.get(i).getName());
                        item_record.setPrice(items.get(i).getPrice());
                        item_record.setQuantity(items.get(i).getQuantity());
                        item_record.setDescription(items.get(i).getDescription());
                        item_record.setShopUsr(items.get(i).getShopUsr());
                        item_record.setImage(items.get(i).getImage());
                        selectitems.add(item_record);
                	}
                	System.out.println("Added to selected items");
                	
                }
            }catch(SQLException e) {e.printStackTrace();}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return selectitems;
    }
}
