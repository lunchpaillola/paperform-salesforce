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

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> importSubmissions(
        String apiKey,
        String formId
    ) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'https://api.paperform.co/v1/forms/' + formId + '/submissions'
        );
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + apiKey);

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return parseSubmissions(response.getBody());
        } else {
            throw new AuraHandledException(
                'Failed to fetch submissions: ' +
                    response.getStatusCode() +
                    ' ' +
                    response.getStatus()
            );
        }
    }

    private static List<Map<String, String>> parseSubmissions(
        String jsonResponse
    ) {
        List<Map<String, String>> submissions = new List<Map<String, String>>();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
            jsonResponse
        );

        if (responseMap.containsKey('results')) {
            Map<String, Object> results = (Map<String, Object>) responseMap.get(
                'results'
            );
            if (results.containsKey('submissions')) {
                List<Object> submissionsList = (List<Object>) results.get(
                    'submissions'
                );
                for (Object obj : submissionsList) {
                    Map<String, Object> submissionData = (Map<String, Object>) obj;
                    Map<String, String> submission = new Map<String, String>();

                    submission.put('id', (String) submissionData.get('id'));
                    submission.put(
                        'formId',
                        (String) submissionData.get('form_id')
                    );

                    // Assuming data fields are a simple key-value pair of strings
                    if (submissionData.containsKey('data')) {
                        Map<String, Object> data = (Map<String, Object>) submissionData.get(
                            'data'
                        );
                        for (String key : data.keySet()) {
                            submission.put(key, String.valueOf(data.get(key)));
                        }
                    }

                    submissions.add(submission);
                }
            }
        }
        return submissions;
    }
}
