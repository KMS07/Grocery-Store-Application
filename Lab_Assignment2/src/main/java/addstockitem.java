
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
import java.nio.file.Paths;
import java.util.Scanner;
import java.time.LocalDate;
import java.io.*;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServlet;

import java.time.LocalDate;
import java.util.Date;
import java.util.Date.*;

@WebServlet("/add")
@MultipartConfig
public class addstockitem extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public static String title="";
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String sellername;
		synchronized(session) {
			sellername = (String) session.getAttribute("sellername");
		}
		String Item_name = request.getParameter("niname");
		String Descript	 = request.getParameter("ndesc");
		//String ILink 	 = request.getParameter("nlink");
		String sstock    = request.getParameter("nstock");
		String sprice    = request.getParameter("nprice");
		
		
		Part filePart = request.getPart("nlink"); // Retrieves <input type="file" name="nlink">
		String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); 
		InputStream fileContent = filePart.getInputStream();

		if(Item_name.equals("") || Descript.equals("") || fileName.equals("") || sstock.equals("") || sprice.equals("")) {
			response.sendRedirect("shopkeeper.jsp?addstockform=true");
		}else {
			int Stock = Integer.parseInt(request.getParameter("nstock"));
			int Price = Integer.parseInt(request.getParameter("nprice"));
			if(addItem(Item_name,Price,fileName,Stock,Descript,sellername,filePart,fileContent,getServletContext())) {
				synchronized (session) {
					session.setAttribute("msgAdd", title);
				}
				response.sendRedirect("shopkeeper.jsp?addstockform=true");
			}else {
				synchronized(session){
					session.setAttribute("msgAdd", title);
				}
				response.sendRedirect("shopkeeper.jsp?addstockform=true");
			}
		}
	}
	public static boolean addItem(String iname,int iprice, String ilink, int istock,String idesc,String sellername,Part filePart,InputStream fileContent,ServletContext servletContext){
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try(Connection con = DriverManager.getConnection(url,usr,password);){
				String q1 = "select * from stock where LOWER(item_name) = LOWER(?) and LOWER(description) = LOWER(?) and price_per_unit = ? and image_url = ? and shop_usrname = ?";
				PreparedStatement s = con.prepareStatement(q1);
				s.setString(1, iname);
				s.setString(2, idesc);
				s.setInt(3,iprice);
				s.setString(4,"/Lab_Assignment2/pics/"+ilink);
				s.setString(5, sellername);
				ResultSet r = s.executeQuery();
				if(!r.next()) {
					String template = "insert into stock(item_name,description,price_per_unit,Quantity,image_url,shop_usrname) values(?,?,?,?,?,?)";
					PreparedStatement  ins = con.prepareStatement(template);
					ins.setString(1,iname);
					ins.setString(2,idesc);
					ins.setInt(3, iprice);
					ins.setInt(4, istock);
					//adding image to the folder directory
					String savePath="";
					try {
						savePath = servletContext.getRealPath("")+ File.separator + "pics";
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

					ins.setString(5, "/Lab_Assignment2/pics/"+ilink);
					ins.setString(6, sellername);
					ins.executeUpdate();
					
					title = "Item added Successfully";
					con.close();
					return true ;
				}else {
					String query = "update stock set Quantity = Quantity + ? where item_id = ?";
					PreparedStatement updateexisting = con.prepareStatement(query);
					updateexisting.setInt(1, istock);
					updateexisting.setInt(2, r.getInt(1));
					updateexisting.executeUpdate();
					title = "Item already exists. Updated the existing quanity!!";
					con.close();
					return false;
				}
		}catch(SQLException e) {
			title = "Connection Error";
			return false;
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
