@isTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest(){
        Test.startTest();
        
        PageReference pageRef = Page.Product2New;
        Test.setCurrentPage(pageRef);
        
        Product2 prod = new Product2(name='Test',isActive=true);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);
        
        Product2Extension ext = new Product2Extension(stdcontroller);
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        
        ext.AddRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());
        
        for (Integer i = 0; i < 5; i++) {
            Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];
            Product2 p = new Product2();
            p.Name = 'Test Product ' + i;
            p.IsActive = true;
            p.Initial_Inventory__c = 20;
            p.Family = Constants.PRODUCT_FAMILY[0].getValue();
            wrapper.productRecord = p;
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 10;
            wrapper.pricebookEntryRecord = pbe;
        }
        
        ext.save();
        ext.GetFamilyOptions();
        ext.GetInventory();
        Test.stopTest();
        
        List<Product2> createdProducts = [SELECT Id FROM Product2];
        System.assertEquals(5, createdProducts.size());
    }

    static TestMethod void Product2Trigger_UnitTest() {
        Test.startTest();
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        newProduct.Family = 'Dessert';
        newProduct.IsActive = true;
        newProduct.Quantity_Ordered__c = 5;
        newProduct.Initial_Inventory__c = 10;
        insert newProduct;
        
        CollaborationGroup c = new CollaborationGroup();
        c.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        c.Description = 'Description';
        c.CollaborationType = 'Public';
        insert c;
        
        newProduct.Quantity_Ordered__c=96;
        update newProduct;
        Test.stopTest();
    } 

}