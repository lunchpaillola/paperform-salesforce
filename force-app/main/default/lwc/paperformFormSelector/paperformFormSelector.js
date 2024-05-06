import { LightningElement, track } from 'lwc';
//import saveFormSettings from '@salesforce/apex/PaperformSettingsController.saveFormSettings';
//import getFormOptions from '@salesforce/apex/PaperformSettingsController.getFormOptions';

export default class PaperformFormSelector extends LightningElement {
    @track apiKey;
    @track formId;
    @track message;
    @track formOptions = [];

    handleApiKeyChange(event) {
        this.apiKey = event.target.value;
        // Fetch available forms based on the new API key
        /*getFormOptions({ apiKey: this.apiKey }
            .then((result) => {
                this.formOptions = result.map((form) => ({
                    label: form,
                    value: form
                }));
            })
            .catch((error) => {
                this.message = 'Error fetching forms: ' + error.body.message;
            }); */
    }

    handleFormSelection(event) {
        this.formId = event.target.value;
    }

    handleSaveClick() {
        /*saveFormSettings({ apiKey: this.apiKey, formId: this.formId })
            .then((result) => {
                this.message = result;
            })
            .catch((error) => {
                this.message = 'Error saving settings: ' + error.body.message;
            }); */
    }
}
