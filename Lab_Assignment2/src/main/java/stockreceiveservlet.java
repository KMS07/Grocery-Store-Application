import java.io.*;
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
import java.sql.Statement;

import org.w3c.dom.*;

import com.mysql.cj.protocol.Resultset;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import org.xml.sax.SAXException;
import java.io.IOException;
import java.io.StringReader;
import org.xml.sax.InputSource;

@WebServlet("/stockreceive")
public class stockreceiveservlet extends HttpServlet{
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		BufferedReader reader = request.getReader();
		StringBuilder xmlContent = new StringBuilder();
		String line;
		while ((line = reader.readLine()) != null) {
		    xmlContent.append(line);
		}
		try {
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	        dbFactory.setNamespaceAware(true);
	        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
	        Document doc = dBuilder.parse(new InputSource(new StringReader(xmlContent.toString())));
	        doc.getDocumentElement().normalize();
	
	        String itemName = doc.getElementsByTagName("itemname").item(0).getTextContent();
	        String id = doc.getElementsByTagName("id").item(0).getTextContent();
	        String nstock = doc.getElementsByTagName("nstock").item(0).getTextContent();
	        String sellername = doc.getElementsByTagName("sellername").item(0).getTextContent();
	        String price = doc.getElementsByTagName("price").item(0).getTextContent();
	        
	        System.out.println("THe priec:" + price);
	        //Adding to database
	        
	        String url1 = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String usr = "root";
			String password = "password";
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			String query = "insert into amazon_rcvdstock values(?,?,?,?,?)";
			String check_query = "select * from amazon_rcvdstock where item_id = ?";
//			String update1 = "update amazon_rcvdstock set stock = stock + ? where item_id = ?";
			String update2 = "update stock set Quantity = Quantity - ? where item_id = ?";
			
			try(Connection con = DriverManager.getConnection(url1,usr,password);){
				PreparedStatement p =con.prepareStatement(check_query);
				p.setInt(1, Integer.parseInt(id));
				ResultSet rs = p.executeQuery();
				System.out.println("selected");
				if(rs == null || !rs.next()) {
					try {
					PreparedStatement p1 =con.prepareStatement(query);
					p1.setInt(1, Integer.parseInt(id));
					p1.setInt(2, Integer.parseInt(nstock));
					p1.setString(3, sellername);
					p1.setString(4, itemName);
					p1.setInt(5, Integer.parseInt(price));
					p1.executeUpdate();
					System.out.println("inserted");
					}catch(Exception e) {
						e.printStackTrace();
					}
					
				}else {
					
					String update1 = "update amazon_rcvdstock set ";
					
					if(id != null && !id.trim().isEmpty()) {
						update1 = update1 + " item_id = '"+id+"',";
					}
					if(nstock != null && !nstock.trim().isEmpty()) {
						update1 = update1 + " stock = stock + '"+nstock+"',";
					}
					if(sellername != null && !sellername.trim().isEmpty()) {
						update1 = update1 + " sellername = '"+sellername+"',";
					}
					if(itemName != null && !itemName.trim().isEmpty()) {
						update1 = update1 + " itemname = '"+itemName+"',";
					}
					if(price != null && !price.trim().isEmpty()) {
						update1 = update1 + " price = '"+price+"',";
					}
					if(update1.charAt(update1.length()-1) == ',') {
						update1 = update1.substring(0, update1.length() - 1);
					}
					update1 = update1+" where item_id = "+id;
					Statement s1 = con.createStatement();
					s1.executeUpdate(update1);
				}
				
				PreparedStatement p2 =con.prepareStatement(update2);
				p2.setInt(1, Integer.parseInt(nstock));
				p2.setInt(2, Integer.parseInt(id));
				p2.executeUpdate();
			}
		}catch(Exception e){
			System.out.println("Hre exception");
			System.out.println(e);
			
		}
	}
}
