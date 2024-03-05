<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Purchases</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
	button{
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
	
	button:hover {
	    background-color: #d87900;
	}
	
	button:active {
	    background-color: #b76700;
	}
	
	button:disabled {
	    background-color: #e6e6e6;
	    color: #b3b3b3;
	    cursor: not-allowed;
	}
	.stockaccess{
		position:absolute;
		display:flex;
	    align-items: center;
	    gap: 20px;
	    left:40%;
	    margin-top: 10px;
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
	.amazon-style-table {
	    border-collapse: collapse;
	    width: 100%;
	    margin-top: 20px;
	    background-color: #ffffff;
	    box-shadow: 0 1px 4px 0 rgba(0, 0, 0, 0.14);
	}
	
	.amazon-style-table thead {
	    background-color: #f7f7f7;
	}
	
	.amazon-style-table th, 
	.amazon-style-table td {
	    padding: 15px;
	    text-align: left;
	    border-bottom: 1px solid #e5e5e5;
	}
	
	.amazon-style-table th {
	    font-weight: bold;
	}
	
	.amazon-style-table tr:last-child td {
	    border-bottom: none;
	}
	
	.amazon-style-table tr:hover {
	    background-color: #f0f0f0;
	}
</style>
</head>
<%@page import="java.sql.*, javax.sql.*,java.util.*"%>
<jsp:include page="sellerheader.jsp" />
<%@ page import="javafiles.Purchases" %>
<body>
	<div class = "stockaccess">
		<form action="userpurchases.jsp">
		<input type="hidden" name="searchusrhist" value="true">
		<button type="submit">Search user history</button>
		<input type='hidden' name='searchusrhist' value='false'>
		</form>
		<form action="userpurchases.jsp">
		    <input type="hidden" name="searchdurn" value="true">
		    <button type="submit">Search in a duration</button>
		</form>
		<form action="userpurchases.jsp">
		    <input type="hidden" name="ondate" value="true">
		    <button type="submit">Search in a date</button>
		</form>
	</div><br/><br/>
	
	<%
		if("true".equals(request.getParameter("searchusrhist"))){
			out.println("<form method='post'  name ='usrhist' action='searchUsr'>");
			out.println("Buyer username:<br>");
			out.println("<input type='text' name='bname' id ='busrname' value=''><br><br>");
			out.println("<button type='submit'>Search</button>");
			out.println("</form>");
			
			if(session.getAttribute("purchases")!=null){
				synchronized(session){
				List<javafiles.Purchases> purchases = (List<javafiles.Purchases>)session.getAttribute("purchases");
				out.println("<table class='amazon-style-table'>");
				out.println("<thead>");
				out.println("<tr>");
				out.println("<th>Order ID</th>");
				out.println("<th>Order Date</th>");
				out.println("<th>Status</th>");
				out.println("<th>Buyer Name</th>");
				out.println("<th>Item ID</th>");
				out.println("<th>Quantity</th>");
				out.println("<th>Total Price</th>");
				out.println("</tr>");
				out.println("</thead>");
				for(Purchases pur : purchases) {
					out.println("<tr>");
					out.println("<td>" + pur.getOrderId() + "</td>");
					out.println("<td>" + pur.getOrderDate() + "</td>");
					out.println("<td>" + pur.getStatus() + "</td>");
					out.println("<td>" + pur.getBuyerName() + "</td>");
					out.println("<td>" + pur.getItemId() + "</td>");
					out.println("<td>" + pur.getQuantity() + "</td>");
					out.println("<td>" + pur.getTotalPrice() + "</td>");
					out.println("</tr>");
				}
				out.println("</tbody>");
				out.println("</table><br/>");
				}
			}
			synchronized(session){
			if(session.getAttribute("error")!=null){
				out.println("<div class='order-notification'>");
				out.print("<h2>"+session.getAttribute("error")+"</h2>");
				out.println("</div>");
				session.setAttribute("error",null);
			}
			}
			
		}
	%>
	<%
		if("true".equals(request.getParameter("searchdurn"))){	
			out.println("<form method='post' name='td' action='twodateSearch'>");
			out.println("Initial Date:<br>");
			out.println("<input type='date' name='isd' id='isd' value=''><br><br>");
			out.println("Final date:<br>");
			out.println("<input type='date' name='fsd' id='fsd' value=''><br><br>");
			out.println("<button type='submit'>Search</button>");
			out.println("</form>");
			synchronized(session){
			if(session.getAttribute("d1") != null && session.getAttribute("d2") != null){
				String query =  "SELECT  buyer_name, order_id, order_date, status, item_id, quantity, total_price FROM registration AS r INNER JOIN orders AS o ON r.username = o.buyer_name where r.user_type = 'Buyer' and o.sellername = ? and order_date between ? and ?";
				String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
				String usr = "root";
				String password = "password";
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
				String date1="" ,date2 ="";
				date1 = (String)session.getAttribute("d1");
				date2 = (String)session.getAttribute("d2");
				session.setAttribute("d1", null);
				session.setAttribute("d2", null);
				try(Connection con = DriverManager.getConnection(url,usr,password);){
					PreparedStatement p = con.prepareStatement(query);
					p.setString(1,(String)session.getAttribute("sellername"));
					p.setString(2,date1);
					p.setString(3,date2);
					
					ResultSet rs = p.executeQuery();
					
					if(!rs.next()){
						out.println("<div class='order-notification'>");
						out.print("<h2>No orders between these dates</h2>");
						out.println("</div>");
					}else{
						out.println("<table class='amazon-style-table'>");
						out.println("<thead>");
						out.println("<tr>");
						out.println("<th>Buyer Name</th>");
						out.println("<th>Order ID</th>");
						out.println("<th>Order Date</th>");
						out.println("<th>Status</th>");
						out.println("<th>Item ID</th>");
						out.println("<th>Quantity</th>");
						out.println("<th>Total Price</th>");
						out.println("</tr>");
						out.println("</thead>");
						do{
							out.println("<tr>");
							out.println("<td>" + rs.getString("buyer_name") + "</td>");
							out.println("<td>" + rs.getInt("order_id")+ "</td>");
							out.println("<td>" + rs.getDate("order_date") + "</td>");
							out.println("<td>" + rs.getString("status") + "</td>");
							out.println("<td>" + rs.getInt("item_id")+ "</td>");
							out.println("<td>" + rs.getInt("quantity") + "</td>");
							out.println("<td>" + rs.getInt("total_price")+ "</td>");
							out.println("</tr>");
						}while(rs.next());
						out.println("</tbody>");
						out.println("</table><br/>");
					}
					
				}catch(SQLException e) {
					e.printStackTrace();
				}
			}
		  }
		}
	%>
	<%
		if("true".equals(request.getParameter("ondate"))){
			out.println("<form method='post' name='sd' action='ondateSearch' style='text-align:center;margin-top:100px;'>");
			out.println("Date:<br>");
			out.println("<input type='date' name='odate' id='odate' value=''><br><br>");
			out.println("<button type='submit'>Search</button>");
			out.println("</form>");
			synchronized(session){
			if(session.getAttribute("singleDate")!=null){
				String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
				String usr = "root";
				String password = "password";
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
				String date = (String) session.getAttribute("singleDate");
				session.setAttribute("singleDate", null);
				String query =  "SELECT  buyer_name, order_id, order_date, status, item_id, quantity, total_price FROM registration AS r INNER JOIN orders AS o ON r.username = o.buyer_name where r.user_type = 'Buyer' and o.sellername = ? and order_date = ?";
				try(Connection con = DriverManager.getConnection(url,usr,password);){
					PreparedStatement p = con.prepareStatement(query);
					p.setString(1,(String)session.getAttribute("sellername"));
					p.setString(2,date);
					ResultSet rs = p.executeQuery();
					
					if(!rs.next()){
						out.println("<div class='order-notification'>");
						out.print("<h2>No orders on this date</h2>");
						out.println("</div>");
					}else{
						out.println("<table class='amazon-style-table'>");
						out.println("<thead>");
						out.println("<tr>");
						out.println("<th>Buyer Name</th>");
						out.println("<th>Order ID</th>");
						out.println("<th>Order Date</th>");
						out.println("<th>Status</th>");
						out.println("<th>Item ID</th>");
						out.println("<th>Quantity</th>");
						out.println("<th>Total Price</th>");
						out.println("</tr>");
						out.println("</thead>");
						do{
							out.println("<tr>");
							out.println("<td>" + rs.getString("buyer_name") + "</td>");
							out.println("<td>" + rs.getInt("order_id")+ "</td>");
							out.println("<td>" + rs.getDate("order_date") + "</td>");
							out.println("<td>" + rs.getString("status") + "</td>");
							out.println("<td>" + rs.getInt("item_id")+ "</td>");
							out.println("<td>" + rs.getInt("quantity") + "</td>");
							out.println("<td>" + rs.getInt("total_price")+ "</td>");
							out.println("</tr>");
						}while(rs.next());
						out.println("</tbody>");
						out.println("</table><br/>");
					}
				}catch(SQLException e){
					e.printStackTrace();
				}
			}
			}
			
		}
	%>
	
	<script>
		/*function usrSearch(){
			var x = document.getElementById("busrname").value;
			if(x==""){
				alert("please enter buyer name");
				return false;
			}
			return true;
		}
		function ValidateTwodate(){
			var x = document.getElementById("isd").value;
			var y = document.getElementById("fsd").value;
			if(x ==""){
				alert("please enter start date");
				return false;
			}
			if(y ==""){
				alert("please enter end date");
				return false;
			}
			return true;
		}
		function singleDate(){
			var x = document.getElementById("odate").value;
			if(x==""){
					alert("please enter date");
					return false;
			}
			return true;
		}*/
		
		function validateInput(value, fieldName) {
	        if (value === "") {
	            alert("Please enter " + fieldName + ".");
	            return false;
	        }
	        return true;
	    }

	    function usrSearch() {
	        var x = $("#busrname").val();
	        if (!validateInput(x, "buyer name")) {
	            return false;
	        }
	        return true;
	    }

	    function ValidateTwodate() {
	        var x = $("#isd").val();
	        var y = $("#fsd").val();
	        if (!validateInput(x, "start date")) {
	            return false;
	        }
	        if (!validateInput(y, "end date")) {
	            return false;
	        }
	        return true;
	    }

	    function singleDate() {
	        var x = $("#odate").val();
	        if (!validateInput(x, "date")) {
	            return false;
	        }
	        return true;
	    }
	    
	    $('form[name="sd"]').submit(function(event){
			if (!singleDate()) {
				event.preventDefault(); // Prevent the form from submitting
			}
		})
		$('form[name="usrhist"]').submit(function(event){
			if (!usrSearch()) {
				event.preventDefault(); // Prevent the form from submitting
			}
		})
		$('form[name="td"]').submit(function(event){
			if (!ValidateTwodate()) {
				event.preventDefault(); // Prevent the form from submitting
			}
		})
	</script>
	
	<br/><br/><br/><br/>
	<jsp:include page="footer.jsp"/>
</body>
</html>