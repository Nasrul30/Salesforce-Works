import { LightningElement, api } from 'lwc';
import exportNonSelectedAccounts from '@salesforce/apex/ExportNonSelectedAccountsController.exportNonSelectedAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ExportNonSelectedAccounts extends LightningElement {
    @api listViewIds; // Expecting an array of selected account IDs

    // Handler function for the export button
    handleExport() {
        console.log('Export button clicked');	
        const selectedAccountIds = this.listViewIds; // Using listViewIds for selected account IDs

        if (!selectedAccountIds || selectedAccountIds.length === 0) {
            console.log('No account IDs provided');
            this.showToast('Error', 'No account IDs provided!', 'error');
            return;
        }

        exportNonSelectedAccounts({ selectedAccountIds: selectedAccountIds })
        
            .then(() => {
                this.showToast('Success', 'CSV file has been emailed successfully!', 'success');
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Function to show toast messages
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}
