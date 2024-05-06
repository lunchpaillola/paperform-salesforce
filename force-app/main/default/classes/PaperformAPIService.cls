public with sharing class PaperformAPIService {
    // Fetch the available forms using the Paperform API
    public static List<String> getAvailableForms(String apiKey) {
        List<String> formNames = new List<String>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.paperform.co/forms');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + apiKey);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            // Parse JSON response to get form names
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            for (Object form : (List<Object>)results.get('forms')) {
                Map<String, Object> formDetails = (Map<String, Object>) form;
                formNames.add((String)formDetails.get('name')); // Assuming 'name' is the field to use
            }
        } else {
            throw new AuraHandledException('Error fetching forms: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
        return formNames;
    }
}
