public with sharing class PaperformSettingsController {
    public PaperformSettingsController() {
    }

    @AuraEnabled
    public static String saveFormSettings(String apiKey, String formId) {
        try {
            PaperformSettingsManager.saveSettings(apiKey, formId);
            return 'Settings saved successfully.';
        } catch (Exception e) {
            // Log the exception and return a message indicating an error
            System.debug('Error saving settings: ' + e.getMessage());
            return 'Error saving settings: ' + e.getMessage(); // Ensure this message is relayed to LWC
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFormOptions(String apiKey) {
        try {
            return PaperformAPIService.getAvailableForms(apiKey);
        } catch (Exception e) {
            System.debug('Error fetching forms: ' + e.getMessage());
            throw new AuraHandledException(
                'Error fetching forms: ' + e.getMessage()
            );
        }
    }
}
