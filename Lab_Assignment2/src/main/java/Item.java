
public class Item {
	private int item_id;
    private String item_name;
    private double price;
    private int quantity;
    private double discount;
    private String image_url;
    private String sp_usrname;
    private String description;
    
    public int getId() {
        return item_id;
    }

    public void setId(int id) {
        this.item_id = id;
    }

    public String getName() {
        return item_name;
    }

    public void setName(String name) {
        this.item_name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int stock) {
        this.quantity = stock;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }
    
    public String getShopUsr() {
    	return sp_usrname;
    }
    
    public void setShopUsr(String usr) {
    	this.sp_usrname = usr;
    }
    public String getImage() {
    	return image_url;
    }
    
    public void setImage(String url) {
    	this.image_url= url;
    }
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
