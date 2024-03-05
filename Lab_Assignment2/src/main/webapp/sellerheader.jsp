<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
	  body {
	    font-family: Arial, sans-serif;
	    margin: 0;
	    padding: 0;
	    box-sizing: border-box;
	    background-color: #f2f2f2
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
</style>
</head>
<body>
	<header>
        <div id="logo">
            <img src="grocery_logo.png" alt="Your Logo">
        </div>
        <nav>
            <ul>
                <li><a href="sellerprofile.jsp" >Home</a></li>
        		<li><a href="shopkeeper.jsp" >Your Stock</a></li>
        		<li><a href="userpurchases.jsp">User Purchases</a></li>
        		<li><a href="yourcustomers.jsp">Your customers</a></li>
        		<li><form action="logout"><input type="submit" value="Logout"></form></li>
            </ul>
        </nav>
    </header>
</body>
</html>