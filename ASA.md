# Azure Storage Account / Azure File Share

![image](https://github.com/user-attachments/assets/26e76e68-9e1c-4f76-9bda-b80f8da0f519)![image](https://github.com/user-attachments/assets/d69bf675-d809-42d8-b7dd-f8769f68f2a8)![image](https://github.com/user-attachments/assets/ecf6da35-c5ad-4c0c-8708-def9876c8ce3)

Is a classic cloud file system compatible with the NFS and SMB protocols. Data is structured and can be consulted from a web client or even synchronized with a conventional file explorer. This solution is less powerful and more expensive than Azure Blob.

To implement this solution, you need to create an Azure storage account and an Azure File share instance.
![image](https://github.com/user-attachments/assets/33dac41e-5aa4-4dfe-ad8c-549ed4080026)

### Specific development
The specific development is based on an API rest connection between the ERP system and the SharePoint platform. This development has been facilitated by a framework introduced into the ERP since version 2022 wave 2(BC21) in Open source and available on GitHub.
![image](https://github.com/user-attachments/assets/2d2a2cdd-3318-4080-9285-28e07db2838d)
Just a few lines of code, including the use of objects, “AFS file Client” (CU), “AFS Directory Content" (REC) for rapid integration with SharePoint.

We have developed an example which uses the same user interface as attached documents, this feature prevents the file from being saved in the database.
Directory structure and file names are the same as in the SharePoint solution (above).

### Development diagram
![image](https://github.com/user-attachments/assets/57fb3f3f-a8ea-449a-8fe3-cb775912f967)

### Business Central Company Information Setup
![image](https://github.com/user-attachments/assets/ffd6f315-6fb5-4f58-adb9-f3930c9f1a7a)

Azure Storage Account: follow the format account/azure File share name.
Azure File Share SaaS Connection String: Recovering the key from Azure Storage. (Shared signature).
![image](https://github.com/user-attachments/assets/31ef233e-803f-4cf6-91ad-c135a1ac5582)

### File Storage in operation from the Customer Card
![image](https://github.com/user-attachments/assets/5a29103c-7efa-4059-a81f-a16e469a8d50)

### File in Azure File Share
![image](https://github.com/user-attachments/assets/5feaf2c7-16d6-4119-80f2-f7679daaa422)
