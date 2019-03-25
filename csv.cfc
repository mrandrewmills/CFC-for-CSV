/**
*	csv.cfc  
*	@hint "convert query objects and arrayStructs to comma-separated-value format"
*/
component{
	
	this.quotesAroundAllFields = false;
	this.endLineWith = CHR(13) & CHR(10);
	
	private string function escapeAnyDoubleQuotes(required string txtField){
		return replace(txtField, '"', '""', "all");
	}
	
	private string function doesFieldNeedQuotes(required string txtField){
		if (this.quotesAroundAllFields == true)
			return true;
		
		if ( ( Find( ",", txtField ) > 0 ) || ( Find( '"', txtField ) > 0 ) )
			return true;
		elseif ( ( Find( CHR(13), txtField ) > 0 ) || ( Find( CHR(10), txtField ) > 0 ) )
			return true;
		else
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
		
			var nextField = this.escapeAnyDoubleQuotes( column );
		
			if ( this.doesFieldNeedQuotes( nextField ) )
				nextField = this.wrapFieldInQuotes( nextField );

				ArrayAppend( nextLine, nextField );
		}

		results &= this.endLine( ArrayToList( nextLine ) );
		
		for (record in qryObject){
		
			var nextLine = []; // reset
			
			for (column in qryObject.columnList){
				var nextField = this.escapeAnyDoubleQuotes( qryObject[column] );
				
				if ( this.doesFieldNeedQuotes( nextField ) )
					nextField = this.wrapFieldInQuotes( nextField );
					
				ArrayAppend( nextLine, nextField );
			}
			
			results &= this.endLine( ArrayToList( nextLine ) );
		}
	
		return results;
	}
}
