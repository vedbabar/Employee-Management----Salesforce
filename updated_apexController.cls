public class EmployeeController {
    public Employee__c emp {get; set;}
    public List<Employee__c> empList {get; set;}

    public EmployeeController() {
        emp = new Employee__c();
        refreshList();
    }

    public void refreshList() {
        empList = [SELECT Name, Employee_Name__c, Email__c, Department__c, Birth_Date__c 
                   FROM Employee__c ORDER BY CreatedDate DESC];
    }

    public PageReference saveEmployee() {
        try {
            insert emp;
            emp = new Employee__c(); // Clear form
            refreshList();
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
}
