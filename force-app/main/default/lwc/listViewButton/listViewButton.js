import { LightningElement, api, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import sendEmailToAdmin from '@salesforce/apex/ContactController.sendEmailToAdmin';

export default class ListViewButton extends LightningElement {
    @api listViewIds;
    @track contacts = []; // Initialize contacts array
    showModal = true;
    @track selectAllChecked = true; // To track Select All checkbox state
    selectedContactIds = new Set(); // To track selected contact IDs

    @wire(getContacts, { contactIds: '$listViewIds' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.map(contact => ({
                ...contact,
                isChecked: true 
            }));
            this.contacts.forEach(contact => {
                this.selectedContactIds.add(contact.Id); // Add contact ID to selected set
            });
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
    }

    showContactsModal() {
        this.showModal = true; // Open the modal
    }

    closeContactsModal() {
        this.showModal = false; // Close the modal
    }

    handleSelectAllChange(event) {
        // When Select All checkbox changes, update all contact checkboxes
        const isChecked = event.target.checked;
        this.selectAllChecked = isChecked;

        this.contacts.forEach(contact => {
            contact.isChecked = isChecked; // Set all contacts to be checked or unchecked
        });

        // Update selected contact IDs set
        if (isChecked) {
            this.contacts.forEach(contact => {
                this.selectedContactIds.add(contact.Id);
            });
        } else {
            this.selectedContactIds.clear(); // Clear selection
        }

        console.log('Selected Contact IDs:', Array.from(this.selectedContactIds));
    }

    handleCheckboxChange(event) {
        const contactId = event.target.dataset.id; // Get contact ID from data-id attribute
        const isChecked = event.target.checked; // Get checkbox state

        if (isChecked) {
            this.selectedContactIds.add(contactId); // Add contact ID to selected set
        } else {
            this.selectedContactIds.delete(contactId); // Remove contact ID from selected set
        }

        // Update the Select All checkbox state
        this.selectAllChecked = this.contacts.length == this.selectedContactIds.size;

        console.log('Selected Contact IDs:', Array.from(this.selectedContactIds));

        console.log('Select All Checked:', this.selectAllChecked);
        console.log('Contacts:', JSON.stringify(this.contacts));
    }

    async handleSave() {
        const selectedContacts = this.contacts.filter(contact =>
            this.selectedContactIds.has(contact.Id)
        );
        console.log('Selected Contacts:', selectedContacts);

        const conList = Array.from(this.selectedContactIds);
        console.log("selected haha : " + conList);
        await sendEmailToAdmin({ contactIds : conList })
            .then(result => {
                console.log('Email sent successfully:', result);
            })
            .catch(error => {
                console.error('Error sending email:', error);
            });

        this.closeContactsModal();
    }
}