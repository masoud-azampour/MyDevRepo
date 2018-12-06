global without sharing class MetaDescriberController {
    
    public static List<Product2> prodList {public get; public set;}
    
    @RemoteAction    
    global static List<Product2>  setProductListByName(String prodName) {
    	
    	prodList = new List<Product2>();
    	
    	String qry = 'SELECT Id, ProductCode, Name FROM Product2 Where Name Like \'%' + prodName + '%\'';
    	prodList = (List<Product2>) Database.query(qry);
    	
    	System.debug(prodList);
    	
    	return prodList;
    }
    
}