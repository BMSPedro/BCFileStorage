# SharePoint Storage

                                                                                       
![image](https://github.com/user-attachments/assets/74c0655b-a9df-4d41-851a-9886a1c6ced9)![image](https://github.com/user-attachments/assets/2748b443-fd9e-40ee-acff-d08a0dbaf2f2)![image](https://github.com/user-attachments/assets/ebacc894-7c41-4c67-b1ba-e5e545e5618d)

Unlike the two previous solutions, storage in a SharePoint requires specific development as well as an Enterprise application in Azure ENTRA ID in order to manage the authentication of Business Central with SharePoint.
### Microsoft ENTRA ID, Enterprise Application:
![image](https://github.com/user-attachments/assets/5082aa4a-935f-4fff-8432-b724a8e0f928)

The main parameters for this enterprise application are:
-	Create a secret (keep secret value)
-	Dive the following delegated API permissions (Microsoft Graph), sites.readwrite.all.
[https://learn.microsoft.com/en-us/sharepoint/dev/sp-add-ins-modernize/understanding-rsc-for-msgraph-and-sharepoint-online]

### Specific development: 
The specific development is based on an API rest connection between the ERP system and the SharePoint platform. This development has been facilitated by a framework introduced into the ERP since version 2022 wave 2(BC21) in Open source and available on GitHub.
https://learn.microsoft.com/en-us/dynamics365-release-plan/2022wave2/smb/dynamics365-business-central/use-sharepoint-module-system-application-build-integrations-between-business-central-sharepoint

Source code on GitHub:
[https://github.com/BMSPedro/BCFileStorage/]
![image](https://github.com/user-attachments/assets/db0eca93-4351-42f4-a7a4-179ff3a3e2c6)


Just a few lines of code, including the use of objects, “SharePoint Client” (CU), “SharePoint Folder" (REC), “SharePoint File" (REC) for rapid integration with SharePoint.

We have developed an example which uses the same user interface as attached documents, this feature prevents the file from being saved in the database.
Directory structure and file naming rules:
To upload files to a SharePoint, a SharePoint site must first be created.
When a file is uploaded to the SharePoint from Business Central, the file deposit folder will be automatically created if it does not already exist.

Directory structure:
<img width="285" alt="image" src="https://github.com/user-attachments/assets/49da78f2-9bcc-416d-8161-b7361286e2b2">

Transactional data such as orders, invoices, credit memos, etc., will be stored in the customer or supplier folder, depending on the module concerned (purchasing or sales).
file naming follows the following structure:
<table Id>-<record No.>-<Original file name>.pdf
Ex.
18-10000-customr contrat.pdf (file attached from customer card, customer 10000)
36-SO0000001-customer order.pdf (file attached from the sales order document).

Setup.
In our example, to use SharePoint storage, once the SharePoint site has been created, you need to indicate the type of storage (select SharePoint) and the URL of the site in the company information table.

### Development diagram
![image](https://github.com/user-attachments/assets/3391a6b1-c0d8-4f29-9125-630fdd89c940)

### SharePoint Site
![image](https://github.com/user-attachments/assets/b49dad3e-1710-4dab-8774-ce15e7ed69c6)

### Business Central Company Information Setup
![image](https://github.com/user-attachments/assets/8bfb9405-801c-4827-931d-8c1a155aecee)

### File storage in operation from customer Card
![image](https://github.com/user-attachments/assets/909491c9-dcf5-4003-979a-46e1051600ef)

### File in SharePoint
![image](https://github.com/user-attachments/assets/735b377e-bbde-4c60-986c-95a08d8e03fe)

The advantage of this approach is to have a centralized location for file management with a simple, easy-to-understand structure. The disadvantage is to replicate management rules and legal requirements on this platform.








