/**
*	csv.cfc  
*	@hint "convert query objects and arrayStructs to comma-separated-value format"
*/
component{
	
	this.quotesAroundAllFields = false;
	this.endLineWith = CHR(13) & CHR(10);
	
	private string function escapeAnyDoubleQuotes(required any txtField){
		return replace(txtField, '"', '""', "all");
	}
	
	private string function doesFieldNeedQuotes(required string txtField){
		if (this.quotesAroundAllFields == true)
			return true;
		
		if ( ( Find( ",", txtField ) > 0 ) || ( Find( '"', txtField ) > 0 ) ){
			return true;
			}
		else if ( ( Find( CHR(13), txtField ) > 0 ) || ( Find( CHR(10), txtField ) > 0 ) ){
			return true;
			}
			
		return false;
	}
	
	private string function wrapFieldInQuotes(required string txtField){
		return """" & txtField & """";
	}
	
	private string function endLine(required string txtLine){
		return txtLine & this.endLineWith;
	}
	
	public any function convertQueryToCSV(required query qryObject){
	
		var results = "";
		var nextLine = [];
		
		for (column in qryObject.columnList){
		
			var nextField = escapeAnyDoubleQuotes( column );
		
			if ( doesFieldNeedQuotes( nextField ) )
				nextField = wrapFieldInQuotes( nextField );

				ArrayAppend( nextLine, nextField );
		}

		results &= endLine( ArrayToList( nextLine ) );
		
		for (record in qryObject){
		
			var nextLine = []; // reset
			
			for (column in qryObject.columnList){
				var nextField = escapeAnyDoubleQuotes( qryObject[column] );
				
				if ( doesFieldNeedQuotes( nextField ) )
					nextField = wrapFieldInQuotes( nextField );
					
				ArrayAppend( nextLine, nextField );
			}
			
			results &= endLine( ArrayToList( nextLine ) );
		}
	
		return results;
	}
}
