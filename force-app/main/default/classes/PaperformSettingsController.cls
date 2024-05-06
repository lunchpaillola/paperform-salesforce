public with sharing class PaperformSettingsController {
    public PaperformSettingsController() {
    }

    /*
    @AuraEnabled
    public static String saveFormSettings(String apiKey, String formId) {
        // Use PaperformSettingsManager to save the settings
        PaperformSettingsManager.saveSettings(apiKey, formId);
        return 'Settings saved successfully.';
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getFormOptions(String apiKey) {
        // Delegate to PaperformAPIService to fetch the list of forms
        return PaperformAPIService.getAvailableForms(apiKey);
    }
    */
}
