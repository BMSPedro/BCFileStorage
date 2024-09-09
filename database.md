

## Storage in the ERP database
![image](https://github.com/user-attachments/assets/d8790a60-b73c-4159-9ff4-18f54a037923)![image](https://github.com/user-attachments/assets/f2150075-3ac5-48a7-b874-aedda8621b80)![image](https://github.com/user-attachments/assets/94f27f73-9af3-4244-910d-a6f0550b15b3)

Basic data types in SQL reserve specific memory space allowing the storage of large binary files. Files, whether images or other file types. The Blob and media-set types allow file storage directly in the Business Central database.
By default, this is the standard solution used by Microsoft, we can use it when adding attachments to ERP entities, or when adding images at item level.
![image](https://github.com/user-attachments/assets/0e0940b0-1401-4560-91e2-57fe75c6a00b)
The main problems with this solution are in a context where the storage capacity in Business Central is limited to 80gb, and adding capacity can be expensive, adding files directly to the database is not recommended, also the performance of the database may be affected.
You start from a base entitlement of 80 GB per environment and then you add 3 GB per premium user and 2 GB per Essential users. This is the base space across environments in a tenant.

Adding additional capacity in slots of 1 GB cost about 10$ per month, or 100 GB about 500$ per month.





