<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Seller page</title>
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
	.div6{
		width: 150px;
		height: 150px;
		background-color: white;
		float: left;
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
	.stockaccess{
		position:absolute;
		display:flex;
	    align-items: center;
	    gap: 20px;
	    left:40%;
	    margin-top: 10px;
	}
	.stockaccess  button{
		padding: 20px;
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
<%@page import="java.sql.*, javax.sql.*"%>
<jsp:include page="sellerheader.jsp" />
<body>
	<div class = "stockaccess">
		<form action="shopkeeper.jsp">
		    <input type="hidden" name="stockupdateform" value="true">
		    <button type="submit">Stock update</button>
		</form>
		<form action="shopkeeper.jsp">
		    <input type="hidden" name="addstockform" value="true">
		    <button type="submit">Add Item</button>
		</form>
		<form action="shopkeeper.jsp">
		    <input type="hidden" name="showItems" value="true">
		    <button type="submit">Your Items</button>
		</form>
		<form action="shopkeeper.jsp">
			<input type="hidden" name="uploadstock" value="true">
		    <button type="submit">Upload stock to server</button>
		</form>
	</div><br/><br/>
	<%
		String showItems = request.getParameter("showItems");
		if("true".equals(showItems)){
			String url = "jdbc:mysql://localhost:3306/grocery_store?useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
			String usr = "root";
			String password = "password";
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			String sellername;
			synchronized(session){
				sellername = (String) session.getAttribute("sellername");
			}
			String stockquery = "select * from stock where shop_usrname = ?";
			out.print("<u><h1>Your Stock</h1></u>");
			try(Connection con = DriverManager.getConnection(url,usr,password);PreparedStatement p1 = con.prepareStatement(stockquery);){
				p1.setString(1,sellername);
				ResultSet rs = p1.executeQuery();
				
				while(rs.next()){
					out.print("<div class = 'div4'>");
					
					out.print("<div class = 'div5'>");
					out.print("<span><b><font color='blue'>Item id:</font> </b>"+rs.getInt(1)+"</span><br>");
					out.print("<span><b><font color='blue'>Name :</font> </b>"+rs.getString(2)+"</span><br>");
					out.print("<span><b><font color='blue'>Description :</font> </b>"+rs.getString(3)+"</span><br>");
					out.print("<span><b><font color='blue'>Price per unit :</font></b>"+rs.getInt(4)+"</span><br>");
					out.print("<span><b><font color='blue'>Quantity:</font></b>"+rs.getInt(5)+"</span>");
					out.print("</div>");
					

					out.print("<img height=150px width=150px align=center border='2px solid black' src = '"+rs.getString(6)+"' alt = 'cannot load the image'> ");

					
					out.print("<div style='float:right;'>");
					out.print("<form id='removal' method ='post' action = 'removeStock'>");
					out.print("<h2>Remove Product</h2>");
					out.print("<input type = 'hidden'  placeholder='Item Id :' name ='rid' id='rid' value='"+rs.getInt(1)+"'>");
					out.print("<button type='submit'>Remove</button>");
					out.print("</form>");
					out.print("</div>");
					
					out.print("</div>");
				}
				con.close();
			}catch(SQLException e){
				e.printStackTrace();
			}
		}
	%>
	<%
		String displayform = request.getParameter("stockupdateform");
		if("true".equals(displayform)){
			out.println("<form id='updation'  onsubmit = 'return update()' name ='updation' method='post' action ='update' style='text-align:center;margin-top:100px;' enctype='multipart/form-data'>");
		    out.println("<h2>Enter Item id</h2>");
		    out.println("<input type='number' placeholder='Item id :' name = 'id' id='id' value='' min='1'><br><br>");
		    out.println("<h2>Enter the field which you want to update</h2><br>");
		    out.println("<input type = 'text'  placeholder='Item Name :'  name ='uiname'  id='uiname' value='' ><br><br>");
		    out.println("<input type = 'number' placeholder='Price :' name ='uprice' id='uprice' value='' min='0'><br><br>");
		    out.println("Change image:<input type = 'file'  placeholder='Image Link :' name ='ulink' id='ulink' value='' ><br><br>");
		    out.println("<input type = 'number' placeholder='Stock :' name ='ustock' id='ustock' value='' min = '0'><br><br>");
		    out.println("<input type = 'text'  placeholder='Description :' name ='udesc' id='udesc' value=''><br><br>");
		    out.println("<button type='submit'>Update Item</button>");
		    out.println("</form>");
		    
		    out.println("<div class='order-notification'>");
		    synchronized(session){
			    if(session.getAttribute("msgUpdate") != null){
					out.print("<h2>"+session.getAttribute("msgUpdate")+"</h2>");
					session.setAttribute("msgUpdate",null);
				}
		    }
		    out.println("</div>");
		}
	%>
	
	<%
		String addItem = request.getParameter("addstockform");
		if("true".equals(addItem)){
			
			out.println("<form id='addition' onsubmit='return add()' name='addition' method='post' action='add' enctype='multipart/form-data' style='text-align:center;margin-top:100px;'>");
			out.println("<h2 style='text-align:center;'>Enter Details</h2>");
	        out.println("<input type='text' placeholder='Item Name :' name='niname' id='niname' value='' ><br><br>");
	        out.println("<input type='number' placeholder='Price :' name='nprice' id='nprice' value='' min = '0' ><br><br>");
	        out.println("Upload Image:<input type='file' placeholder='Image Link :' name='nlink' id='nlink' ><br><br>");
	        out.println("<input type='number' placeholder='Stock :' name='nstock' id='nstock' value='' min = '0'><br><br>");
	        out.println("<input type='text' placeholder='Description :' name='ndesc' id='ndesc' value='' ><br><br>");
		    out.println("<button type='submit'>Add Item</button>");
		    out.println("<div class='order-notification'>");
		    synchronized(session){
	            if (session.getAttribute("msgAdd") == null) {
	                ;
	            } else {
	                out.print(session.getAttribute("msgAdd"));
	                session.setAttribute("msgAdd", null);
	            }
		    }
            out.println("</div>");
            out.println("</form>");

		}
	%><%if(request.getParameter("uploadstock")!=null){ %>
		
		
			<form  method='post' action='AddToXMLServlet' style='text-align:center;margin-top:100px;'>
				
				<h2>Enter Item id</h2>
				<input type='number' placeholder='Item id :' name = 'id' id='id' value='' min='1' required/><br/><br/>
				
				<h2 style='text-align:center;'>Enter Details</h2><br/>
				<input type='hidden' name='shopkeepername' value ='<%= session.getAttribute("sellername") %>'>
		        <input type='number' placeholder='Stock :' name='ustock' id='ustock' value='' min = '0' required><br><br>
			    <button type='submit'>Add Item</button>
			    <div class='order-notification'>
	            <%
		            if (session.getAttribute("uploadmsg")!=null) {
		                out.print(session.getAttribute("uploadmsg"));
		                session.setAttribute("uploadmsg", null);
		            }
	            %>
	            </div>
            </form>
	<%} %>
	<script>
		
			/*function update() {
			    var itemId = document.getElementById("id").value;
			    var itemName = document.getElementById("uiname").value;
			    var itemPrice = document.getElementById("uprice").value;
			    var itemLink = document.getElementById("ulink").value;
			    var itemStock = document.getElementById("ustock").value;
			    var itemDesc = document.getElementById("udesc").value;
	
			    if (itemId == "" || isNaN(itemId)) {
			        alert("Please enter a valid item ID.");
			        return false;
			    }
			    
			    if (itemPrice != "" && isNaN(itemPrice)) {  //allows blank price but if filled, it must be a number
			        alert("Please enter a valid price.");
			        return false;
			    }
	
			    
			    if (itemStock != "" && isNaN(itemStock)) {  //allows blank stock but if filled, it must be a number
			        alert("Please enter a valid stock number.");
			        return false;
			    }
			    return true;
			}
	
	
			function add(){
			    var a = document.getElementById("niname").value;
			    var b = document.getElementById("nprice").value;
			    var c = document.getElementById("nlink").value;
			    var d = document.getElementById("nstock").value;
			    var e = document.getElementById("ndiscount").value;
			    var f = document.getElementById("ndesc").value;
	
			    if(a==""){
			        alert("please enter item name");
			        return false;
			    }
			    if(b=="" || isNaN(b)){
			        alert("please enter a valid item price");
			        return false;
			    }
			    if(c==""){
			        alert("please enter item image link");
			        return false;
			    }
			    if(d=="" || isNaN(d)){
			        alert("please enter a valid item stock");
			        return false;
			    }
			    if(e=="" || isNaN(e)){
			        alert("please enter a valid item discount");
			        return false;
			    }
			    if(f==""){
			        alert("please enter item description");
			        return false;
			    }
			    return true;
			}*/
	
		$(document).ready(function(){
			
			function validateInput(value, fieldName) {
		        if (value === "" || isNaN(value)) {
		            alert("Please enter a valid " + fieldName + ".");
		            return false;
		        }
		        return true;
		    }
			function add() {
		        var a = $("#niname").val();
		        var b = $("#nprice").val();
		        var c = $("#nlink").val();
		        var d = $("#nstock").val();
		        var f = $("#ndesc").val();

		        if (a === "") {
		            alert("Please enter item name.");
		            return false;
		        }
		        if (!validateInput(b, "item price")) {
		            return false;
		        }
		        if (c === "") {
		            alert("Please enter item image link.");
		            return false;
		        }
		        if (!validateInput(d, "item stock")) {
		            return false;
		        }
		        if (f === "") {
		            alert("Please enter item description.");
		            return false;
		        }
		        return true;
		    }
			function update() {
		        var itemId = $("#id").val();
		        var itemName = $("#uiname").val();
		        var itemPrice = $("#uprice").val();
		        var itemLink = $("#ulink").val();
		        var itemStock = $("#ustock").val();
		        var itemDesc = $("#udesc").val();

		        if (!validateInput(itemId, "item ID")) {
		            return false;
		        }

		        if (itemPrice !== "" && !validateInput(itemPrice, "price")) {
		            return false;
		        }

		        if (itemStock !== "" && !validateInput(itemStock, "stock number")) {
		            return false;
		        }

		        return true;
		    }
			$('form[name="addition"]').submit(function(event){
				if (!add()) {
					event.preventDefault(); // Prevent the form from submitting
				}
			})
			$('form[name="updation"]').submit(function(event){
				if (!update()) {
					event.preventDefault(); // Prevent the form from submitting
				}
			})
		});
		
    </script>
    <jsp:include page="footer.jsp" />
</body>
</html>