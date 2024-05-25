import { LightningElement, track, wire } from 'lwc';
import saveFormSettings from '@salesforce/apex/PaperformSettingsController.saveFormSettings';
import getFormOptions from '@salesforce/apex/PaperformSettingsController.getFormOptions';
import getSettings from '@salesforce/apex/PaperformSettingsManager.getSettings';
import importAndCreateLeads from '@salesforce/apex/PaperformAPIService.importAndCreateLeads';

export default class PaperformFormSelector extends LightningElement {
    @track apiKey = '';
    @track formId = '';
    @track message = '';
    @track formOptions = [];
    @track settingsLoaded = false;

    @wire(getSettings)
    wiredSettings({ error, data }) {
        if (data) {
            this.apiKey =
                (data.ApiKeyPart1__c || '') +
                (data.ApiKeyPart2__c || '') +
                (data.ApiKeyPart3__c || '') +
                (data.ApiKeyPart4__c || '');
            this.formId = data.SelectedFormID__c || '';
            this.settingsLoaded = true;

            // Fetch form options if API key is already present
            if (this.apiKey) {
                this.fetchFormOptions();
            }
        } else if (error) {
            this.message = 'Error loading settings';
            console.error('Error loading settings:', error);
        }
    }

    get isApiKeyEntered() {
        return this.apiKey && this.apiKey.length > 0;
    }

    get isFormSelected() {
        return this.formId && this.formId.length > 0;
    }

    get isFormNotSelected() {
        return !this.isFormSelected;
    }

    handleApiKeyChange(event) {
        this.apiKey = event.target.value;
        if (this.apiKey) {
            this.fetchFormOptions();
        } else {
            this.formOptions = [];
        }
    }

    fetchFormOptions() {
        getFormOptions({ apiKey: this.apiKey })
            .then((result) => {
                this.formOptions = result.map((form) => ({
                    label: form.title,
                    value: form.id
                }));
                if (
                    !this.formOptions.find(
                        (option) => option.value === this.formId
                    )
                ) {
                    this.formId = '';
                }
            })
            .catch((error) => {
                this.message = 'Error fetching forms: ' + error.body.message;
            });
    }

    handleFormSelection(event) {
        this.formId = event.target.value;
    }

    handleSaveClick() {
        this.message = '';
        saveFormSettings({ apiKey: this.apiKey, formId: this.formId })
            .then((result) => {
                this.message = result;
                return importAndCreateLeads({
                    apiKey: this.apiKey,
                    formId: this.formId
                });
            })
            .then((result) => {
                this.message += ' ' + result;
            })
            .catch((error) => {
                this.message +=
                    ' Error: ' +
                    (error.body ? error.body.message : 'Unknown error');
                console.error('Error details:', error);
            });
    }
}
