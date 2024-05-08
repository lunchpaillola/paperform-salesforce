public with sharing class PaperformSettingsManager {
    // Store the settings
    public static void saveSettings(String apiKey, String formId) {
        // Retrieve the settings for the current user context; creates a new one if none exists
        PaperformSettings__c settings = PaperformSettings__c.getOrgDefaults();
        settings.ApiKeyPart1__c = apiKey.substring(0, 255);
        settings.ApiKeyPart2__c = apiKey.substring(255, 510);
        settings.ApiKeyPart3__c = apiKey.substring(510, 765);
        settings.ApiKeyPart4__c = apiKey.substring(765, apiKey.length());
        settings.SelectedFormId__c = formId;
        upsert settings; // Insert or update the custom setting record
    }

    // Retrieve the stored settings (for future use)
    public static PaperformSettings__c getSettings() {
        // Retrieves settings considering the hierarchy (user -> profile -> organization)
        return PaperformSettings__c.getOrgDefaults();
    }
}
