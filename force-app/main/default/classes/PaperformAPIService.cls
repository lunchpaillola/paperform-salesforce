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

    /*private static List<PaperformSubmission> parseSubmissions(
        String jsonResponse
    ) {
        List<PaperformSubmission> submissions = new List<PaperformSubmission>();
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
                    PaperformSubmission submission = new PaperformSubmission();

                    // Basic fields
                    submission.id = (String) submissionData.get('id');
                    submission.formId = (String) submissionData.get('form_id');

                    // Data fields
                    Map<String, Object> data = (Map<String, Object>) submissionData.get(
                        'data'
                    );
                    submission.data = new Map<String, String>();
                    for (String key : data.keySet()) {
                        submission.data.put(key, (String) data.get(key));
                    }

                    // Adding device info if needed, similar to above
                    // Example for 'device' parsing might be similarly detailed based on your class structure

                    submissions.add(submission);
                }
            }
        }
        return submissions;
    }

    private static List<PaperformSubmission> parseSubmissions(
        String jsonResponse
    ) {
        List<PaperformSubmission> submissions = new List<PaperformSubmission>();
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
                    PaperformSubmission submission = new PaperformSubmission();

                    // Basic fields
                    submission.id = (String) submissionData.get('id');
                    submission.formId = (String) submissionData.get('form_id');

                    // Data fields
                    Map<String, Object> data = (Map<String, Object>) submissionData.get(
                        'data'
                    );
                    submission.data = new Map<String, String>();
                    for (String key : data.keySet()) {
                        submission.data.put(key, (String) data.get(key));
                    }

                    // Adding device info if needed, similar to above
                    // Example for 'device' parsing might be similarly detailed based on your class structure

                    submissions.add(submission);
                }
            }
        }
        return submissions;
    } */
}
