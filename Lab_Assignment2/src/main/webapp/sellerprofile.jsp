<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your profile</title>
<style>
	body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
		    background-image: url('grocerybg.jpg');
	        background-size: cover; 
	        background-repeat: no-repeat; 
	        background-attachment: fixed; 
	        background-position: center center; 
        }

        .profile-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .profile-header {
            background-color: #232F3E;
            color: #fff;
            padding: 10px 20px;
            text-align: center;
            font-size: 24px;
        }

        .profile-details {
            padding: 20px;
        }

        .profile-details p {
            margin: 10px 0;
            font-size: 18px;
        }

        .label {
            font-weight: bold;
        }}
</style>
</head>
<%@page import="java.sql.*, javax.sql.*"%>
<jsp:include page="sellerheader.jsp" />
<%!String email_id =""; %>
<body>
	<h2> This is a grocery store application. </h2><br/>
	
	<div class="profile-container">
        <div class="profile-header">
            User Profile
        </div>
        <div class="profile-details">
            <p><span class="label">Name:</span> <% synchronized(session){ out.println((String)session.getAttribute("sellername")); } %></p>
            <p><span class="label">Email:</span> <%
            		String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		    		String usr = "root";
		    		String password = "password";
		    		try {
		    			Class.forName("com.mysql.cj.jdbc.Driver");
		    		} catch (ClassNotFoundException e) {
		    			e.printStackTrace();
		    		}
		    		String query = "Select email from registration where username = ?";
		    		try(Connection con = DriverManager.getConnection(url,usr,password);){
		    			PreparedStatement p = con.prepareStatement(query);
		    			p.setString(1,(String)session.getAttribute("sellername"));
		    			ResultSet rs = p.executeQuery();
		    			rs.next();
		    			out.println(rs.getString("email"));
		    			
		    		}catch(SQLException e){
		    			e.printStackTrace();
		    		}
            %></p>
            <p><span class="label">Role:</span> Seller</p>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>