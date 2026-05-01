public class EmployeeManager {
    
    // 1. Add Employee
    public static void addEmployee(String name, String email, Date dob, String dept) {
        Employee__c emp = new Employee__c(
            Employee_Name__c = name,
            Email__c = email,
            Birth_Date__c = dob,
            Department__c = dept
        );
        insert emp;
        System.debug('Employee added successfully! ID: ' + emp.Id);
    }

    // 2. View All Employees
    public static void viewEmployees() {
        List<Employee__c> empList = [SELECT Name, Employee_Name__c, Email__c, Department__c FROM Employee__c];
        System.debug('--- Employee List ---');
        for(Employee__c e : empList) {
            System.debug('ID: ' + e.Name + ' | Name: ' + e.Employee_Name__c + ' | Dept: ' + e.Department__c);
        }
    }

    // 3. Update Employee Department
    public static void updateDepartment(String empId, String newDept) {
        Employee__c emp = [SELECT Id FROM Employee__c WHERE Name = :empId LIMIT 1];
        emp.Department__c = newDept;
        update emp;
        System.debug('Department updated for ID: ' + empId);
    }

    // 4. Delete Employee
    public static void deleteEmployee(String empId) {
        Employee__c emp = [SELECT Id FROM Employee__c WHERE Name = :empId LIMIT 1];
        delete emp;
        System.debug('Employee deleted.');
    }
}
