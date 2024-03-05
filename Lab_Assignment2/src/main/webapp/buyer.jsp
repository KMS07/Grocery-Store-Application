<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Buyer page</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Edu+TAS+Beginner:wght@500&display=swap');
  
  body{
  	font-family: 'Edu TAS Beginner', cursive;
  } 
  .card {
     background-color: white;
    border-radius: 8px;
    width: calc(33% - 20px);
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    text-align: center;
    transition: transform 0.3s ease-in-out;
  }
  .card img {
      width: 100%;
      height: auto;
  }
  .card-content {
      margin-top: 10px;
  }
  .card:hover {
    transform: scale(1.05);
  }
  
  .row {
    display: flex;
    flex-wrap: wrap;
    width:100%;
    margin:10px;
	}
	.items {
    width: 100%;
    height:95%;
	}
	.success-notification, .error-notification {
	    position: fixed;
	    top: 0;
	    left: 50%;
	    transform: translateX(-50%);
	    background-color: lightgreen;
	    padding: 10px;
	    border-radius: 4px;
	    z-index: 1000;
	}

	.error-notification {
	    background-color: #ff4c4c;
	    color: #fff;
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
	#search{
		text-align:center;
		font-size: 15px;
	}
  
</style>
</head>
<%@ page import="java.util.Enumeration" %>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%@ page import ="java.util.Properties,java.io.*" %>
<%@ page import = "java.util.*" %>
<jsp:include page="header.jsp" />
<%! static int pageno = 1; %>
<body>
	<h1>Welcome <% HttpSession session2 = request.getSession(); synchronized (session2){ out.println(session2.getAttribute("username"));}%>,</h1>
	<%-- <div style="margin: auto; text-align: center;padding: 25px;">
				<form method="get" action="Search">
						Search:<input style="font-size: 20px; height: 35px;" type ="text" value="<%
							String searchbar=(String)session.getAttribute("sitemnamebyusr");
							if(searchbar != null){
								out.print(searchbar);
							}
							session.setAttribute("sitemnamebyusr",null);
						%>" name="sitem" style="font-size: 30px;" required>
						<button type="submit" id ="sbt" class="sbutn">search</button><br><br>
				</form>	
		</div> --%>
		<%-- <div id = "search">
		<%
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
		%> --%>
		<div style="margin: auto; text-align: center;padding: 25px;">
			<input type="text" id="search-field" placeholder="Enter search term">
			<button id="search-button">Search</button>
		</div>
		<div id="search-results"></div>
	
	<!-- </div> -->
	<br/>
	<!-- <div class = "items">
		<div style="float:right;">
		Number of items:<input style = "float:right;" type="number" id="numItems" value="5" required/><br/>
		<button id="fetchitemsbutton">Fetch Items</button>
		</div><br/><br/><br/>
		<div id="itemContainer">
	    </div>
    </div> -->
    <div class = "items">
		<div style="float:right;">
		Number of items per page:<input style = "float:right;" type="number" id="numItems" value="5" required/><br/>
		<button class="button-amazon" style="float:left;" id="previousitemsbutton">Previous</button>
		<button class="button-amazon" style="float:right;" id="nextitemsbutton">Next</button>
		</div><br/><br/><br/>
		<div id="itemContainer">
	    </div>
    </div>
    <script>
	    /*async function fetchItems() {
	        var numItems = document.getElementById('numItems').value;
	        try {
	            let response = await fetch('GetItemsServlet?numItems=' + numItems);
	            let data = await response.json();
	            displayItems(data);
	        } catch (error) {
	            console.error('Error:', error);
	        }
	    }*/


        /*function displayItems(items) {
        	var itemContainer = document.getElementById('itemContainer');
            itemContainer.innerHTML = "";
            
            var row = document.createElement("div");
            row.className = "row";

            items.forEach((item, index) => {
                // Create a new row every 3 items
                if(index % 3 === 0 && index !== 0) {
                    itemContainer.appendChild(row);
                    row = document.createElement("div");
                    row.className = "row";
                }
				// console.log(item.item_id);
                var card = document.createElement("div");
                card.className = "card";
                card.innerHTML =
                    '<div class="card-content">' +
                    '<img style="width: 200px; height: 200px; border: 2px solid black; display: block; margin: 0 auto;" src = "'+item.image_url+'" alt = "cannot load the image"> '+'<br/>'+
                    '<p>Item_Id: ' + item.item_id + '</p>' +
                    '<p>Name: ' + item.item_name + '</p>' +
                    '<p>Price: ' + item.price + '</p>' +
                    '<p>Stock: ' + item.quantity + '</p>' +
                    '<p>Description: ' + item.description + '</p>' +
                    '</div>';

               card.innerHTML+="<br/> Quantity:";
               var qinput = document.createElement("input");
               qinput.type = "number";
               qinput.min = 0;
               card.appendChild(qinput);
               
               var button = document.createElement("button");
               button.innerText = "Add to cart";
               button.addEventListener('click', function() {
            	    addToCart(item.item_id,qinput.value,item.quantity,item.sp_usrname);
            	});
               
               card.appendChild(button);
                row.appendChild(card);

                // Append the last row even if it doesn't have 3 items
                if(index === items.length - 1) {
                    itemContainer.appendChild(row);
                }
            });
        }*/
      <%--   var usr = "<%= request.getSession(false).getAttribute("username") %>"; --%>
	    /*async function addToCart(itemId,selectedquantity,actualquantity,sellername) {
	    	console.log(typeof itemId);
	    	console.log( selectedquantity);
	    	console.log(typeof actualquantity);
	    	console.log(usr);
	        try {
	            const response = await fetch('addtocart', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded',// Indicating the type of content which is send to the server
	                },
	                body: "itemId="+itemId+"&usr="+ usr+"&squan="+parseInt(selectedquantity)+"&sname="+sellername,// Attach the itemId in the request body
	            });
	            if (!response.ok) {  // Check if HTTP status code is 2xx
	            	
	                throw new Error('Network response was not ok' + response.statusText);
	            }
	            const result = await response.json();
	            if (result.success && result.Stock && !result.sameitem) {
	                displayNotification('Item added to cart successfully!');
	            } else if(!result.Stock){
	                displayNotification('Stock not available select less than'+actualquantity, true);
	            }
	            else if(result.sameitem){
	            	displayNotification('Already in cart', true);
	            }
	            
	        } catch (error) {
	            console.error('Error:', error);
	            displayNotification('An error occurred!', true);
	        }
	    }
	
	    function displayNotification(message, isError=false) {
	        let notification = document.createElement("div");
	        notification.innerText = message;
	        notification.className = isError ? 'error-notification' : 'success-notification';
	        document.body.appendChild(notification);
	        
	        // Remove notification after 3 seconds
	        setTimeout(() => {
	            document.body.removeChild(notification);
	        }, 3000);
	    }*/
	    let pageno = 1;
	    $(document).ready(function(){
	    	
	    	console.log(pageno)
	    	$('#previousitemsbutton').click(function () {
	    		
	    		if(pageno == 1){
	    			fetchItems(1);
	    			console.log("Iam here");
	    		}else{
	    			pageno = pageno - 1;
	    			fetchItems(pageno);
	    		}
	    	});
	    	$('#nextitemsbutton').click(function () {
	    		pageno = pageno + 1;
	    		if(pageno - 1 == 1){
	    			fetchItems(1);
	    			console.log("Iam hre");
	    		}else{
	    			fetchItems(pageno);
	    		}
	    	});
	    	
	    	/* $('#fetchitemsbutton').click(function () {
	    		let pageno = 1;
                fetchItems();
            }); */
	    	
		    async function fetchItems(pageno) {
		    	$('#search-results').css('display','none');
		    	$('#itemContainer').css('display','block');
		        var numItems = $('#numItems').val();
		        console.log(numItems);
		        $.ajax({
		            url: 'GetItemsServlet',
		            method: 'GET',
		            data: { numItems: numItems , pageno : pageno},
		            dataType: 'json',
		            success: function(data) {
		                displayItems(data);
		            },
		            error: function(error) {
		                console.error('Error:', error);
		            }
		        });
		    }
		    function displayItems(items) {
	        	var itemContainer = $('#itemContainer');
	            itemContainer.html('');
	            
	            var row = $('<div class="row"></div>');
	
	            items.forEach((item, index) => {
	                // Create a new row every 3 items
	                if(index % 3 === 0 && index !== 0) {
	                    itemContainer.append(row);
	                    row = $('<div class="row"></div>');
	                }
					// console.log(item.item_id);
	                var card = $('<div class="card"></div>');
	                card.html(
	                    '<div class="card-content">' +
	                    '<img style="width: 200px; height: 200px; border: 2px solid black; display: block; margin: 0 auto;" src = "'+item.image_url+'" alt = "cannot load the image"> '+'<br/>'+
	                    '<p>Item_Id: ' + item.item_id + '</p>' +
	                    '<p>Name: ' + item.item_name + '</p>' +
	                    '<p>Price: ' + item.price + '</p>' +
	                    '<p>Stock: ' + item.quantity + '</p>' +
	                    '<p>Description: ' + item.description + '</p>' +
	                    '</div>');
	
	               card.append('<br/> Quantity:');;
	               var qinput = $('<input type="number" min="0">');;
	               card.append(qinput);
	               
	               var button = $('<button>Add to cart</button>');;
	               button.click(function() {
	            	   var selectedQuantity = parseInt(qinput.val(), 10);
	            	    if (selectedQuantity < 0) {
	            	        displayNotification('Please enter a non-negative quantity.', true);
	            	    } else {
	            	        addToCart(item.item_id, selectedQuantity, item.quantity, item.sp_usrname);
	            	    }
	            	});
	               
	               card.append(button);
	               row.append(card);
	
	               // Append the last row even if it doesn't have 3 items
	               if(index === items.length - 1) {
	                   itemContainer.append(row);
	               }
	            });
	        }
		    
		    var usr = "<%= request.getSession(false).getAttribute("username") %>";
		    async function addToCart(itemId,selectedquantity,actualquantity,sellername) {
		    	console.log(typeof itemId);
		    	console.log( selectedquantity);
		    	console.log(typeof actualquantity);
		    	console.log(usr);
		        
		        $.ajax({
		        	url:'addtocart',
		        	method: 'POST',
		        	contentType: 'application/x-www-form-urlencoded',
		        	data: {
		        		itemId: itemId,
		                usr: usr,
		                squan: parseInt(selectedquantity),
		                sname: sellername
		        	},
		        	success: function(result) {
		        		if (result.success && result.Stock && !result.sameitem) {
		                    displayNotification('Item added to cart successfully!');
		                } else if (!result.Stock) {
		                    displayNotification('Stock not available only ' + actualquantity, true);
		                } else if (result.sameitem) {
		                    displayNotification('Already in cart', true);
		                }
		        	},
		        	error: function(jqXHR, textStatus, errorThrown) {
		                console.error('Error:', errorThrown,textStatus);
		                displayNotification('An error occurred!', true);
		            }
		        });
		    }
		    function displayNotification(message, isError=false) {
		    	var notification = $('<div></div>');
		    	notification.text(message);
		    	notification.addClass(isError ? 'error-notification' : 'success-notification');
		    	$('body').append(notification);
		        
		        // Remove notification after 3 seconds
		        setTimeout(() => {
		        	notification.remove();
		        }, 3000);
		    }
	    });
	    /* $(document).ready(function() {
	    	var images = $("#search .async-image");

	        images.each(function(index) {
	            // Get the image source from a data attribute
	            var imageSrc = $(this).data("src");
	            
	          	setTimeout(function(){
		            // Create a new Image object and preload the image
		            var img = new Image();
		            img.src = imageSrc;
	
		            // When the image is fully loaded, set it as the source for the element
		            img.onload = function() {
		                $(this).attr("src", imageSrc);
		            };
	          	},7000);
	        });
	    }); */
	    $(document).ready(function() {
	    	  $('#search-button').click(function() {
	    		  $('#search-results').show();
	    		  $('#itemContainer').css('display','none');
	    	    var searchTerm = $('#search-field').val();

	    	    $.ajax({
	    	      url: 'Search',
	    	      method: 'GET',
	    	      dataType: 'json',
	    	      data: { searchTerm: searchTerm },
	    	      contentType: "application/json",
	    	      success: function(data) {
	    	        $('#search-results').empty();

	    	        $.each(data, function(index, result) {
	    	        	console.log(index);
	    	          var searchResult = 
	    	          "<div class='search-result' data-id='"+result.item_id+"'>"+
	    	          	"<div class = 'div1'>"+
							"<div class = 'div2'>"+
								"<span><font color='blue'><b>Id : </b></font>"+result.item_id+"</span><br>"+
								"<span><font color='blue'><b>Name : </b></font>"+result.item_name+"</span><br>"+
								"<span><font color='blue'><b>Price : </b></font>"+result.price+"</span><br>"+
								"<span><font color='blue'><b>stock : </b></font>"+result.quantity+"</span><br>"+
								"<span><font color='blue'><b>Description  :</b></font>"+result.description+"</span>"+
							"</div>"+
		    	            "<div class='image-placeholder' ></div>"+
		    	            "<div style='float: right ;'>"+
								"<form method = 'post' action='searchatoc'>"+
								"<input type = 'hidden' name = 'cid'  value ='"+result.item_id+"'><br>"+
								"Quantity : <input type = 'number' name = 'squan' min='0'>"+
								"<button type='submit' class='button-amazon'>Add to cart</button>"+
								"</form>"+
							"</div>"+
						"</div>"+
	    	          "</div>";

	    	          $('#search-results').append(searchResult);
	    	          loadProductImage(result.item_id,result.image_url);
	    	        });
	    	      }
	    	    });
	    	  });
	    	});
	    function loadProductImage(productId, imageUrl) {
	        var imageElement = $('#search-results').find(".search-result[data-id='"+productId+"'] .image-placeholder");

	        var image = new Image();
	        image.onload = function() {
	          imageElement.html("<img src='"+imageUrl+"' height=150px width=150px align=center border='2px solid black' alt='No image found'>");
	        };
	        image.src = imageUrl;
	      }
	    
    </script>
	<br/><br/><br/><br/>
	<jsp:include page="footer.jsp" />
</body>
</html>