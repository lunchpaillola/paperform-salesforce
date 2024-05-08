public with sharing class PaperformSettingsManager {
    // Store the settings
    public static void saveSettings(String apiKey, String formId) {
        // Retrieve the settings for the current user context; creates a new one if none exists
        PaperformSettings__c settings = PaperformSettings__c.getOrgDefaults();
        settings.ApiKey__c = apiKey;
        settings.SelectedFormId__c = formId;
        upsert settings; // Insert or update the custom setting record
    }

    // Retrieve the stored settings (for future use)
    public static PaperformSettings__c getSettings() {
        // Retrieves settings considering the hierarchy (user -> profile -> organization)
        return PaperformSettings__c.getOrgDefaults();
    }
}
