({
    handleSave: function (component, event, helper) {

        console.log('I am from a handleSave');

        let name = component.get("v.name");
        let phone = component.get("v.phone");
        let industry = component.get("v.industry");
        let errors = [];

        // Validate required fields
        if (!name) {
            errors.push("Name is required.");
        }
        if (!phone) {
            errors.push("Phone is required.");
        } else if (!/^\d{10}$/.test(phone)) {
            errors.push("Phone must be 10 digits.");
        }

        component.set("v.errors", errors);

        // If there are validation errors, return
        if (errors.length > 0) {
            return;
        }

        // Call Apex to save the record
        console.log('before handle save');
        let action = component.get("c.saveRecord");
        action.setParams({
            name: name,
            phone: phone,
            industry: industry
        });
        console.log('after handle save');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let recordId = response.getReturnValue();
                helper.navigateToRecord(recordId);
            } else {
                console.error("Error saving record: ", response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    handleCancel: function (component, event, helper) {
        // Navigate back to the previous page
        let navService = component.find("navigationService");
        navService.navigate({
            type: "standard__navItemPage",
            attributes: {
                apiName: "Home"
            }
        });
    }
});



