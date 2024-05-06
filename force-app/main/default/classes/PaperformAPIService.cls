public with sharing class PaperformAPIService {
    // Constructor remains empty for boilerplate purposes
    public PaperformAPIService() {
        // The constructor should not contain other class definitions or static methods.
    }

    // Static method to fetch available forms from the Paperform API
    public static List<String> getAvailableForms(String apiKey) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.paperform.co/forms');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + apiKey);

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            // Parse the JSON response to retrieve form names
            List<String> formNames = new List<String>();
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
                response.getBody()
            );
            List<Object> formsList = (List<Object>) results.get('forms');

            for (Object form : formsList) {
                Map<String, Object> formDetails = (Map<String, Object>) form;
                formNames.add((String) formDetails.get('name')); // Assuming "name" is the field containing form names
            }
            return formNames;
        } else {
            // Handle HTTP request errors
            throw new AuraHandledException(
                'Failed to retrieve forms: ' +
                    response.getStatusCode() +
                    ' ' +
                    response.getStatus()
            );
        }
    }
}
