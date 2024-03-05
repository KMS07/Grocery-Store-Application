import java.sql.Connection;
import java.util.*;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;

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
import java.util.Date;
import java.util.Date.*;

@WebServlet("/Search")
public class searchitem extends HttpServlet {
		private static final long serialVersionUID = 1L;
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				String title="";
				HttpSession session = request.getSession();
				String Item_name = request.getParameter("searchTerm");
				
				String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
				String usr = "root";
				String password = "password";
				
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
				try(Connection con = DriverManager.getConnection(url,usr,password);){
						String query = "select * from stock where item_name LIKE '%"+Item_name+"%';";
						Statement s = con.createStatement();
						ResultSet r = s.executeQuery(query);
						List<Item> items= new ArrayList<Item>();
						System.out.println("Hello");
						if(!r.next()){
							title = "Item not Available";
							synchronized(session) {
								session.setAttribute("msgsearch", title);
							}
							response.sendRedirect("buyer.jsp");
						}else {
							do{
									String SItem_name = r.getString(2);
									String Slink = r.getString(6);
									double Sprice = r.getDouble(4);
									int Sstock = r.getInt(5);
									String Sdesc = r.getString(3);
									
									Item newitem = new Item();
									newitem.setId(r.getInt(1));
									newitem.setName(SItem_name);
									newitem.setPrice(Sprice);
									newitem.setQuantity(Sstock);
									newitem.setDescription(Sdesc);
									newitem.setImage(Slink);
									items.add(newitem);
							}while(r.next());
							PrintWriter out = response.getWriter();
							Gson gson = new Gson();
							out.println(gson.toJson(items));
					}
						con.close();
						
				}catch(SQLException e) {
						//title = "Connection Error";
						//request.setAttribute("msgsearch", title);
						//requestDispatcher.forward(request, response);
				}
		}
		
		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// TODO Auto-generated method stub
			doGet(request, response);
		}
}

