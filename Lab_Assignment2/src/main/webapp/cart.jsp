<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cart</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap');
  
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
	.button-amazon {
	    background-color: #f90;
	    color: #fff;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 3px;
	    cursor: pointer;
	    font-family: Arial, sans-serif;
	    font-size: 16px;
	    font-weight: bold;
	    text-align: center;
	    text-decoration: none;
	    display: inline-block;
	    transition: background-color 0.3s ease;
	}
	
	.button-amazon:hover {
	    background-color: #d87900;
	}
	
	.button-amazon:active {
	    background-color: #b76700;
	}
	
	.button-amazon:disabled {
	    background-color: #e6e6e6;
	    color: #b3b3b3;
	    cursor: not-allowed;
	}
	.total-purchase {
	    background-color: white;
	    margin-bottom: 15px;
	    padding: 15px;
	    border: 1px solid #ddd;
	    border-radius: 4px;
	}
	
	h1 {
	    color: #232f3e;
	}
			
</style>
</head>
<jsp:include page="header.jsp" />
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<body>
	<h1>My Cart <% HttpSession session1 = request.getSession(); synchronized(session1){out.println((String)session1.getAttribute("username")); }%></h1>
	
	<%
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		HttpSession usrsession = request.getSession(false);
		String usrname;
		synchronized(usrsession){
			usrname = (String) usrsession.getAttribute("username");
		}
		String cartQuery = "SELECT * FROM usr_cart WHERE username = ?";
		try(Connection con = DriverManager.getConnection(url,usr,password);PreparedStatement p1 = con.prepareStatement(cartQuery);){
			p1.setString(1, usrname);
		    ResultSet rs1 = p1.executeQuery();
		    int total_purchase = 0;
		    while(rs1.next()){
		    	int item_id = rs1.getInt(2);
		    	int selectedQuantity = rs1.getInt(7);
		    	String Image = rs1.getString(6);
		    	String q2 ="select * from stock where item_id = ?";
		    	PreparedStatement p2 = con.prepareStatement(q2);
		    	p2.setInt(1,item_id);
				ResultSet rs2 = p2.executeQuery();
				
				rs2.next();
		    	out.print("<div class = 'div4 clearfix'>");
				out.print("<div class = 'div5'>");
				out.print("<span><b><font color='blue'>Item id:</font> </b>"+rs2.getInt(1)+"</span><br>");
				out.print("<span><b><font color='blue'>Name :</font> </b>"+rs2.getString(2)+"</span><br>");
				out.print("<span><b><font color='blue'>Price :</font> </b>"+rs2.getInt(4)+"</span><br>");
				out.print("<span><b><font color='blue'>Selected Quantity  :</font></b>"+selectedQuantity+"</span><br>");
				out.print("<span><b><font color='blue'>total price  :</font></b>"+(selectedQuantity*(rs2.getInt(4)))+"</span>");
				total_purchase += selectedQuantity*(rs2.getInt(4));
				out.print("</div>");
				
				out.print("<div class='div6'>");
				out.print("<image height=150px width=150px align=right border='2px solid black' src = '"+Image+"' alt = 'cannot load the image'> ");
				out.print("</div>");
				
				out.print("<div style='float: right ;padding: 10px; '>");
				out.print("<h2>Remove from  Cart</h2>");
				out.print("<form method = 'post' action='removecart'>");
				out.print("<input type = 'hidden' name = 'cid'  value ='"+item_id+"'><br>");
				out.print("<button type='submit' class='button-amazon'>Remove</button>");
				out.print("</form>");
				out.print("</div>");
				out.print("</div>");
				
		    }
		    out.print("<br><br>");
			out.print("<div style = 'total-purchase; width: 300px; padding: 15px;'>");
			out.print("<span><h2 style='color:blue;'>Grand Total: "+total_purchase+"</h2></span><br>");
			out.print("</div>");
			out.print("<div>");
			out.print("<form method ='post' action='orderItems'>");
			out.print("<input type ='hidden' name='buyername' value='"+usrname+"'><br><br>");
			out.print("<button type='submit' class='button-amazon'>Place Order</button>");
			out.print("</form>");
			out.print("</div>");
			con.close();
		    
			
		}catch(SQLException e){
			e.printStackTrace();
		}
	%>
	<br/><br/><br/><br/>
	<jsp:include page="footer.jsp" />
</body>
</html>