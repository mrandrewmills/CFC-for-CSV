/**
* csv.cfc
* @hint "convert query objects and arrayStructs to comma-separated-value format"
*/
component {

    // Configuration options
    this.quotesAroundAllFields = false;
    this.endLineWith = CHR(13) & CHR(10);

    /**
     * Escapes double quotes in a text field.
     */
    private string function escapeAnyDoubleQuotes(required any txtField) {
        return replace(txtField, '"', '""', "all");
    }

    /**
     * Determines if a field needs to be enclosed in quotes.
     */
    private string function doesFieldNeedQuotes(required string txtField) {
        if (this.quotesAroundAllFields) {
            return true;
        }

        if ((Find(",", txtField) > 0) || (Find('"', txtField) > 0) || (Find(CHR(13), txtField) > 0) || (Find(CHR(10), txtField) > 0)) {
            return true;
        }

        return false;
    }

    /**
     * Wraps a field in quotes.
     */
    private string function wrapFieldInQuotes(required string txtField) {
        return """" & txtField & """";
    }

    /**
     * Appends the line ending to a text line.
     */
    private string function endLine(required string txtLine) {
        return txtLine & this.endLineWith;
    }

    /**
     * Converts a query object to CSV format.
     */
    public any function convertQueryToCSV(required query qryObject) {
        var result = "";

        // Header
        for (column in qryObject.columnList) {
            var nextField = escapeAnyDoubleQuotes(column);
            if (doesFieldNeedQuotes(nextField)) {
                nextField = wrapFieldInQuotes(nextField);
            }
            result &= endLine(nextField);
        }

        // Data
        for (record in qryObject) {
            var nextLine = [];
            for (column in qryObject.columnList) {
                var nextField = escapeAnyDoubleQuotes(qryObject[column]);
                if (doesFieldNeedQuotes(nextField)) {
                    nextField = wrapFieldInQuotes(nextField);
                }
                ArrayAppend(nextLine, nextField);
            }
            result &= endLine(ArrayToList(nextLine));
        }

        return result;
    }

    /**
     * Converts an array of structs to CSV format.
     */
    public any function convertArrayToCSV(required array arrObject) {
        var result = "";

        // Header
        if (ArrayLen(arrObject) > 0) {
            var headerLine = [];
            for (var key in arrObject[1]) {
                var nextField = escapeAnyDoubleQuotes(key);
                if (doesFieldNeedQuotes(nextField)) {
                    nextField = wrapFieldInQuotes(nextField);
                }
                ArrayAppend(headerLine, nextField);
            }
            result &= endLine(ArrayToList(headerLine));
        }

        // Data
        for (var record in arrObject) {
            var nextLine = [];
            for (var key in record) {
                var nextField = escapeAnyDoubleQuotes(record[key]);
                if (doesFieldNeedQuotes(nextField)) {
                    nextField = wrapFieldInQuotes(nextField);
                }
                ArrayAppend(nextLine, nextField);
            }
            result &= endLine(ArrayToList(nextLine));
        }

        return result;
    }
}
