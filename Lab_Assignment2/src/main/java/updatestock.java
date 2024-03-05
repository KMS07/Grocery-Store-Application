
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import java.util.Scanner;
import java.time.LocalDate;
import java.io.*;
import java.nio.file.Paths;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServlet;

import java.time.LocalDate;
import java.util.Date;
import java.util.Date.*;

@jakarta.servlet.annotation.WebServlet("/update")
@MultipartConfig
public class updatestock extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public static String title="";
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String Item_id   = request.getParameter("id");
		String Item_name = request.getParameter("uiname");
		String Price 	 = request.getParameter("uprice");
		//String ILink 	 = request.getParameter("ulink");
		String Stock     = request.getParameter("ustock");
		String Descript	 = request.getParameter("udesc");
		HttpSession session = request.getSession(true);
		String sellername = (String)session.getAttribute("sellername");
		
		Part filePart = request.getPart("ulink"); 
		String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); 
		InputStream fileContent = filePart.getInputStream();

		if(Item_id.equals("")) {
			response.sendRedirect("shopkeeper.jsp");
		}else {
			if(updateItem(Item_id,Item_name,Price,fileName,Stock,Descript,sellername,filePart,fileContent,getServletContext())) {
				session.setAttribute("msgUpdate", title);
				response.sendRedirect("shopkeeper.jsp?stockupdateform=true");
			}else {
					session.setAttribute("msgUpdate", title);
					response.sendRedirect("shopkeeper.jsp?stockupdateform=true");
			}
		}
	}

	
	public static boolean updateItem(String Item_id ,String iname,String iprice, String ilink,
								String istock,String idesc,String sellername,Part filePart,InputStream fileContent,ServletContext servletContext){
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try(Connection con = DriverManager.getConnection(url,usr,password);){
					String q = "select * from stock where item_id = ? and shop_usrname = ?";
					PreparedStatement p = con.prepareStatement(q);
					p.setInt(1, Integer.parseInt(Item_id));
					p.setString(2, sellername);
					ResultSet r = p.executeQuery();
					if(r.next()){
							String query = "update stock set ";
							if(iname != null && !iname.trim().isEmpty()) {
									query = query + " item_name = '"+iname+"',";
							}
							if(iprice != null && !iprice.trim().isEmpty()) {
									query = query + " price_per_unit = "+iprice+",";
							}
							if(ilink != null && !ilink.trim().isEmpty()) {
								String savePath="";
								try {
									savePath = servletContext.getRealPath("")+ "pics";
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								File fileSaveDir = new File(savePath);
								if (!fileSaveDir.exists()) {
								    fileSaveDir.mkdir();
								}
								try {
									filePart.write(savePath + File.separator + ilink);
								} catch (IOException e) {
									e.printStackTrace();
								}
								System.out.println(servletContext.getRealPath("/pics")+File.separator+ ilink);
									query = query + " image_url = '/Lab_Assignment2/pics/"+ilink+"',";
							}
							if(istock != null && !istock.trim().isEmpty()) {
									query = query + " Quantity = "+istock+",";
							}
							if(idesc != null && !idesc.trim().isEmpty()) {
									query = query + " description = '"+idesc+"',";
							}
			
							if(query.charAt(query.length()-1) == ',') {
									query = query.substring(0, query.length() - 1);
							}
							query = query+" where item_id = "+Item_id+" and shop_usrname = '"+sellername+"'";
							System.out.println("Final SQL Query: " + query);
							Statement s1 = con.createStatement();
							s1.executeUpdate(query);
							title = "Item updated Successfully";
							con.close();
							return true ;
					}else {
							title = "Item id does not exist";
							con.close();
							return false;
					}
			}catch(SQLException e) {
					title = "Connection error";
					e.printStackTrace();
					return false;
			}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			doGet(request, response);
	}
}
