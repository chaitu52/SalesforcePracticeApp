trigger DeleteRestrictInvoice on Invoice__c (before delete) {
    // Create a list of Invoices in Trigger.oldMap along with their Line Items
    List<Invoice__c> invoices = [SELECT i.Name, (SELECT Name
                                                 FROM Line_Items__r)
                                 FROM Invoice__c i
                                 WHERE i.Id IN :Trigger.oldMap.keySet()];
                                 
    // Loop through the Invoices, attaching errors to those that have Line Items
    for(Invoice__c invoice : invoices){
        if(!invoice.Line_Items__r.isEmpty()){
            Trigger.oldMap.get(invoice.id).addError('Cannot delete Invoice with Line Items');
        }
    }
}