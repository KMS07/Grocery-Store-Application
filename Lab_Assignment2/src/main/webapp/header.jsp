<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>

  @import url('https://fonts.googleapis.com/css2?family=Edu+TAS+Beginner:wght@500&display=swap');
	
	  body {
	    font-family: 'Edu TAS Beginner', cursive;
	    margin: 0;
	    padding: 0;
	    box-sizing: border-box;
	    background-color: #f2f2f2;
	    background-image: url('grocerybg.jpg');
        background-size: cover; 
        background-repeat: no-repeat; 
        background-attachment: fixed; 
        background-position: center center; 
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
	}
	
	header {
	    background-color: #232f3e;
	    color: #fff;
	    padding: 10px 20px;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}
	
	#logo img {
	    width: 100px;
	}
	
	nav ul {
	    list-style-type: none;
	    margin: 0;
	    padding: 0;
	    display: flex;
	}
	
	nav li {
	    margin-right: 20px;
	}
	
	nav a {
	    color: #fff;
	    text-decoration: none;
	    font-size: 16px;
	    font-weight: bold;
	}
	
	nav a.active {
	    border-bottom: 2px solid #f90;
	}
	input[type="submit"]{
		background-color: #232f3e;
		color: #fff;
	    text-decoration: none;
	    font-size: 16px;
	    font-weight: bold;
	}
</style>
</head>
<body>

	<header>
        <div id="logo">
            <img src="grocery_logo.png" alt="Your Logo">
        </div>
        <nav>
            <ul>
                <li><a href="userprofile.jsp" >Home</a></li>
        		<li><a href="buyer.jsp" >Products</a></li>
        		<li><a href="cart.jsp" >Cart</a></li>
        		<li><a href="orders.jsp">Orders</a><li>
        		<li><a href="shopkeepersearch.jsp">Search items by shopkeeper</a>
        		<form action="logout"><input type="submit" value="Logout"></form>
            </ul>
        </nav>
    </header>
</body>
</html>