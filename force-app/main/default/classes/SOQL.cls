/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Your Name
 */

public with sharing class SOQL {
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        // Query Salesforce Org to fetch all leads with specified fields
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }
    
    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        // Query Salesforce Org to fetch contacts with FirstName = 'John'
        return [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE FirstName = 'John'];
    }
    
    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
		// Query Salesforce Org to fetch Contact records with the last name 'Smith' or 'Jones'
		List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN ('Smith', 'Jones')];
		
		// Extract the IDs from the Contact list
		List<Id> contactIds = new List<Id>();
		for (Contact contact : contacts) {
			contactIds.add(contact.Id);
		}
		
		return contactIds; // Return the list of IDs
	}
    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunitiesByAccount(Id accountId) {
        // Query Salesforce Org to fetch closed won opportunities for the given Account Id
        return [SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity 
               WHERE AccountId = :accountId AND StageName = 'Closed Won'];
    }
    
    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        // Query Salesforce Org to get the total count of Account records
        return [SELECT COUNT() FROM Account];
    }
    
    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        // Query to retrieve tasks with due date within the next 7 days
        return new Map<Id, Task>(
            [SELECT Id, Subject, Status, Priority, ActivityDate 
             FROM Task 
             WHERE ActivityDate >= :Date.today() 
               AND ActivityDate <= :Date.today().addDays(7)]
            );
    }
    
    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
        // Query to retrieve contacts with 'example.com' in their Email field
        return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email LIKE '%@example.com'];
    }
    
    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        // Query to retrieve opportunities with the keyword in their Name
        String searchPattern = '%' + keyword + '%';
        return [SELECT Id, Name, StageName, Amount, CloseDate 
                FROM Opportunity 
                WHERE Name LIKE :searchPattern];
    }
    
    
    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        // Query to retrieve cases where Case Origin is not 'Web', 'Email', or blank
        return [SELECT Id, Subject, CaseNumber, Origin 
                FROM Case 
                WHERE Origin != 'Web' 
                  AND Origin != 'Email' 
                  AND Origin != NULL];
    }
    
    
    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        // Use SOQL to retrieve Leads matching Lead Source or Title with keyword
        String titlePattern = '%' + keyword + '%';
        return [SELECT Id, FirstName, LastName, Company, Title, LeadSource 
                FROM Lead 
                WHERE LeadSource = :leadSource 
                OR Title LIKE :titlePattern];
    }
    
    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();
        
        // Query the Contacts
        List<Contact> contacts = [SELECT LastName FROM Contact WHERE AccountId = :accountId];
        
        // Loop through each Contact and add the LastName to the list
        for (Contact contact : contacts) {
            contactLastNames.add(contact.LastName);
        }
        
        // Return the list of Contact LastNames
        return contactLastNames;
    }
    
    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] results = [SELECT SUM(Amount) totalRevenue FROM Opportunity 
        WHERE StageName = :stage OR Amount > 10000];
        // Retrieve the total revenue from the aggregate query
        return (Decimal)results[0].get('totalRevenue');
    }
    
    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        // Query to retrieve the first 10 Accounts ordered by Name
        return [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 10];
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        // Query to retrieve Opportunities with Amount > 100,000, ordered by CloseDate, limited to 5
        return [SELECT Id, Name, Amount, CloseDate 
                FROM Opportunity 
                WHERE Amount > 100000 
                ORDER BY CloseDate ASC 
                LIMIT 5];
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        // Query to retrieve Contacts ordered by Birthdate in descending order, limited to 3
        return [SELECT Id, FirstName, LastName, Birthdate 
                FROM Contact 
                ORDER BY Birthdate DESC 
                LIMIT 3];
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        // Query to retrieve Cases in Open status, ordered by CreatedDate, limited to 10, with an offset of 5
        return [SELECT Id, Subject, Status, CreatedDate 
                FROM Case 
                WHERE Status = 'Open' 
                ORDER BY CreatedDate ASC 
                LIMIT 10 
                OFFSET 5];
    }
    
    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();
        
        // Query the Cases
        List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :accountId];
        
        // Loop through each Case and add the Id to the set
        for (Case c : cases) {
            caseIds.add(c.Id);
        }
        
        // Return the set of Case Ids
        return caseIds;
    }
    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        
        // Query the Accounts
        List<Account> accounts = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country];
        
        // Loop through each Account and add the Id and Name to the map
        for (Account acc : accounts) {
            accountIdsToNames.put(acc.Id, acc.Name);
        }
        
        // Return the map of Account Ids to Account Names
        return accountIdsToNames;
    }
    
    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        // Query to retrieve the Account Name for the given Contact Id
        Contact contact = [SELECT Account.Name FROM Contact WHERE Id = :contactId LIMIT 1];
        
        // Return the Account Name
        return contact.Account != null ? contact.Account.Name : null;
    }
    
    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        // Query to retrieve the Account and related Opportunities
        return [SELECT Id, Name, (SELECT Id, Name, StageName, Amount FROM Opportunities) 
                FROM Account 
                WHERE Id = :accountId 
                LIMIT 1];
    }
    
    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account acc = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1];
        
        // Store the Account's BillingState
        String billingState = acc.BillingState;
        
        // Query the Contacts
        return [SELECT Id, FirstName, LastName, MailingState 
                FROM Contact 
                WHERE MailingState = :billingState];
    }
    
    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads and extract email domains
        List<Lead> leads = [SELECT Email FROM Lead WHERE Id IN :leadIds];
        Set<String> emailDomains = new Set<String>();
        
        for (Lead lead : leads) {
            if (lead.Email != null) {
                String[] emailParts = lead.Email.split('@');
                if (emailParts.size() > 1) {
                    emailDomains.add(emailParts[1]);
                }
            }
        }
        
        // Query the Accounts with matching website domains
        return [SELECT Id, Name, Website 
				FROM Account 
				WHERE Website IN :emailDomains];
    }
    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origLineItems = [SELECT Id, PricebookEntryId, Quantity, UnitPrice, OpportunityId
                                                   FROM OpportunityLineItem
                                                   WHERE OpportunityId = :origOppId];
        
        // Create a list to hold the new line items
        List<OpportunityLineItem> clonedLineItems = new List<OpportunityLineItem>();
        
        // Generate a random number for quantity adjustment
        for (Id cloneOppId : cloneOppIds) {
            for (OpportunityLineItem origItem : origLineItems) {
                OpportunityLineItem newItem = new OpportunityLineItem();
                newItem.PricebookEntryId = origItem.PricebookEntryId;
                newItem.Quantity = origItem.Quantity + Math.round(Math.random() * 2) + 1; // Adds 1-3
                newItem.UnitPrice = origItem.UnitPrice;
                newItem.OpportunityId = cloneOppId;
                clonedLineItems.add(newItem);
            }
        }
        
        // Insert the new line items
        if (!clonedLineItems.isEmpty()) {
            insert clonedLineItems;
        }
    }
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {
        // Query to retrieve Opportunity Name, Account Name, and Owner Name for 'Closed Won' Opportunities
        return [SELECT Id, Name, Account.Name, Owner.Name 
                FROM Opportunity 
                WHERE StageName = 'Closed Won'];
    }
		/**
		 * Question 25
		 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
		 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
		 */
		public static void setPrimaryContact() {
			// Validate CRUD permissions for Opportunity and Contact
			if (!Schema.sObjectType.Opportunity.isUpdateable() || !Schema.sObjectType.Contact.isAccessible()) {
				throw new System.SecurityException('Insufficient permissions to update Opportunities or access Contacts.');
			}
			if (!Schema.sObjectType.Contact.fields.FirstName.isAccessible()) {
				throw new System.SecurityException('Insufficient field-level permissions to access Contact FirstName.');
			}
			if (!Schema.sObjectType.Opportunity.fields.Primary_Contact__c.isUpdateable()) {
				throw new System.SecurityException('Insufficient permissions to update the Primary_Contact__c field.');
			}
		
			// Retrieve Closed Won Opportunities using the existing method
			List<Opportunity> closedWonOpportunities = getOpportunityDetailsForClosedWon();
			if (closedWonOpportunities.isEmpty()) {
				return; // No Closed Won Opportunities to process
			}
		
			// Extract Account IDs from Opportunities
			Set<Id> accountIds = new Set<Id>();
			for (Opportunity opp : closedWonOpportunities) {
				if (opp.AccountId != null) {
					accountIds.add(opp.AccountId);
				}
			}
			if (accountIds.isEmpty()) {
				return; // No accounts associated with the opportunities
			}
		
			// Query Contacts for those Accounts, ordered alphabetically by FirstName
			List<Contact> contacts = [
				SELECT Id, FirstName, AccountId 
				FROM Contact 
				WHERE AccountId IN :accountIds 
				ORDER BY FirstName ASC
			];
		
			// Map each Account ID to the alphabetically first Contact
			Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
			for (Contact contact : contacts) {
				if (!accountToContactMap.containsKey(contact.AccountId)) {
					accountToContactMap.put(contact.AccountId, contact);
				}
			}
		
			// Update Opportunities with the Primary Contact
			List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
			for (Opportunity opp : closedWonOpportunities) {
				if (opp.AccountId != null && accountToContactMap.containsKey(opp.AccountId)) {
					opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;
					opportunitiesToUpdate.add(opp);
				}
			}
		
			// Perform the update
			if (!opportunitiesToUpdate.isEmpty()) {
				update opportunitiesToUpdate;
			}
		}
	}
		