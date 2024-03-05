<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Customers</title>
<style>
	body {
	    font-family: 'Roboto', sans-serif;
	    background-color: #f5f5f5;
	    padding: 20px;
	}
	
	table {
	    margin-left: auto;
	    margin-right: auto;
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
<%@page import="java.sql.*, javax.sql.*"%>
<jsp:include page="sellerheader.jsp" />
<body>
	<h1> Your customers who have purchased from you</h1><br/><br/>
	<%
		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		String usr = "root";
		String password = "password";
		synchronized(session){
		String sellername = (String) session.getAttribute("sellername");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try(Connection con = DriverManager.getConnection(url,usr,password);){
			String query = "SELECT distinct username,email FROM registration AS r INNER JOIN orders AS o ON r.username = o.buyer_name where r.user_type = 'Buyer' and o.sellername = ?";
			PreparedStatement p = con.prepareStatement(query);
			p.setString(1,sellername);
			ResultSet rs = p.executeQuery();
			
			out.println("<table class='amazon-style-table'>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>Username</th>");
			out.println("<th>Email ID</th>");
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");
			
			while(rs.next()){
				out.println("<tr>");
				out.println("<td>"+rs.getString(1)+"</td>");
				out.println("<td>"+rs.getString(2)+"</td>");
				out.println("</tr>");
			}
			
			out.println("</tbody>");
			out.println("</table>");
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		}
	%>
	

</body>
</html>