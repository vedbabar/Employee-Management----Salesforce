# 🏢 Employee Management System — Salesforce

A **menu-driven Employee Management System** built on the Salesforce platform using the **Model-View-Controller (MVC)** architecture. This project covers full CRUD operations via an Apex backend, a Visualforce frontend, and a simulated menu-driven console using Execute Anonymous.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Step 1 — Create the Employee Object](#step-1--create-the-employee-object)
- [Step 2 — Create the Apex Controller (CRUD Logic)](#step-2--create-the-apex-controller-crud-logic)
- [Step 3 — Implementing the Menu](#step-3--implementing-the-menu)
- [Step 4 — Testing & Logs](#step-4--testing--logs)
- [Step 5 — Apex Controller for Visualforce](#step-5--apex-controller-for-visualforce)
- [Step 6 — The Visualforce Page](#step-6--the-visualforce-page)
- [Key Concepts](#key-concepts)
- [Project Structure](#project-structure)

---

## Overview

This project simulates a menu-driven Employee Management System inside Salesforce. Using a numbered `choice` variable in the Execute Anonymous window, users can run ADD, VIEW, UPDATE, and DELETE operations — mimicking the behavior of a traditional console menu without needing `scanf` or `cin`.

---

## Tech Stack

| Layer | Technology |
| :--- | :--- |
| Platform | Salesforce (Developer Org) |
| Backend | Apex Classes |
| Frontend | Visualforce Page |
| Database | Salesforce Custom Object (`Employee__c`) |
| Testing | Execute Anonymous (Developer Console) |

---

## Architecture

```
┌────────────────────────────────────────────┐
│             Visualforce Page               │  ← View (UI)
│          (EmployeeManagement.page)         │
└───────────────────┬────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│           Apex Controller                  │  ← Controller (Logic)
│    (EmployeeManager / EmployeeController)  │
└───────────────────┬────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│         Salesforce Custom Object           │  ← Model (Data)
│              (Employee__c)                 │
└────────────────────────────────────────────┘
```

---

## Step 1 — Create the Employee Object

First, you need a place to store the data. While you could use the standard `Contact` object, creating a Custom Object is better practice for assignments.

### 1.1 Create the Custom Object

1. Go to **Setup** → **Object Manager** → **Create** → **Custom Object**.
2. **Label:** `Employee`
3. **Plural Label:** `Employees`
4. **Record Name:** `Employee ID` (Data Type: `Text` or `Auto-Number`)
5. Click **Save**.

### 1.2 Add Custom Fields

Navigate to **Fields & Relationships** on the `Employee__c` object and create the following:

| Field Label | API Name | Data Type |
| :--- | :--- | :--- |
| Employee Name | `Employee_Name__c` | Text(100) |
| Email | `Email__c` | Email |
| Birth Date | `Birth_Date__c` | Date |
| Department | `Department__c` | Picklist (`IT`, `HR`, `Sales`, `Finance`) |

---

## Step 2 — Create the Apex Controller (CRUD Logic)

This class contains the logic to **Create, Read, Update, and Delete (CRUD)** employee records.

### 2.1 Create the Apex Class

1. Open the **Developer Console** (Gear icon → Developer Console).
2. Go to **File** → **New** → **Apex Class**.
3. Name it: `EmployeeManager`
4. Paste the following code:

```apex
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
```

5. Click **Save** (`Ctrl + S` / `Cmd + S`).

---

## Step 3 — Implementing the Menu

In Salesforce, there is no standard `scanf` or `cin` for real-time console input. To simulate a menu-driven system for an assignment, use a **Switch/If-Else block** in the Execute Anonymous window.

### How to Run

1. Open the **Developer Console**.
2. Press `Ctrl + E` (Windows) or `Cmd + E` (Mac) to open the **Execute Anonymous** window.
3. Paste the following template and **change the `choice` number** to test different operations:

```apex
// --- MENU SELECTION ---
Integer choice = 1; // Change this number to test different features

// Input Data
String name = 'John Doe';
String email = 'john@example.com';
Date dob = Date.newInstance(1995, 05, 20);
String dept = 'IT';
String empIdToTarget = 'EMP-0001'; // Use an actual ID from your records

switch on choice {
    when 1 {
        EmployeeManager.addEmployee(name, email, dob, dept);
    }
    when 2 {
        EmployeeManager.viewEmployees();
    }
    when 3 {
        EmployeeManager.updateDepartment(empIdToTarget, 'HR');
    }
    when 4 {
        EmployeeManager.deleteEmployee(empIdToTarget);
    }
    when else {
        System.debug('Invalid Choice');
    }
}
```

### Menu Reference

| Choice | Operation | Description |
| :---: | :--- | :--- |
| `1` | Add Employee | Inserts a new `Employee__c` record |
| `2` | View All | Queries and prints all employee records |
| `3` | Update Department | Updates the department for a given Employee ID |
| `4` | Delete Employee | Deletes the record matching the given Employee ID |

---

## Step 4 — Testing & Logs

1. After pasting your script, click **Execute** in the Execute Anonymous window.
2. Check the **Open Log** checkbox before executing.
3. In the log viewer, check the **Debug Only** checkbox to filter output.
4. You will see the output of your operations, for example:

```
USER_DEBUG | Employee added successfully! ID: a01XXXXXXXXXXXXXXX
USER_DEBUG | --- Employee List ---
USER_DEBUG | ID: EMP-0001 | Name: John Doe | Dept: IT
```

---

## Step 5 — Apex Controller for Visualforce

This updated controller uses properties (`get; set;`) so the Visualforce page can bind to and interact with the Apex code.

### 5.1 Create the Apex Class

1. In the **Developer Console**, go to **File** → **New** → **Apex Class**.
2. Name it: `EmployeeController`
3. Paste the following:

```apex
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
```

4. Click **Save**.

---

## Step 6 — The Visualforce Page

This page creates a simple input form and a table to display results, acting as your visual "Menu."

### 6.1 Create the Visualforce Page

1. Go to **Setup** → search **Visualforce Pages** → click **New**.
2. **Name:** `EmployeeManagement`
3. Paste the following markup:

```xml
<apex:page controller="EmployeeController">
    <apex:form>
        <apex:pageMessages />
        
        <apex:pageBlock title="Employee Management System">
            <!-- Input Section -->
            <apex:pageBlockSection title="Add New Employee" columns="1">
                <apex:inputField value="{!emp.Employee_Name__c}"/>
                <apex:inputField value="{!emp.Email__c}"/>
                <apex:inputField value="{!emp.Birth_Date__c}"/>
                <apex:inputField value="{!emp.Department__c}"/>
                <apex:commandButton action="{!saveEmployee}" value="Add Employee" reRender="empTable, empFields"/>
            </apex:pageBlockSection>

            <!-- Display Section -->
            <apex:pageBlockSection title="Employee Records" columns="1" id="empTable">
                <apex:pageBlockTable value="{!empList}" var="e">
                    <apex:column value="{!e.Name}"/>
                    <apex:column value="{!e.Employee_Name__c}"/>
                    <apex:column value="{!e.Email__c}"/>
                    <apex:column value="{!e.Department__c}"/>
                </apex:pageBlockTable>
            </apex:pageBlockSection>
        </apex:pageBlock>
    </apex:form>
</apex:page>
```

4. Click **Save**.

### 6.2 Access the Page

Navigate to:
```
https://<your-org-domain>.salesforce.com/apex/EmployeeManagement
```

---

## Key Concepts

| Concept | Description |
| :--- | :--- |
| **SOQL** | `[SELECT ... FROM ...]` — Salesforce Object Query Language used to retrieve records |
| **DML** | `insert`, `update`, `delete` — Data Manipulation Language commands for modifying records |
| **`__c` suffix** | Always appended to API names of custom fields and objects (e.g., `Email__c`, `Employee__c`) |
| **`reRender`** | Refreshes only the specified section of the page without a full reload |
| **`ApexPages.addMessages`** | Displays caught exceptions on the Visualforce page via `<apex:pageMessages />` |

---

## Project Structure

```
salesforce-employee-management/
│
├── classes/
│   ├── EmployeeManager.cls          # Static CRUD methods (used in Execute Anonymous)
│   └── EmployeeController.cls       # Controller bound to the Visualforce page
│
├── pages/
│   └── EmployeeManagement.page      # Visualforce UI — form + records table
│
├── objects/
│   └── Employee__c/
│       └── fields/
│           ├── Employee_Name__c.field-meta.xml
│           ├── Email__c.field-meta.xml
│           ├── Birth_Date__c.field-meta.xml
│           └── Department__c.field-meta.xml
│
└── README.md
```

---

> Built for educational purposes on the Salesforce Platform using Apex MVC.
