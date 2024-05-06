public with sharing class PaperformSettingsManager {
    public PaperformSettingsManager() {
    }
    /* // Store the settings
    public static void saveSettings(String apiKey, String formId) {
        // Check if a PaperformSettings__c custom setting already exists, else create a new one
         PaperformSettings__c settings = PaperformSettings__c.getInstance(
            'Default'
        );
        if (settings == null) {
            settings = new PaperformSettings__c(Name = 'Default');
        }
        settings.ApiKey__c = apiKey;
        settings.SelectedFormId__c = formId;
        upsert settings; // Insert or update the custom setting record
        
    }

    // Retrieve the stored settings (for future use)
    public static PaperformSettings__c getSettings() {
         return PaperformSettings__c.getInstance('Default');
    }
    */
}
