<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Amazon</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap');
  
  body{
  	font-family: 'Roboto', sans-serif;
  	 padding-bottom: 50px;
  	 margin: 0;
    padding: 0;
    background-color: #f6f6f6;
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
	
</style>
</head>
<jsp:include page="amazonheader.jsp" />
<%@page import="java.sql.*, javax.sql.*,com.google.gson.*"%>
<body>
	<% if(request.getParameter("showstock")!=null){ %>
		<table class="amazon-style-table">
			<tr>
			<th>Item ID</th>
			<th>Stock</th>
			<th>Seller name</th>
			<th>Item name </th>
			<th> Price </th>
			</tr>
		<%
			String url1 = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String usr = "root";
			String password = "password";
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			String query = "select * from amazon_rcvdstock";
			try(Connection con = DriverManager.getConnection(url1,usr,password);){
				PreparedStatement p = con.prepareStatement(query);
				ResultSet rs = p.executeQuery();
				while(rs.next()){
		%>
			<tr>
				<td><%= rs.getInt(1)%></td>
				<td><%= rs.getInt(2)%></td>
				<td><%= rs.getString(3)%></td>
				<td><%= rs.getString(4)%></td>
				<td><%= rs.getInt(5)%></td>
			</tr>
		<% 
			}
			}catch(SQLException e){
				e.printStackTrace();
			}
		%>
		</table>
	<% } %>
	<% if(request.getParameter("mergestock")!=null){ %>
		<form action = "mergestock" method = "post">
			<button id="merge" type="submit">Merge STOCK entries</button>
		</form>
		<form id="searchForm" style="float:right;">
        <label for="shopkeeperName">Shop Keeper's Name:</label>
        <input type="text" id="shopkeeperName" name="shopkeeperName" required>
        <input id ='search' type="submit" value="Search">
    	</form>
    	
		<%
			if(session.getAttribute("mergemsg")!=null){
				if(((String)session.getAttribute("mergemsg")).equals("No items there")){
					out.println("No items there");
					session.setAttribute("mergemsg",null);
				}else{
		%>
			
			<table class="amazon-style-table" id='mergetable'>
				<b>Table read from json document:</b>
				<tr>
					<td>Item ID</td>
					<td>Item Name</td>
					<td>Item Price</td>
					<td>Item Quantity</td>
					<td>Shopkeeper</td>
				</tr>
		<% 
					 Gson gson = new Gson();
					    JsonObject rootObject = gson.fromJson((String)session.getAttribute("mergemsg"), JsonObject.class);

					    if (rootObject.has("grocerystore")) {
					        JsonArray itemsArray = rootObject.getAsJsonArray("grocerystore");
					        for (JsonElement itemElement : itemsArray) {
					            JsonObject itemObject = itemElement.getAsJsonObject();
					            int id = itemObject.get("id").getAsInt();
					            String itemName = itemObject.get("item_name").getAsString();
					            double price = itemObject.get("price").getAsDouble();
					            int quantity = itemObject.get("quantity").getAsInt();
					            String spUsername = itemObject.get("sp_usrname").getAsString();
					 %>
					 		<tr>
					 			<td><%= id %></td>
					 			<td><%= itemName %></td>
					 			<td><%= price %></td>
					 			<td><%= quantity %></td>
					 			<td><%= spUsername %></td>
					 		</tr>
					 			
					 <%
						       }
						        
						        
						    }else {
						        System.out.println("JSON does not contain 'grocerystore' data.");
						    }
						    
					}
				%>
				</table>
				<% 
				session.setAttribute("mergemsg",null);
				}
			%>
			<div id="results"></div>
	<%} %>
	
	<script>
	$(document).ready(function() {
	    $("#searchForm").submit(function(event) {
	        event.preventDefault();

	        const shopkeeperName = $("#shopkeeperName").val();

	        $.ajax({
	            type: "POST",
	            url: "searchskjson", // Replace with the actual URL of your Java servlet
	            data: JSON.stringify({ shopkeeperName: shopkeeperName }),
	            contentType: "application/json",
	            success: function(data) {
	                // Handle the response and update the results div
	                displayResults(data);
	            },
	            error: function(error) {
	                console.error("Error:", error);
	            }
	        });
	    });

	    function displayResults(data) {
	        let tableHTML = "<table class='amazon-style-table'><tr><th>ID</th><th>Item Name</th><th>Price</th><th>Quantity</th><th>Shop Keeper</th></tr>";

	        $.each(data.grocerystore, function(index, item) {
	            tableHTML += "<tr><td>" + item.id + "</td><td>" + item.item_name + "</td><td>" + item.price + "</td><td>" + item.quantity + "</td><td>" + item.sp_usrname + "</td></tr>";
	        });

	        tableHTML += "</table";

	        $("#results").html(tableHTML);
	    }
	    
			$('#merge').click(function(){
				$('#mergetable').css('display','block');
				$('#results').css('display','none');
			});
			
			$('#search').click(function(){
				$('#mergetable').css('display','none');
				$('#results').css('display','block');
			})

	});
	</script>
	<jsp:include page="footer.jsp" />
</body>
</html>