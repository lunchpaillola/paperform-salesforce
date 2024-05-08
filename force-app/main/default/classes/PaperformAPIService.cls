public with sharing class PaperformAPIService {
    public static List<Map<String, String>> getAvailableForms(String apiKey) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.paperform.co/v1/forms');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + apiKey);

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            // Parse the JSON response to retrieve form details
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
                response.getBody()
            );
            List<Map<String, String>> forms = new List<Map<String, String>>();

            // Correct handling of nested JSON structure
            Map<String, Object> results = (Map<String, Object>) responseMap.get(
                'results'
            );
            if (results != null && results.containsKey('forms')) {
                List<Object> formsList = (List<Object>) results.get('forms');
                for (Object form : formsList) {
                    Map<String, Object> formDetails = (Map<String, Object>) form;
                    Map<String, String> formInfo = new Map<String, String>();
                    formInfo.put('title', (String) formDetails.get('title'));
                    formInfo.put('id', (String) formDetails.get('id'));
                    forms.add(formInfo);
                }
            }
            return forms;
        } else {
            throw new AuraHandledException(
                'Failed to retrieve forms: ' +
                    response.getStatusCode() +
                    ' ' +
                    response.getStatus()
            );
        }
    }
}
