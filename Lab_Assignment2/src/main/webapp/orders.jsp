<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My orders</title>

<style>
body{
  	font-family: 'Roboto', sans-serif;
  	 padding-bottom: 50px;
  	 margin: 0;
    padding: 0;
    background-color: #f6f6f6;
  }
	.div4{
	padding: 15px;
	border: 2px solid black;
	width: 95%;
	height: 170px;
	background-color: white;
	margin: auto;
	}
	.div5{
	padding: 5px;
	width: 550px;
	height: 170px;
	background-color: white;
	float: left;
	}
	.orders-heading {
    background-color: #232f3e;  /* Dark blue similar to Amazon's header */
    color: white;  /* Text color */
    padding: 20px;  /* Space around the text */
    text-align: center;  /* Centering the text */
    border-bottom: 4px solid #ffc700;  /* Yellow line below the heading for a slight pop of color */
    margin-bottom: 20px;  /* Space between the header and the content below it */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);  /* Slight shadow for a lift effect */
}

	h1 {
	    font-size: 24px;  /* Adjusting the font size */
	    margin: 0;  /* Removing browser default margins */
	    font-weight: 700;  /* Making the text semi-bold */
	}
	.total-display {
    background-color: #232f3e;
    color: #ffffff;
    padding: 15px;
    margin: 30px auto;  /* Top/Bottom 30px, left/right auto for centering */
    width: 400px;
    border: 1px solid #ddd;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	}
	
	h2 {
	    font-size: 20px;
	    font-weight: 700;
	    margin: 0;
	    text-align: center;
	}
	.order-notification {
    background-color: #f3f3f3;
    border: 1px solid #ddd;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin: 20px auto;
    padding: 20px;
    text-align: center;
    width: 80%;
    max-width: 500px;
	}

	.order-notification h2 {
	    font-size: 18px;
	    font-weight: 600;
	    color: #232f3e;
	    margin: 0;
	}
	
</style>
</head>
<jsp:include page="header.jsp" />
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%! int grand_total = 0; %>
<body>
		<div class="orders-heading">
	    <h1>My Orders</h1>
		</div>	<br>
		
		<% 
			HttpSession usrsession = request.getSession(true);
			String usrname = (String) usrsession.getAttribute("username");
			System.out.println(usrname);
			String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String usr = "root";
			String password = "password";
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
					try(Connection con = DriverManager.getConnection(url,usr,password);){
					String query ="select * from orders where buyer_name = ?";
					PreparedStatement p = con.prepareStatement(query);
					p.setString(1,usrname);
					ResultSet r = p.executeQuery();
					grand_total = 0;
	
					while(r.next()){
							int item_id = r.getInt(5);
							out.println(item_id);
							String q2 = "select * from stock where item_id = ?";
							PreparedStatement s2 = con.prepareStatement(q2);
							s2.setInt(1,item_id);
							ResultSet r2 = s2.executeQuery();
							if(r2.next())
								out.println("yes2");
							else
								out.println("nooooo");
							
							
							String item_name = r2.getString(2);
							int price = r2.getInt(4);
							int qty = r.getInt(6);
							int total_price = r.getInt(7);
							String imglink = r2.getString(6);
							out.print("<div class = 'div4'>\n");
									out.print("<div class = 'div5'>\n");
											out.print("<span><b><font color='blue'>Order Id :</font> </b>"+r.getInt(1)+"</span><br>\n");
											out.print("<span><b><font color='blue'>Item id:</font> </b>"+item_id+"</span><br>\n");
											out.print("<span><b><font color='blue'>Name :</font> </b>"+item_name+"</span><br>\n");
											out.print("<span><b><font color='blue'>Price :</font> </b>"+price+"</span><br>\n");
											
											
											out.print("<span><b><font color='blue'>Quantity  :</font></b>"+qty+"</span><br>\n");
											out.print("<span><b><font color='blue'>total price  :</font></b>"+total_price+"</span><br>\n");
											grand_total += total_price;
											out.print("<span><b><font color='blue'>Status  :</font></b>"+r.getString(3)+"</span><br>\n");
											out.print("<span><b><font color='blue'>Order Date  :</font></b>"+r.getString(2)+"</span><br>\n");
										out.print("</div>\n");
						
									//out.print("<div class='div6'>\n");
									//		out.print("<image height=150px width=150px align=right border='2px solid black' src = '"+imglink+"' alt = 'cannot load the image'>\n ");
									//out.print("</div>\n");
											
									
							
							out.print("</div>\n");
								
					}
				
					con.close();	
			}catch(SQLException e){
					out.print("Databse error");
					e.printStackTrace();
			}
	%>	
	<div class="total-display">
    <h2>Total: <%= grand_total %></h2>
	</div>
	
	<div class="order-notification">
    <%
			if(session.getAttribute("msgOrder") != null){
						out.print("<h2>"+session.getAttribute("msgOrder")+"</h2>");
						session.setAttribute("msgOrder",null);
			}	
	%>
	</div>
	<br/><br/><br/><br/>
	<jsp:include page="footer.jsp" />
</body>
</html>