        /**
         * The SOQLTest class is specifically designed to test the functionality of methods in the SOQL class.
         * It encapsulates a series of test methods, each carefully designed to validate the individual methods in the SOQL class, ensuring they are functioning accurately and correctly.
         * The Salesforce Assert class is an essential part of these test methods to assert and validate the outcomes of the SOQL queries.
         *
         * Test methods encapsulated in this class are devoted to testing SOQL queries, which include SELECT statements, WHERE clause filters, Relationship queries, and usage of the LIMIT keyword.
         * Users of this class can expect to gain an understanding of how to write unit tests for SOQL queries in Apex and Salesforce, enabling them to validate their own custom SOQL queries.
         */
        @IsTest
        public class SOQLTest {
            @IsTest
            static void testGetAllLeads() {
                // Create test data
                Lead testLead1 = new Lead(
                    LastName = 'Test Lead 1',
                Company = 'Test Company 1',
                Phone = '1234567890',
                Email = 'lead1@email.com'
                    );
                Lead testLead2 = new Lead(
                    LastName = 'Test Lead 2',
                Company = 'Test Company 2',
                Phone = '0987654321',
                Email = 'lead2@email.com'
                    );
                insert new List<Lead>{ testLead1, testLead2 };
                
                // Call the method to test
                List<Lead> leads = SOQL.getAllLeads();
                
                // Assert that the number of leads returned is correct
                System.assertEquals(2, leads.size(), 'Number of leads returned is incorrect.');
                
                // Assert that the leads returned have the correct names
                Set<String> leadNames = new Set<String>{ 'Test Lead 1', 'Test Lead 2' };
                for (Lead lead : leads) {
                    System.assert(leadNames.contains(lead.LastName), 'Lead name is incorrect.');
                    System.assert(lead.Company != null, 'Lead company is null.');
                    System.assert(lead.Phone != null, 'Lead phone is null.');
                    System.assert(lead.Email != null, 'Lead email is null.');
                }
            }
            @IsTest
            static void testGetContactsByFirstName() {
                // Create test data
                Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@email.com', Phone = '1234567890');
                Contact testContact2 = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'john.smith@email.com', Phone = '0987654321');
                Contact testContact3 = new Contact(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@email.com', Phone = '1122334455');
                insert new List<Contact>{ testContact1, testContact2, testContact3 };
                
                // Call the method to test
                List<Contact> contacts = SOQL.getContactsByFirstName();
                
                // Assert that the number of contacts returned is correct
                System.assertEquals(2, contacts.size(), 'Number of contacts returned is incorrect.');
                
                // Assert that the contacts returned have the correct names
                Set<String> contactNames = new Set<String>{ 'John Doe', 'John Smith' };
                for (Contact contact : contacts) {
                    String fullName = contact.FirstName + ' ' + contact.LastName;
                    System.assert(contactNames.contains(fullName), 'Contact name is incorrect.');
                    System.assert(contact.Email != null, 'Contact email should not be null.');
                    System.assert(contact.Phone != null, 'Contact phone should not be null.');
                }
            }
            @IsTest
            static void testGetContactIdsByLastName() {
                // Create test data
                Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Smith');
                Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Jones');
                Contact testContact3 = new Contact(FirstName = 'Jack', LastName = 'Doe');
                insert new List<Contact>{ testContact1, testContact2, testContact3 };
                
                // Call the method to test
                List<Id> contactIds = SOQL.getContactIdsByLastName();
                
                // Assert that the number of contact IDs returned is correct
                System.assertEquals(2, contactIds.size(), 'Number of contact IDs returned is incorrect.');
                
                // Assert that the contact IDs returned are correct
                Set<Id> expectedContactIds = new Set<Id>{ testContact1.Id, testContact2.Id };
                System.assertEquals(expectedContactIds, new Set<Id>(contactIds), 'Returned contact IDs are incorrect.');
            }
            @IsTest
            static void testGetClosedWonOpportunityCountByAccount() {
                // Create test data
                Account testAccount = new Account(Name = 'Test Account');
                insert testAccount;
                
                Opportunity testOpportunity1 = new Opportunity(
                    Name = 'Test Opportunity 1',
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                AccountId = testAccount.Id,
                Amount = 1000
                    );
                Opportunity testOpportunity2 = new Opportunity(
                    Name = 'Test Opportunity 2',
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                AccountId = testAccount.Id,
                Amount = 2000
                    );
                Opportunity testOpportunity3 = new Opportunity(
                    Name = 'Test Opportunity 3',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount.Id,
                Amount = 3000
                    );
                insert new List<Opportunity>{ testOpportunity1, testOpportunity2, testOpportunity3 };
                
                // Call the method to test
                List<Opportunity> opportunities = SOQL.getClosedWonOpportunitiesByAccount(testAccount.Id);
                
                // Assert that the number of opportunities returned is correct
                System.assertEquals(2, opportunities.size(), 'Number of opportunities returned is incorrect.');
                
                // Assert that the opportunities returned have the correct names and stages
                Set<String> opportunityNames = new Set<String>{ 'Test Opportunity 1', 'Test Opportunity 2' };
                for (Opportunity opp : opportunities) {
                    System.assert(opportunityNames.contains(opp.Name), 'Opportunity name is incorrect.');
                    System.assertEquals('Closed Won', opp.StageName, 'Opportunity stage is not Closed Won.');
                    System.assertEquals(testAccount.Id, opp.AccountId, 'Opportunity AccountId is incorrect.');
                    System.assert(opp.CloseDate != null, 'Opportunity CloseDate is null.');
                    System.assert(opp.Amount != null, 'Opportunity Amount is null.');
                }
            }
            @IsTest
            static void testGetAccountCount() {
                // Generate a random number of test accounts between 1 and 10
                Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 1;
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < numAccounts; i++) {
                    accounts.add(new Account(Name = 'Test Account ' + i));
                }
                insert accounts;
                
                // Call the method to test
                Integer accountCount = SOQL.getAccountCount();
                
                // Assert that the number of accounts returned is correct
                System.assertEquals(numAccounts, accountCount, 'Number of accounts returned is incorrect.');
            }
            @IsTest
            static void testGetTasksDueNextWeek() {
                // Create test data
                Task testTask1 = new Task(Subject = 'Test Task 1', ActivityDate = Date.today().addDays(7)); // due in 7 days
                Task testTask2 = new Task(Subject = 'Test Task 2', ActivityDate = Date.today().addDays(10)); // due in 10 days, should not be returned
                Task testTask3 = new Task(Subject = 'Test Task 3', ActivityDate = Date.today().addDays(2)); // due in 2 days
                Task testTask4 = new Task(Subject = 'Test Task 4', ActivityDate = Date.today().addDays(14)); // due in 14 days, should not be returned
                Task testTask5 = new Task(Subject = 'Test Task 5', ActivityDate = Date.today().addDays(-5)); // due in the past, should not be returned
                insert new List<Task>{ testTask1, testTask2, testTask3, testTask4, testTask5 };
                
                // Call the method to test
                Map<Id, Task> tasks = SOQL.getTasksDueNextWeek();
                
                // Assert that the number of tasks returned is correct
                System.assertEquals(2, tasks.size(), 'Number of tasks returned is incorrect.');
                
                // Assert that the tasks returned are the correct ones
                Set<Id> expectedTaskIds = new Set<Id>{ testTask1.Id, testTask3.Id };
                System.assertEquals(expectedTaskIds, tasks.keySet(), 'Returned tasks are incorrect.');
                
                // Additional assertions to verify task details
                for (Task task : tasks.values()) {
                    System.assert(task.Subject != null, 'Task Subject should not be null.');
                    System.assert(task.ActivityDate != null, 'Task ActivityDate should not be null.');
                    System.assert(
                        task.ActivityDate >= Date.today() && task.ActivityDate <= Date.today().addDays(7),
                    'Task ActivityDate is outside the expected range.'
                        );
                }
            }
            @IsTest
            static void testGetContactsByEmailDomain() {
                // Create test data
                Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john@example.com');
                Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', Email = 'jane@example.com');
                Contact testContact3 = new Contact(FirstName = 'Jack', LastName = 'Brown', Email = 'jack@other.com');
                insert new List<Contact>{ testContact1, testContact2, testContact3 };
                
                // Call the method to test
                List<Contact> contacts = SOQL.getContactsByEmailDomain();
                
                // Assert that the number of contacts returned is correct
                System.assertEquals(2, contacts.size(), 'Number of contacts returned is incorrect.');
                
                // Assert that the contacts returned have the correct names and email domains
                Set<String> contactNames = new Set<String>{ 'John Doe', 'Jane Smith' };
                for (Contact contact : contacts) {
                    String fullName = contact.FirstName + ' ' + contact.LastName;
                    System.assert(contactNames.contains(fullName), 'Contact name is incorrect.');
                    System.assert(contact.Email.contains('example.com'), 'Contact email domain is incorrect.');
                }
            }
            @IsTest
            static void testGetOpportunitiesByNameKeyword() {
                // Create test data
                Account testAccount = new Account(Name = 'Test Account');
                insert testAccount;
                
                Opportunity testOpportunity1 = new Opportunity(
                    Name = 'Test Opportunity 1',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount.Id
                    );
                Opportunity testOpportunity2 = new Opportunity(
                    Name = 'Keyword Opportunity',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount.Id
                    );
                Opportunity testOpportunity3 = new Opportunity(
                    Name = 'Test Opportunity 3',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount.Id
                    );
                insert new List<Opportunity>{ testOpportunity1, testOpportunity2, testOpportunity3 };
                
                // Test 1: Search for 'Keyword'
                List<Opportunity> opportunities = SOQL.getOpportunitiesByNameKeyword('Keyword');
                System.assertEquals(1, opportunities.size(), 'Number of opportunities returned is incorrect.');
                System.assertEquals('Keyword Opportunity', opportunities[0].Name, 'Opportunity name is incorrect.');
                
                // Test 2: Search for 'Test'
                opportunities = SOQL.getOpportunitiesByNameKeyword('Test');
                System.assertEquals(2, opportunities.size(), 'Number of opportunities returned is incorrect.');
                Set<String> expectedNames = new Set<String>{ 'Test Opportunity 1', 'Test Opportunity 3' };
                for (Opportunity opp : opportunities) {
                    System.assert(expectedNames.contains(opp.Name), 'Unexpected Opportunity name: ' + opp.Name);
                }
                
                // Test 3: Search for 'Supra' (no results expected)
                opportunities = SOQL.getOpportunitiesByNameKeyword('Supra');
                System.assertEquals(0, opportunities.size(), 'Number of opportunities returned is incorrect.');
                
                // Test 4: Search with null keyword (no results expected)
                try {
                    opportunities = SOQL.getOpportunitiesByNameKeyword(null);
                    System.assertEquals(0, opportunities.size(), 'Number of opportunities returned is incorrect.');
                } catch (Exception e) {
                    System.assert(false, 'Method threw an unexpected exception for null keyword: ' + e.getMessage());
                }
            }
            @IsTest
            static void testGetFilterCaseOrigins() {
                // Create test data
                Account testAccount = new Account(Name = 'Test Account');
                insert testAccount;
                
                // Create Cases with various origins
                Case testCase1 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Phone'); // Valid
                Case testCase2 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Email'); // Invalid
                Case testCase3 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Web');   // Invalid
                Case testCase4 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = '');      // Invalid
                insert new List<Case>{ testCase1, testCase2, testCase3, testCase4 };
                
                // Call the method to test
                List<Case> cases = SOQL.getFilterCaseOrigins();
                
                // Assert that the number of cases returned is correct
                System.assertEquals(1, cases.size(), 'Number of cases returned is incorrect.');
                
                // Assert that the cases returned have the correct Origin
                Set<Id> expectedCaseIds = new Set<Id>{ testCase1.Id }; // Only testCase1 is valid
                for (Case cs : cases) {
                    System.assert(expectedCaseIds.contains(cs.Id), 'Returned Case Id is not expected.');
                    System.assert(cs.Origin != null && cs.Origin != 'Web' && cs.Origin != 'Email', 'Case Origin is incorrect.');
                }
            }
            @IsTest
            static void testGetLeadsBySourceOrTitle() {
                // Create test data
                Lead testLead1 = new Lead(
                    LastName = 'Test Lead 1',
                Company = 'Test Company 1',
                Phone = '1234567890',
                Email = 'lead1@email.com',
                LeadSource = 'Web',
                Title = 'Manager'
                    );
                Lead testLead2 = new Lead(
                    LastName = 'Test Lead 2',
                Company = 'Test Company 2',
                Phone = '0987654321',
                Email = 'lead2@email.com',
                LeadSource = 'Phone',
                Title = 'Engineer Lead'
                    );
                Lead testLead3 = new Lead(
                    LastName = 'Test Lead 3',
                Company = 'Test Company 3',
                Phone = '1234567890',
                Email = 'lead3@email.com',
                LeadSource = 'Email',
                Title = 'Director'
                    );
                Lead testLead4 = new Lead(
                    LastName = 'Test Lead 4',
                Company = 'Test Company 4',
                Phone = '0987654321',
                Email = 'lead4@email.com',
                LeadSource = 'Web',
                Title = 'Sr Engineer'
                    );
                Lead testLead5 = new Lead(
                    LastName = 'Test Lead 5',
                Company = 'Test Company 5',
                Phone = '1234567890',
                Email = '',
                LeadSource = '',
                Title = ''
                    );
                insert new List<Lead>{ testLead1, testLead2, testLead3, testLead4 };
                
                // Call the method to test with 'Web' as Lead Source and 'Engineer' as keyword in Title
                List<Lead> leads = SOQL.getLeadsBySourceOrTitle('Web', 'Engineer');
                
                // Assert that the number of leads returned is correct
                System.assertEquals(3, leads.size(), 'Number of leads returned is incorrect.');
                
                // Assert that the leads returned have the correct LastName
                Set<String> leadNames = new Set<String>{ 'Test Lead 1', 'Test Lead 2', 'Test Lead 4' };
                for (Lead lead : leads) {
                    System.assert(leadNames.contains(lead.LastName), 'Lead name is incorrect.');
                    System.assert(lead.Company != null, 'Lead company is null.');
                    System.assert(lead.Phone != null, 'Lead phone is null.');
                    System.assert(lead.Email != null, 'Lead email is null.');
                }
                
                // Additional test case: Search with keyword 'Director'
                leads = SOQL.getLeadsBySourceOrTitle('Email', 'Director');
                System.assertEquals(1, leads.size(), 'Number of leads returned for "Director" is incorrect.');
                System.assertEquals('Test Lead 3', leads[0].LastName, 'Lead name for "Director" is incorrect.');
                
                // Additional test case: Search with no matches
                leads = SOQL.getLeadsBySourceOrTitle('NonExistentSource', 'NonExistentKeyword');
                System.assertEquals(0, leads.size(), 'No leads should be returned for nonexistent source and keyword.');
            }
            @IsTest
            static void testGetContactNamesByAccount() {
                // Create test data
                // Generate random number of accounts between 1 and 10
                Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 1;
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < numAccounts; i++) {
                    accounts.add(new Account(Name = 'Test Account ' + i));
                }
                insert accounts;
                
                // Create contacts for each account
                List<Contact> contacts = new List<Contact>();
                Map<Id, List<Contact>> accountContacts = new Map<Id, List<Contact>>();
                
                for (Account acc : accounts) {
                    Integer numContacts = (Integer) Math.floor(Math.random() * 10) + 1;
                    List<Contact> tempContList = new List<Contact>();
                    for (Integer i = 0; i < numContacts; i++) {
                        Contact newContact = new Contact(LastName = 'Test Contact ' + i, AccountId = acc.Id);
                        tempContList.add(newContact);
                        contacts.add(newContact);
                    }
                    accountContacts.put(acc.Id, tempContList);
                }
                insert contacts;
                
                // Pick a random account to test
                Account testAccount = accounts[(Integer) Math.floor(Math.random() * accounts.size())];
                
                // Call the method to test
                List<String> contactNames = SOQL.getContactNamesByAccount(testAccount.Id);
                
                // Assert that the number of contact names returned is correct
                System.assertEquals(
                    accountContacts.get(testAccount.Id).size(),
                contactNames.size(),
                'Number of contact names returned is incorrect.'
                    );
                
                // Assert that the contact names returned are correct
                Set<String> expectedNames = new Set<String>();
                for (Contact cont : accountContacts.get(testAccount.Id)) {
                    expectedNames.add(cont.LastName);
                }
                
                for (String returnedName : contactNames) {
                    System.assert(expectedNames.contains(returnedName), 'Returned contact name is not expected: ' + returnedName);
                }
            }
            @IsTest
            static void testGetTotalRevenueByStage() {
                // Create test data
                Opportunity testOpp1 = new Opportunity(
                    Name = 'Test Opportunity 1',
                StageName = 'Prospecting',
                Amount = 5000,
                CloseDate = Date.today()
                    );
                Opportunity testOpp2 = new Opportunity(
                    Name = 'Test Opportunity 2',
                StageName = 'Closed Won',
                Amount = 20000,
                CloseDate = Date.today()
                    );
                Opportunity testOpp3 = new Opportunity(
                    Name = 'Test Opportunity 3',
                StageName = 'Closed Lost',
                Amount = 15000,
                CloseDate = Date.today()
                    );
                Opportunity testOpp4 = new Opportunity(
                    Name = 'Test Opportunity 4',
                StageName = 'Closed Won',
                Amount = 10000,
                CloseDate = Date.today()
                    );
                insert new List<Opportunity>{ testOpp1, testOpp2, testOpp3, testOpp4 };
                
                // Call the method to test
                Decimal totalRevenue = SOQL.getTotalRevenueByStage('Closed Won');
                
                // Calculate the expected revenue
                Decimal expectedRevenue = testOpp2.Amount + testOpp4.Amount + testOpp3.Amount;
                
                // Assert that the total revenue returned is correct
                System.assertEquals(expectedRevenue, totalRevenue, 'Total revenue is incorrect.');
                
                // Additional Test: Validate with a different stage
                Decimal otherStageRevenue = SOQL.getTotalRevenueByStage('Prospecting');
                System.assertEquals(testOpp1.Amount, otherStageRevenue, 'Revenue for Prospecting is incorrect.');
                
                // Additional Test: Validate with a stage not in the dataset
                Decimal noStageRevenue = SOQL.getTotalRevenueByStage('NonExistentStage');
                System.assertEquals(0, noStageRevenue, 'Revenue for nonexistent stage should be 0.');
            }
            @IsTest
            static void testGetFirstTenAccounts() {
                // Create test data
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < 15; i++) {
                    accounts.add(new Account(Name = 'Test Account ' + i));
                }
                insert accounts;
                
                // Call the method to test
                List<Account> returnedAccounts = SOQL.getFirstTenAccounts();
                
                // Assert that the number of accounts returned is correct
                System.assertEquals(10, returnedAccounts.size(), 'Number of accounts returned is incorrect.');
                
                // Assert that the accounts returned are ordered correctly by Name
                for (Integer i = 0; i < returnedAccounts.size() - 1; i++) {
                    System.assert(
                        returnedAccounts[i].Name.compareTo(returnedAccounts[i + 1].Name) <= 0,
                    'Accounts are not ordered correctly.'
                        );
                }
                
                // Additional validation: Ensure the first returned account is the one with the lexicographically smallest name
                List<Account> allAccountsOrdered = [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 10];
                for (Integer i = 0; i < returnedAccounts.size(); i++) {
                    System.assertEquals(
                        allAccountsOrdered[i].Name,
                    returnedAccounts[i].Name,
                    'Returned account name does not match the expected account order.'
                        );
                }
            }
            @IsTest
            static void testGetHighValueOpportunities() {
                // Create test data
                Account testAccount = new Account(Name = 'Test Account');
                insert testAccount;
                
                List<Opportunity> opportunities = new List<Opportunity>();
                for (Integer i = 0; i < 10; i++) {
                    opportunities.add(
                        new Opportunity(
                        Name = 'Test Opportunity ' + i,
                    AccountId = testAccount.Id,
                    CloseDate = System.today().addDays(i),
                    StageName = 'Prospecting',
                    Amount = 100000 * (i + 1) // Amounts: 100,000 to 1,000,000
                        )
                        );
                }
                insert opportunities;
                
                // Call the method to test
                List<Opportunity> returnedOpportunities = SOQL.getHighValueOpportunities();
                
                // Assert that the number of opportunities returned is correct
                System.assertEquals(5, returnedOpportunities.size(), 'Number of opportunities returned is incorrect.');
                
                // Assert that the opportunities returned are ordered correctly by CloseDate
                for (Integer i = 0; i < returnedOpportunities.size() - 1; i++) {
                    System.assert(
                        returnedOpportunities[i].CloseDate <= returnedOpportunities[i + 1].CloseDate,
                    'Opportunities are not ordered correctly by CloseDate.'
                        );
                }
                
                // Assert that all returned opportunities have Amount > 100,000
                for (Opportunity opp : returnedOpportunities) {
                    System.assert(opp.Amount > 100000, 'Opportunity amount is less than 100,000.');
                }
                
                // Additional validation: Ensure the returned opportunities match the expected top 5
                List<Opportunity> expectedOpportunities = [SELECT Id, Name, Amount, CloseDate 
                                                    FROM Opportunity 
                                                    WHERE Amount > 100000 
                                                    ORDER BY CloseDate ASC 
                                                    LIMIT 5];
                System.assertEquals(expectedOpportunities.size(), returnedOpportunities.size(),
                'Returned opportunities do not match the expected count.');
                for (Integer i = 0; i < returnedOpportunities.size(); i++) {
                    System.assertEquals(expectedOpportunities[i].Id, returnedOpportunities[i].Id,
                    'Returned opportunity does not match expected opportunity.');
                }
            }
            @IsTest
            static void testGetBirthdateContacts() {
                // Create test data
                List<Contact> contacts = new List<Contact>();
                for (Integer i = 0; i < 10; i++) {
                    contacts.add(
                        new Contact(
                        LastName = 'Test Contact ' + i,
                    Birthdate = Date.today().addDays(-i) // Birthdates from today to 9 days ago
                        )
                        );
                }
                insert contacts;
                
                // Call the method to test
                List<Contact> returnedContacts = SOQL.getBirthdateContacts();
                
                // Assert that the number of contacts returned is correct
                System.assertEquals(3, returnedContacts.size(), 'Number of contacts returned is incorrect.');
                
                // Assert that the contacts returned are ordered correctly by Birthdate in descending order
                for (Integer i = 0; i < returnedContacts.size() - 1; i++) {
                    System.assert(
                        returnedContacts[i].Birthdate >= returnedContacts[i + 1].Birthdate,
                    'Contacts are not ordered correctly by Birthdate.'
                        );
                }
                
                // Additional validation: Ensure the returned contacts match the top 3 most recent Birthdates
                List<Contact> expectedContacts = [SELECT Id, LastName, Birthdate 
												   FROM Contact 
												   ORDER BY Birthdate DESC 
												   LIMIT 3];
                System.assertEquals(expectedContacts.size(), returnedContacts.size(),
                'Returned contacts do not match the expected count.');
                for (Integer i = 0; i < returnedContacts.size(); i++) {
                    System.assertEquals(expectedContacts[i].Id, returnedContacts[i].Id,
                    'Returned contact does not match expected contact.');
                }
            }
            @IsTest
            static void testGetCasesWithStatus() {
                // Create test data
                List<Case> cases = new List<Case>();
                for (Integer i = 0; i < 20; i++) {
                    cases.add(
                        new Case(
                        Subject = 'Test Case ' + i,
                    Status = 'Open'
                        // Assume that Cases are created in order, so the CreatedDate will be in ascending order
                    )
                        );
                }
                insert cases;
                
                // Call the method to test
                List<Case> returnedCases = SOQL.getCasesWithStatus();
                
                // Assert that the number of cases returned is correct
                System.assertEquals(10, returnedCases.size(), 'Number of cases returned is incorrect.');
                
                // Assert that the cases returned are ordered correctly by CreatedDate
                for (Integer i = 0; i < returnedCases.size() - 1; i++) {
                    System.assert(
                        returnedCases[i].CreatedDate <= returnedCases[i + 1].CreatedDate,
                    'Cases are not ordered correctly by CreatedDate.'
                        );
                }
                
                // Additional validation: Ensure the returned cases match the expected offset and limit
                List<Case> expectedCases = [SELECT Id, Subject, CreatedDate 
												 FROM Case 
												 WHERE Status = 'Open' 
												 ORDER BY CreatedDate ASC 
												 LIMIT 10 OFFSET 5];
                
                System.assertEquals(expectedCases.size(), returnedCases.size(),
                'Returned cases do not match the expected count.');
                for (Integer i = 0; i < returnedCases.size(); i++) {
                    System.assertEquals(expectedCases[i].Id, returnedCases[i].Id,
                    'Returned case does not match the expected case at index ' + i);
                }
                
                // Assert that the first returned case matches the 6th created case
                System.assertEquals(cases[5].Id, returnedCases[0].Id, 'First case returned is not the 6th case created.');
            }
            @IsTest
            static void testGetCaseIdsByAccount() {
                // Create test data
                // Generate random number of accounts and cases between 1 and 10
                Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 1;
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < numAccounts; i++) {
                    accounts.add(new Account(Name = 'Test Account ' + i));
                }
                insert accounts;
                
                List<Case> cases = new List<Case>();
                Map<Id, List<Case>> accountCases = new Map<Id, List<Case>>();
                for (Account acc : accounts) {
                    Integer numCases = (Integer) Math.floor(Math.random() * 10) + 1;
                    List<Case> tempCaseList = new List<Case>();
                    for (Integer i = 0; i < numCases; i++) {
                        tempCaseList.add(new Case(Subject = 'Test Case ' + i, AccountId = acc.Id, Status = 'Open'));
                    }
                    accountCases.put(acc.Id, tempCaseList);
                    cases.addAll(tempCaseList);
                }
                insert cases;
                
                // Call the method to test
                Account testAccount = accounts[(Integer) Math.floor(Math.random() * accounts.size())];
                Set<Id> caseIds = SOQL.getCaseIdsByAccount(testAccount.Id);
                
                // Assert that the number of case IDs returned is correct
                System.assertEquals(
                    accountCases.get(testAccount.Id).size(),
                caseIds.size(),
                'Number of case IDs returned is incorrect.'
                    );
                
                // Assert that the case IDs returned are correct
                try {
                    for (Case caseObj : accountCases.get(testAccount.Id)) {
                        System.assert(caseIds.contains(caseObj.Id), 'Case ID is incorrect.');
                    }
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
            }
            @IsTest
            static void testGetAccountIdsToNamesNotInCountry() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1', BillingCountry = 'United States');
                Account testAccount2 = new Account(Name = 'Test Account 2', BillingCountry = 'Canada');
                Account testAccount3 = new Account(Name = 'Test Account 3', BillingCountry = 'United Kingdom');
                insert new List<Account>{ testAccount1, testAccount2, testAccount3 };
                
                // Call the method to test
                Map<Id, String> accountIdsToNames = SOQL.getAccountIdsToNamesNotInCountry('Canada');
                
                // Assert that the number of accounts returned is correct
                System.assertEquals(2, accountIdsToNames.size(), 'Number of accounts returned is incorrect.');
                
                // Assert that the accounts returned are correct
                try {
                    System.assert(accountIdsToNames.containsKey(testAccount1.Id), 'Test Account 1 is not in the result set.');
                    System.assert(accountIdsToNames.containsKey(testAccount3.Id), 'Test Account 3 is not in the result set.');
                    System.assert(!accountIdsToNames.containsKey(testAccount2.Id), 'Test Account 2 is in the result set.');
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
                
                // Additional validation: Assert that the names in the map match the expected names
                System.assertEquals(
                    'Test Account 1',
                accountIdsToNames.get(testAccount1.Id),
                'Name for Test Account 1 does not match.'
                    );
                System.assertEquals(
                    'Test Account 3',
                accountIdsToNames.get(testAccount3.Id),
                'Name for Test Account 3 does not match.'
                    );
            }
            @IsTest
            static void testGetAccountNameForContact() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1');
                insert testAccount1;
                
                
                Contact testContact1 = new Contact(LastName = 'Test Contact 1', AccountId = testAccount1.Id);
                insert testContact1;
                
                
                // Call the method to test
                String accountName = SOQL.getAccountNameForContact(testContact1.Id);
                
                
                // Assert that the returned account name is correct
                System.assertEquals('Test Account 1', accountName, 'Returned account name is incorrect.');
            }
            @IsTest
            static void testGetAccountAndOpportunitiesFromAccountId() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1');
                insert testAccount1;
                
                
                Opportunity testOpp1 = new Opportunity(
                    Name = 'Test Opp 1',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                Opportunity testOpp2 = new Opportunity(
                    Name = 'Test Opp 2',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                insert new List<Opportunity>{ testOpp1, testOpp2 };
                
                
                // Call the method to test
                Account accountWithOpps = SOQL.getAccountAndOpportunitiesFromAccountId(testAccount1.Id);
                
                
                // Assert that the returned account is correct
                System.assertEquals(testAccount1.Id, accountWithOpps.Id, 'Returned account is incorrect.');
                
                
                // Assert that the returned account has the correct opportunities
                System.assertEquals(2, accountWithOpps.Opportunities.size(), 'Number of opportunities is incorrect.');
                Set<String> oppNames = new Set<String>{ 'Test Opp 1', 'Test Opp 2' };
                try {
                    for (Opportunity opp : accountWithOpps.Opportunities) {
                        System.assert(oppNames.contains(opp.Name), 'Opportunity name is incorrect.');
                    }
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
            }
            @IsTest
            static void testGetAccountAndOpportunitiesFromAccountId() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1');
                insert testAccount1;
                
                Opportunity testOpp1 = new Opportunity(
                    Name = 'Test Opp 1',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                Opportunity testOpp2 = new Opportunity(
                    Name = 'Test Opp 2',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                insert new List<Opportunity>{ testOpp1, testOpp2 };
                
                // Call the method to test
                Account accountWithOpps = SOQL.getAccountAndOpportunitiesFromAccountId(testAccount1.Id);
                
                // Assert that the returned account is correct
                System.assertNotNull(accountWithOpps, 'Returned account is null.');
                System.assertEquals(testAccount1.Id, accountWithOpps.Id, 'Returned account ID is incorrect.');
                System.assertEquals(testAccount1.Name, accountWithOpps.Name, 'Returned account name is incorrect.');
                
                // Assert that the related opportunities are correct
                System.assertEquals(2, accountWithOpps.Opportunities.size(), 'Number of related opportunities is incorrect.');
                Set<String> oppNames = new Set<String>{ 'Test Opp 1', 'Test Opp 2' };
                try {
                    for (Opportunity opp : accountWithOpps.Opportunities) {
                        System.assert(oppNames.contains(opp.Name), 'Opportunity name is incorrect.');
                    }
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
            }
            @IsTest
            static void testGetAccountsWithContactsByState() {
                // Create test data
                // Generate random number of accounts and contacts between 1 and 10
                Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 1;
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < numAccounts; i++) {
                    String billingState = Math.mod(i, 2) == 0 ? 'CA' : 'NY';
                    accounts.add(new Account(Name = 'Test Account ' + i, BillingState = billingState));
                }
                
                insert accounts;
                
                List<Contact> contacts = new List<Contact>();
                Map<Id, List<Contact>> accountContactsMap = new Map<Id, List<Contact>>();
                
                for (Account acc : accounts) {
                    Integer numContacts = (Integer) Math.floor(Math.random() * 10) + 1;
                    List<Contact> tempContactList = new List<Contact>();
                    for (Integer j = 0; j < numContacts; j++) {
                        String mailingState = Math.mod(j, 2) == 0 ? 'CA' : 'NY';
                        Contact contact = new Contact(
                            LastName = 'Test Contact ' + j,
                        AccountId = acc.Id,
                        MailingState = mailingState
                            );
                        tempContactList.add(contact);
                        
                        // Track contacts per account
                        if (acc.BillingState == mailingState) {
                            if (!accountContactsMap.containsKey(acc.Id)) {
                                accountContactsMap.put(acc.Id, new List<Contact>());
                            }
                            accountContactsMap.get(acc.Id).add(contact);
                        }
                    }
                    contacts.addAll(tempContactList);
                }
                
                insert contacts;
                
                // Select a random test account
                Account testAccount = accounts[(Integer) Math.floor(Math.random() * accounts.size())];
                
                // Call the method to test
                List<Contact> contactsByState = SOQL.getAccountsWithContactsByState(testAccount.Id);
                
                // Assert that the number of contacts returned is correct
                Integer expectedContacts = accountContactsMap.containsKey(testAccount.Id)
                    ? accountContactsMap.get(testAccount.Id).size()
                    : 0;
                System.assertEquals(
                    expectedContacts,
                contactsByState.size(),
                'Number of contacts returned is incorrect.'
                    );
                
                // Assert that the contacts returned have the correct MailingState
                try {
                    for (Contact contact : contactsByState) {
                        System.assertEquals(
                            testAccount.BillingState,
                        contact.MailingState,
                        'Contact MailingState does not match the Account BillingState.'
                            );
                    }
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
            }
            @IsTest
            static void testFindAccountsByLeadEmailDomains() {
                // Create test data
                // Generate random number of leads between 1 and 10
                List<String> domains = new List<String>{ 'example.com', 'test.com', 'other.com' };
                
                Integer numLeads = 10;
                List<Lead> leads = new List<Lead>();
                for (Integer i = 0; i < numLeads; i++) {
                    String email = 'test' + i + '@' + domains[(Integer) Math.floor(Math.random() * domains.size())];
                    leads.add(new Lead(Email = email, LastName = 'Test Lead ' + i, Company = 'Test Company ' + i));
                }
                
                insert leads;
                
                // Create test accounts
                Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 3;
                Map<String, List<Account>> domainToAccount = new Map<String, List<Account>>();
                List<Account> accounts = new List<Account>();
                for (Integer i = 0; i < numAccounts; i++) {
                    String domain;
                    Integer domainIndex = Math.mod(i, domains.size());
                    if (domainIndex == 0) {
                        domain = domains[0];
                    } else if (domainIndex == 1) {
                        domain = domains[1];
                    } else {
                        domain = domains[2];
                    }
                    String website = 'www.' + domain;
                    Account account = new Account(Name = 'Test Account ' + i, Website = website);
                    accounts.add(account);
                    
                    if (!domainToAccount.containsKey(domain)) {
                        domainToAccount.put(domain, new List<Account>());
                    }
                    domainToAccount.get(domain).add(account);
                }
                
                insert accounts;
                
                // Pick a random test Lead and extract its domain
                Lead testLead = leads[(Integer) Math.floor(Math.random() * leads.size())];
                String testLeadDomain = testLead.Email.split('@')[1];
                Set<Id> leadIds = new Set<Id>{ testLead.Id };
                
                // Call the method to test
                List<Account> matchedAccounts = SOQL.findAccountsByLeadEmailDomains(leadIds);
                
                // Debugging information (optional for development/testing purposes)
                System.debug('Test Lead Domain: ' + testLeadDomain);
                System.debug('Accounts in Salesforce: ' + [SELECT Id, Website FROM Account]);
                System.debug('Expected Accounts: ' + domainToAccount.get(testLeadDomain));
                
                // Assert that the number of matched accounts is correct
                Integer expectedAccountCount = domainToAccount.containsKey(testLeadDomain)
                    ? domainToAccount.get(testLeadDomain).size()
                    : 0;
                System.assertEquals(
                    expectedAccountCount,
                matchedAccounts.size(),
                'Number of matched accounts is incorrect.'
                    );
                
                // Assert that the matched accounts have the correct website domain
                for (Account acc : matchedAccounts) {
                    Boolean accountFound = false;
                    for (Account expectedAccount : domainToAccount.get(testLeadDomain)) {
                        if (acc.Id == expectedAccount.Id) {
                            accountFound = true;
                            System.assertEquals(
                                expectedAccount.Website,
                            acc.Website,
                            'Account website domain is incorrect.'
                                );
                            break;
                        }
                    }
                    Assert.isTrue(accountFound, 'Account not found in the matched accounts list.');
                }
            }
            @IsTest
            static void testCloneLineItems() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1');
                insert testAccount1;
                
                // Create Opportunities
                Opportunity testOpp1 = new Opportunity(
                    Name = 'Test Opp 1',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                Opportunity testOpp2 = new Opportunity(
                    Name = 'Test Opp 2',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                insert new List<Opportunity>{ testOpp1, testOpp2 };
                
                // Insert Product
                Product2 testProduct = new Product2(
                    Name = 'Test Product',
                Description = 'Test Product Entry For Product',
                ProductCode = 'SFDCPanther-123',
                IsActive = true
                    );
                insert testProduct;
                
                // Insert Pricebook Entry
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = testProduct.Id,
                UnitPrice = 100,
                IsActive = true
                    );
                insert standardPrice;
                
                // Insert Opportunity Line Item for the first Opportunity
                OpportunityLineItem testLineItem = new OpportunityLineItem(
                    OpportunityId = testOpp1.Id,
                Quantity = 5,
                PricebookEntryId = standardPrice.Id,
                TotalPrice = 500
                    );
                insert testLineItem;
                
                // Call the method to test
                SOQL.cloneLineItems(testOpp1.Id, new List<Id>{ testOpp2.Id });
                
                // Query for the cloned line items
                List<OpportunityLineItem> clonedLineItems = [
									SELECT Id, Quantity, UnitPrice, OpportunityId
									FROM OpportunityLineItem
									WHERE OpportunityId = :testOpp2.Id
								];
                
                // Assert that the cloned line items match expectations
                System.assertEquals(1, clonedLineItems.size(), 'Number of cloned line items is incorrect.');
                
                // Verify that the UnitPrice matches the original
                System.assertEquals(100, clonedLineItems[0].UnitPrice, 'Cloned line item UnitPrice is incorrect.');
                
                // Verify that the Quantity is within the correct randomized range (original + 1-3)
                Integer minQuantity = testLineItem.Quantity + 1;
                Integer maxQuantity = testLineItem.Quantity + 3;
                System.assert(
                    clonedLineItems[0].Quantity >= minQuantity && clonedLineItems[0].Quantity <= maxQuantity,
                'Cloned line item Quantity is outside the randomized range.'
                    );
            }
            @IsTest
            static void testGetOpportunityDetailsForClosedWon() {
                // Create test data
                Account testAccount1 = new Account(Name = 'Test Account 1');
                insert testAccount1;
                
                // Fetch an active user
                User testUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
                
                // Create Opportunities
                Opportunity testOpportunity1 = new Opportunity(
                    Name = 'Test Opportunity 1',
                AccountId = testAccount1.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                OwnerId = testUser.Id
                    );
                Opportunity testOpportunity2 = new Opportunity(
                    Name = 'Test Opportunity 2',
                AccountId = testAccount1.Id,
                StageName = 'Open',
                CloseDate = Date.today(),
                OwnerId = testUser.Id
                    );
                insert new List<Opportunity>{ testOpportunity1, testOpportunity2 };
                
                // Call the method to test
                List<Opportunity> opportunities = SOQL.getOpportunityDetailsForClosedWon();
                
                // Assert that the number of opportunities returned is correct
                System.assertEquals(1, opportunities.size(), 'Number of opportunities returned is incorrect.');
                
                // Assert that the opportunity details returned are correct
                Opportunity returnedOpp = opportunities[0];
                try {
                    System.assertEquals(testOpportunity1.Id, returnedOpp.Id, 'Returned opportunity ID is incorrect.');
                    System.assertEquals(testOpportunity1.Name, returnedOpp.Name, 'Returned opportunity name is incorrect.');
                    System.assertEquals(testAccount1.Name, returnedOpp.Account.Name, 'Returned account name is incorrect.');
                    System.assertEquals(testUser.Name, returnedOpp.Owner.Name, 'Returned owner name is incorrect.');
                } catch (Exception ex) {
                    Assert.fail('Exception thrown: ' + ex.getMessage());
                }
            }
            @IsTest
            static void testSetPrimaryContact() {
                // Step 1: Create test Accounts
                Account testAccount1 = new Account(Name = 'Test Account 1');
                Account testAccount2 = new Account(Name = 'Test Account 2');
                insert new List<Account>{ testAccount1, testAccount2 };
                
                // Step 2: Create test Contacts
                // Ensure contacts for Account 1 have varying first names for sorting
                Contact testContact1 = new Contact(FirstName = 'Zara', LastName = 'Smith', AccountId = testAccount1.Id);
                Contact testContact2 = new Contact(FirstName = 'Aaron', LastName = 'Johnson', AccountId = testAccount1.Id); // Alphabetically first
                Contact testContact3 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = testAccount1.Id);
                
                // Contact for Account 2
                Contact testContact4 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAccount2.Id);
                insert new List<Contact>{ testContact1, testContact2, testContact3, testContact4 };
                
                // Step 3: Create test Opportunities
                Opportunity closedWonOpp = new Opportunity(
                    Name = 'Test Opp 1',
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id
                    );
                Opportunity prospectingOpp = new Opportunity(
                    Name = 'Test Opp 2',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                AccountId = testAccount2.Id
                    );
                insert new List<Opportunity>{ closedWonOpp, prospectingOpp };
                
                // Step 4: Call the method under test
                SOQL.setPrimaryContact();
                
                // Step 5: Query updated Opportunities
                Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
                    [SELECT Id, Primary_Contact__c FROM Opportunity]
                    );
                
                // Step 6: Assert that the 'Primary_Contact__c' field was set correctly for Closed Won Opportunities
                System.assertEquals(
                    testContact2.Id,
                oppMap.get(closedWonOpp.Id).Primary_Contact__c,
                'Primary Contact was not set correctly for the Closed Won Opportunity.'
                    );
                
                // Assert that 'Primary_Contact__c' is null for non-Closed Won Opportunities
                System.assertEquals(
                    null,
                oppMap.get(prospectingOpp.Id).Primary_Contact__c,
                'Primary Contact should not be set for non-Closed Won Opportunity.'
                    );
            }
        }
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
