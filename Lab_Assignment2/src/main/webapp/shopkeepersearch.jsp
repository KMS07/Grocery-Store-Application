<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopkeeper search</title>
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
	.div1{
		padding: 15px;
		border: 2px solid black;
		width: 95%;
		height: 200px;
		background-color: white;
		
	}
		
	.div2{
			padding: 5px;
			width: 750px;
			height: 200px;
			background-color: white;
			text-align: left;
			float: left;
	}
	#search{
		text-align:center;
		font-size: 20px;
	}
</style>
</head>
<jsp:include page="header.jsp" />
<body>
	<div style="margin: auto; text-align: center;padding: 25px;">
				<form method="post" action="searchsk">
						Search:<input style="font-size: 20px; height: 35px;" type ="text" name="skname" style="font-size: 30px;" required>
						<button type="submit" id ="sbt" class="sbutn">search</button><br><br>
				</form>	
		</div>
		<div id = "search">
		<%
				synchronized(session){
				String st = (String)session.getAttribute("msgsearch");
				String cartaddmsg = (String)session.getAttribute("searchatocmsg");
				if(cartaddmsg !=null){
					out.print("<div style='font-size:15px;font-weight: bold;'>");
					out.print(cartaddmsg);
					out.print("</div>");
				}
				if(st != null){
						out.print(st);
				}else if("".equals(st)){
					out.print("<div style='font-size:15px;font-weight: bold;'>");
					out.print("No results found!!");
					out.print("</div>");
				}
				session.setAttribute("msgsearch",null);
				session.setAttribute("searchatocmsg",null);
				}
		%>

</body>
</html>