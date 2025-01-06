import { LightningElement, api } from 'lwc';
import sendCSVEmail from '@salesforce/apex/CSVEmailSender.sendCSVEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CSVMakerComponent extends LightningElement {
    @api listViewIds; // Selected record IDs passed from the parent or flow.

    handleSendCSV() {
        const recordIds = this.listViewIds; // Assuming listViewIds is an array of IDs.

        // Check if selected record IDs are empty or not passed
        if (!recordIds || recordIds.length === 0) {
            this.showToast('Error', 'No account IDs provided!', 'error');
            return;
        }

        // Call Apex to send CSV email
        sendCSVEmail({ selectedRecordIds: recordIds })
            .then(() => {
                console.log('CSV email sent successfully');
                this.showToast('Success', 'CSV email sent successfully!', 'success');
            })
            .catch(error => {
                console.error('Error sending CSV email:', error);
                this.showToast('Error', error.body.message || 'Something went wrong!', 'error');
            });
    }

    // Method to show toast notifications
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        // Dispatch the event to trigger the toast
        this.dispatchEvent(evt);
    }
}
