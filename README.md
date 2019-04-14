# CFC for CSV
CFML component for converting queries into comma-separated value format

## Basic Instructions

```ColdFusion
<cfscript>
  // create and configure our component instance
  csvObj = CreateObject( "Component", "csv" );
  
  /* assuming you've created a query called myQuery,
  here's how you can convert it to CSV format  */
  myQueryCSV = csvObj.convertQueryToCSV( myQuery );
  
  // what you do with your CSV after this is up to you . . . 
  
  // display in output
  writeDump( myQueryCSV );
  
  // write to a file, etc. You get the idea.
  fileWrite( expandPath("./myQuery.csv"), myQueryCSV );
</cfscript>
```  

## Frequently Asked Questions

**1.  Can't I already do this with the cfspreadsheet tag?**

Lucee doesn't natively support the cfspreadsheet tag at this time. Although there is a 40+ MB plugin you can install separately for that tag to be supported, I prefer a 2 kb CFC file if all I really need is to create a .csv file.
