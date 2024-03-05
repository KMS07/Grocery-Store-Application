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

@WebServlet("/searchsk")
public class searchsk extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String skname = request.getParameter("skname");
		HttpSession session = request.getSession();
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		String title="";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		String query = "select * from stock where shop_usrname LIKE '%"+skname+"%'";
		try(Connection con = DriverManager.getConnection(url,usr,password);){
			Statement s = con.createStatement();
			ResultSet r = s.executeQuery(query);
			
			if(r.next()) {
				do{
					String SItem_name = r.getString(2);
					String Slink = r.getString(6);
					double Sprice = r.getDouble(4);
					int Sstock = r.getInt(5);
					String Sdesc = r.getString(3);
					
					title += "<div class = 'div1'>";
					title +="<div class = 'div2'>";
					title +="<span><font color='blue'><b>Id : </b></font>"+r.getInt(1)+"</span><br>";
					title +="<span><font color='blue'><b>Name : </b></font>"+SItem_name+"</span><br>";
					title +="<span><font color='blue'><b>Price : </b></font>"+Sprice+"</span><br>";
					title +="<span><font color='blue'><b>stock : </b></font>"+Sstock+"</span><br>";
					title +="<span><font color='blue'><b>Description  :</b></font>"+Sdesc+"</span>";
					title +="</div>";
				
					title +="<image class='async-image' height=150px width=150px align=center border='2px solid black' src = '"+Slink+"' alt = 'cannot load the image'><br> ";
					title += "<div style='float: right ;padding: 10px; '>";
					title +="<form method = 'post' action='searchskatoc'>";
					title += "<input type = 'hidden' name = 'cid'  value ='"+r.getInt(1)+"'><br>";
					title += "Quantity : <input type = 'number' name = 'squan' min='0'>";
					title +="<button type='submit' class='button-amazon'>Add to cart</button>";
					title +="</form>";
					title += "</div>";
					title +="</div>";
					
				}while(r.next());
				synchronized(session) {
					session.setAttribute("msgsearch", title);
				}
				response.sendRedirect("shopkeepersearch.jsp");
				con.close();
			}else {
				title = "No items form this shop keeper";
				synchronized(session) {
					session.setAttribute("msgsearch", title);
				}
				response.sendRedirect("shopkeepersearch.jsp");
			}
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		
	}

}
