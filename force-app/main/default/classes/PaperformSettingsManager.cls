public with sharing class PaperformSettingsManager {
    // Store the settings
    public static void saveSettings(String apiKey, String formId) {
        // Retrieve the settings for the current user context; creates a new one if none exists
        PaperformSettings__c settings = PaperformSettings__c.getOrgDefaults();
        if (settings == null) {
            settings = new PaperformSettings__c();
        }
        // Ensure apiKey is not null and has enough length before substring operation
        if (String.isNotBlank(apiKey) && apiKey.length() > 765) {
            settings.ApiKeyPart1__c = apiKey.substring(0, 255);
            settings.ApiKeyPart2__c = apiKey.substring(255, 510);
            settings.ApiKeyPart3__c = apiKey.substring(510, 765);
            settings.ApiKeyPart4__c = apiKey.substring(765);
        }
        settings.SelectedFormId__c = formId;
        upsert settings; // Insert or update the custom setting record
    }

    // Retrieve the stored settings (for future use)
    public static PaperformSettings__c getSettings() {
        return PaperformSettings__c.getOrgDefaults();
    }

    // Retrieve the complete API key for the organization
    public static String getCompleteApiKey() {
        PaperformSettings__c settings = getSettings();
        return settings.ApiKeyPart1__c +
            settings.ApiKeyPart2__c +
            settings.ApiKeyPart3__c +
            settings.ApiKeyPart4__c;
    }
}
