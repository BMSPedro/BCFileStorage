# What does the law say about electronic file storage - examples
National legislation imposes certain rules in terms of file storage. These rules are formalized in legal texts and ISO standards. 
The rules covering security, data localization and encryption of exchanges are among the references in the ISO27001, the azure platform complies with this standard. 
[https://learn.microsoft.com/fr-fr/azure/governance/policy/samples/iso-27001]
and also, with other European legislation such as RGDP or local rules.
[https://learn.microsoft.com/en-us/azure/compliance/]

Also, in response to specific requests concerning the legality of file storage, Microsoft has introduced the notion of immutable storage that enables users to store business-critical data in a WORM (Write Once, Read Many) state. While in a WORM state, data can't be modified or deleted for a user-specified interval. By configuring immutability policies for blob data, you can protect your data from overwrites and deletes.
[https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview]

Other texts in France complement the references cited above. The definition of storage with probative value, or reliable audit trail, following the following rules:
-	The authenticity of the archived document, which must resemble the paper original in every way. We need to know who created it and when
-	The integrity of the archived document, which must be identical to the original. It must not be altered, modified, or distorted.
-	The intelligibility of the archived document, which must be legible over time thanks to a standard format (PDF or PDF A/3).
[https://bofip.impots.gouv.fr/bofip/8865-PGP.html/identifiant%3DBOI-TVA-DECLA-30-20-30-20-20180207]
[https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000034307622]

### in summary only, the Azure Share File solution complies with all the above rules.
