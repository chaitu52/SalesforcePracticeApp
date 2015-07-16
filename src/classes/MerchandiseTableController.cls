public class MerchandiseTableController {

	private List<Merchandise__c> merchandise;
	private Map<Id, Merchandise__c> merchandiseMap = new Map<Id, Merchandise__c>();

	private List<String> fieldNames = new List<String>();
	private Map<String, String> fieldHeaders = new Map<String, String>();

	private Merchandise__c selectedMerch;

	private Boolean showNewMerchPanel;
	private Merchandise__c merchToCreate;

	public MerchandiseTableController() {
		loadMerchandise();
		loadFieldNamesAndHeaders();
	}

	public void loadMerchandise() {
		merchandise = [SELECT Id, Name, Price__c, Quantity__c FROM Merchandise__c ORDER BY Name];

		for (Merchandise__c merch : merchandise) {
			merchandiseMap.put(merch.Id, merch);
		}
	}

	public void loadFieldNamesAndHeaders() {
		fieldNames.add('Name');
		fieldNames.add('Price__c');
		fieldNames.add('Quantity__c');

		fieldHeaders.put('Name', 'Name');
		fieldHeaders.put('Price__c', 'Price');
		fieldHeaders.put('Quantity__c', 'Quantity');
	}

	public List<String> getFieldNames() {
		return fieldNames;
	}

	public Map<String, String> getFieldHeaders() {
		return fieldHeaders;
	}

	public PageReference save() {
		update merchandise;
		deselectMerchandise();
		return null;
	}

	public void deselectMerchandise() {
		selectedMerch = null;
	}

	public void createMerchandise() {
		deselectMerchandise();
		showNewMerchPanel = true;
		merchToCreate = new Merchandise__c();
	}

	public void cancelNewMerchandise() {
		merchToCreate = null;
		showNewMerchPanel = false;
	}

	public List<Merchandise__c> getMerchandise() {
		return merchandise;
	}

	public Boolean getShowNewMerchPanel() {
		return showNewMerchPanel;
	}

	public Merchandise__c getMerchToCreate() {
		return merchToCreate;
	}

	public void saveNewMerchandise() {
		insert merchToCreate;
		showNewMerchPanel = false;
		loadMerchandise();
	}

	public Merchandise__c getSelectedMerch() {
		return selectedMerch;
	}

	public PageReference editSelectedMerch() {
		String merchId = ApexPages.currentPage().getParameters().get('merchId');
		selectedMerch = merchandiseMap.get(merchId);
		return null;
	}

	public PageReference deleteSelectedMerch() {
		Id merchId = (Id) ApexPages.currentPage().getParameters().get('merchId');

		if(merchId == null){
			showNewMerchPanel = true;
		}

		merchandiseMap.remove(merchId);
		delete [SELECT Id FROM Merchandise__c WHERE Id = :merchId LIMIT 1];
		loadMerchandise();
		return null;
	}

}