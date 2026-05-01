# 🏢 Employee Management System — Salesforce

A **menu-driven Employee Management System** built on the Salesforce platform using the **Model-View-Controller (MVC)** architecture. This project demonstrates how to create a custom object, build Apex backend logic, design a Visualforce UI, and run console-based tests — all within the Salesforce ecosystem.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Step 1 — Data Model Setup](#step-1--data-model-setup-the-database)
- [Step 2 — Backend Logic (Apex Controller)](#step-2--backend-logic-apex-controller)
- [Step 3 — User Interface (Visualforce Page)](#step-3--user-interface-visualforce-page)
- [Step 4 — Console-Based Testing](#step-4--console-based-testing)
- [Project Structure](#project-structure)
- [Features](#features)
- [Screenshots](#screenshots)
- [License](#license)

---

## Overview

This project implements a fully functional Employee Management System inside Salesforce using:

- A **Custom Object** (`Employee__c`) as the data layer
- An **Apex Controller** (`EmployeeController`) as the business logic layer
- A **Visualforce Page** (`EmployeeManagement`) as the presentation layer
- An **Anonymous Apex Script** for simulating a menu-driven console application

---

## Tech Stack

| Layer | Technology |
| :--- | :--- |
| Platform | Salesforce (any edition with Apex access) |
| Backend | Apex (Salesforce's Java-like language) |
| Frontend | Visualforce Pages |
| Database | Salesforce Custom Object (`Employee__c`) |
| Testing | Execute Anonymous (Developer Console) |

---

## Architecture

```
┌────────────────────────────────────────────┐
│               Visualforce Page             │  ← View (UI)
│           (EmployeeManagement.vfp)         │
└───────────────────┬────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│              Apex Controller               │  ← Controller (Logic)
│           (EmployeeController.cls)         │
└───────────────────┬────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│           Salesforce Custom Object         │  ← Model (Data)
│               (Employee__c)               │
└────────────────────────────────────────────┘
```

---

## Step 1 — Data Model Setup (The Database)

Create the custom object and fields to store employee data.

### 1.1 Create the Custom Object

1. Log in to your Salesforce org.
2. Navigate to **Setup** → search for **Object Manager** → click **Create** → **Custom Object**.
3. Fill in the details:
   - **Label:** `Employee`
   - **Plural Label:** `Employees`
   - **Record Name:** `Employee ID`
   - **Data Type:** `Text`
4. Click **Save**.

### 1.2 Create Custom Fields

Go to **Fields & Relationships** on the `Employee__c` object and add the following fields:

| Field Label | API Name | Data Type | Notes |
| :--- | :--- | :--- | :--- |
| Employee Name | `Employee_Name__c` | Text(100) | Required |
| Email | `Email__c` | Email | — |
| Birth Date | `Birth_Date__c` | Date | — |
| Department | `Department__c` | Picklist | Values: `IT`, `HR`, `Sales`, `Finance` |

> **Tip:** For the `Department__c` picklist, add all four values (`IT`, `HR`, `Sales`, `Finance`) when prompted during field creation.

---

## Step 2 — Backend Logic (Apex Controller)

The Apex Controller acts as the "brain" of the application — handling data insertion and retrieval.

### 2.1 Create the Apex Class

1. Open the **Developer Console** (`Setup` → `Developer Console`).
2. Go to **File** → **New** → **Apex Class**.
3. Name it: `EmployeeController`
4. Replace the default code with the following:

```apex
public class EmployeeController {

    // Properties bound to the Visualforce page
    public Employee__c emp { get; set; }
    public List<Employee__c> empList { get; set; }

    // Constructor: initializes a blank employee and loads the list
    public EmployeeController() {
        emp = new Employee__c();
        refreshList();
    }

    // Queries all employee records, ordered by most recently created
    public void refreshList() {
        empList = [
            SELECT Name, Employee_Name__c, Email__c, Department__c 
            FROM Employee__c 
            ORDER BY CreatedDate DESC
        ];
    }

    // Inserts the new employee record, clears the form, and refreshes the list
    public PageReference saveEmployee() {
        insert emp;
        emp = new Employee__c(); // Reset form fields
        refreshList();
        return null;
    }
}
```

5. Click **Save** (`Ctrl + S` / `Cmd + S`).

---

## Step 3 — User Interface (Visualforce Page)

The Visualforce page provides the frontend form and table for users to add and view employees.

### 3.1 Create the Visualforce Page

1. In the **Developer Console**, go to **File** → **New** → **Visualforce Page**.
2. Name it: `EmployeeManagement`
3. Replace the default markup with the following:

```xml
<apex:page controller="EmployeeController">
    <apex:form>
        <apex:pageBlock title="Employee Management System">

            <!-- ADD EMPLOYEE FORM -->
            <apex:pageBlockSection title="Add Employee" columns="1">
                <apex:inputField value="{!emp.Employee_Name__c}"/>
                <apex:inputField value="{!emp.Email__c}"/>
                <apex:inputField value="{!emp.Department__c}"/>
                <apex:commandButton 
                    action="{!saveEmployee}" 
                    value="Add Employee" 
                    reRender="empTable"/>
            </apex:pageBlockSection>

            <!-- EMPLOYEE RECORDS TABLE -->
            <apex:pageBlockSection title="Employee Records" columns="1" id="empTable">
                <apex:pageBlockTable value="{!empList}" var="e">
                    <apex:column value="{!e.Name}"              headerValue="Employee ID"/>
                    <apex:column value="{!e.Employee_Name__c}"  headerValue="Name"/>
                    <apex:column value="{!e.Department__c}"     headerValue="Department"/>
                </apex:pageBlockTable>
            </apex:pageBlockSection>

        </apex:pageBlock>
    </apex:form>
</apex:page>
```

4. Click **Save**.

### 3.2 Access the Page

Navigate to:
```
https://<your-org-domain>.salesforce.com/apex/EmployeeManagement
```

---

## Step 4 — Console-Based Testing

Simulate a menu-driven console application using the **Execute Anonymous** window.

### 4.1 Open Execute Anonymous

1. Open the **Developer Console**.
2. Press `Ctrl + E` (Windows) or `Cmd + E` (Mac) to open the Execute Anonymous window.

### 4.2 Available Operations

Change the `operation` variable to run the desired command.

#### ➕ ADD — Insert a New Employee

```apex
String operation = 'ADD';

if (operation == 'ADD') {
    Employee__c e = new Employee__c(
        Employee_Name__c = 'John Doe',
        Email__c         = 'john@example.com',
        Department__c    = 'IT'
    );
    insert e;
    System.debug('✅ Employee added with ID: ' + e.Id);
}
```

#### 📋 VIEW — List All Employees

```apex
String operation = 'VIEW';

if (operation == 'VIEW') {
    List<Employee__c> listEmp = [
        SELECT Name, Employee_Name__c, Department__c 
        FROM Employee__c
    ];
    for (Employee__c emp : listEmp) {
        System.debug('👤 Name: ' + emp.Employee_Name__c + 
                     ' | ID: '   + emp.Name + 
                     ' | Dept: ' + emp.Department__c);
    }
}
```

> **View Debug Logs:** After clicking **Execute**, open the **Logs** panel at the bottom of the Developer Console. Click on the latest log entry and filter by `DEBUG` to see the output.

---

## Project Structure

```
salesforce-employee-management/
│
├── classes/
│   └── EmployeeController.cls       # Apex Controller (MVC - Controller)
│
├── pages/
│   └── EmployeeManagement.page      # Visualforce Page (MVC - View)
│
├── objects/
│   └── Employee__c/                 # Custom Object (MVC - Model)
│       └── fields/
│           ├── Employee_Name__c.field-meta.xml
│           ├── Email__c.field-meta.xml
│           ├── Birth_Date__c.field-meta.xml
│           └── Department__c.field-meta.xml
│
└── README.md
```

---

## Features

- ✅ **Add Employee** — Insert new employee records via form or Apex script
- ✅ **View All Employees** — Display all records in a sortable table
- ✅ **Auto-refresh** — Table updates without a full page reload using `reRender`
- ✅ **Picklist Department** — Controlled vocabulary for department selection
- ✅ **MVC Architecture** — Clean separation of data, logic, and presentation
- ✅ **Console Testing** — Menu-driven anonymous Apex for quick testing

---

## Screenshots

> _Add screenshots of your Salesforce org here after setup._

| Visualforce Page — Add Form | Visualforce Page — Records Table |
| :---: | :---: |
| _(screenshot)_ | _(screenshot)_ |

---

## Prerequisites

- A Salesforce Developer org (free at [developer.salesforce.com](https://developer.salesforce.com))
- Access to **Developer Console**
- Basic knowledge of Apex and Visualforce

---

## License

This project is intended for educational purposes. Feel free to fork and extend it.

---

> Built with ❤️ on the Salesforce Platform using Apex MVC
