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

import org.w3c.dom.*;

import com.mysql.cj.protocol.Resultset;

import jakarta.servlet.ServletContext;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

@WebServlet("/AddToXMLServlet")
public class addtoxml extends HttpServlet{
	private static final long serialVersionUID = 1L;
	public static String title="";
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	try {
    		HttpSession session = request.getSession();
    		String Item_id   = request.getParameter("id");
    		String sellername = request.getParameter("shopkeepername");
    		String stockupload     = request.getParameter("ustock");
    		System.out.println(Item_id);
    		System.out.println(sellername);
    		System.out.println(stockupload);

    		if(Item_id.equals("")){
    			response.sendRedirect("shopkeeper.jsp?uploadstock=true");
    		}else {
    			if(uploadItem(Item_id,stockupload,sellername)) {
    				synchronized(session) {
    					session.setAttribute("uploadmsg", title);
    				}
    				response.sendRedirect("shopkeeper.jsp?uploadstock=true");
    			}else {
    				synchronized(session) {
    					session.setAttribute("uploadmsg", title);
    				}
    					response.sendRedirect("shopkeeper.jsp?uploadstock=true");
    			}
    		}
    	}catch(Exception e){
    		System.out.println(e);
    	}
	}
    public boolean uploadItem(String Item_id ,String stockupload,String sellername){
    	String url1 = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		String query = "select item_name,quantity,price_per_unit from stock where item_id = ?";
		try(Connection con = DriverManager.getConnection(url1,usr,password);){
			PreparedStatement p = con.prepareStatement(query);
			p.setInt(1,Integer.parseInt(Item_id));
			ResultSet rs = p.executeQuery();
			
			rs.next();
			
			String item_name = rs.getString(1);
			int price = rs.getInt(3);
			
			if(Integer.parseInt(stockupload) > rs.getInt(2)) {
				title = "Select stock less than"+ rs.getInt(2);
				return false;
			}else {
				String xmlData = createXMLString(Item_id, sellername,stockupload,item_name,price);
				System.out.println("yes");
				//Send to a second servlet
				String url = "http://localhost:8080/Lab_Assignment2/stockreceive";
				try {
					HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
					connection.setRequestMethod("POST");
					connection.setDoOutput(true);
					connection.setRequestProperty("Content-Type", "application/xml; charset=UTF-8");
					connection.getOutputStream().write(xmlData.getBytes());
					connection.connect();
					connection.getInputStream();
					connection.disconnect();
				} catch (Exception e) {
					title = "Http connection error";
					e.printStackTrace();
				}
				title = "Uploaded to amazon";
				return true;
			}
		}
		catch(SQLException e) {
			title = "Item id doesnt exist";
			e.printStackTrace();
			return false;
		}
    }
    
    private String createXMLString(String itemid, String sellername,String stockupload,String itemname,int price) {
    	try {
            // Create a new XML document
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            Document doc = docBuilder.newDocument();

            // Create the root element "ShopkeeperItems"
            Element shopkeeperItems = doc.createElement("ShopkeeperItems");
            doc.appendChild(shopkeeperItems);

            // Create the "Shopkeeper" element
            Element shopkeeper = doc.createElement("Shopkeeper");
            shopkeeperItems.appendChild(shopkeeper);

                Element item = doc.createElement("Item");
                shopkeeper.appendChild(item);

                // Create child elements for each item
                Element id = doc.createElement("id");
                id.appendChild(doc.createTextNode(itemid));
                item.appendChild(id);

                Element nstock = doc.createElement("nstock");
                nstock.appendChild(doc.createTextNode(stockupload)); 
                item.appendChild(nstock);

                Element itemnameelement = doc.createElement("itemname");
                itemnameelement.appendChild(doc.createTextNode(itemname)); 
                item.appendChild(itemnameelement);

                Element sellernameelement = doc.createElement("sellername");
                sellernameelement.appendChild(doc.createTextNode(sellername)); 
                item.appendChild(sellernameelement);
                
                Element priceelement = doc.createElement("price");
                priceelement.appendChild(doc.createTextNode(""+price)); 
                item.appendChild(priceelement);

            // Convert the XML document to a string
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));

            return writer.toString();
        } catch (ParserConfigurationException | TransformerException e) {
            // Handle any exceptions that might occur during XML creation
            e.printStackTrace();
            return null;
        }
    	 
    	
    }
}
    	
