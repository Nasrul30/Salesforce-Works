({
    fetchOpportunity: function (component, event, helper) {
        let action = component.get("c.getOpportunity");

        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let opportunities = response.getReturnValue();
                component.set("v.opportunities", opportunities);
                console.log("Opportunities fetched successfully: ", opportunities);
            } else {
                console.error("Failed to fetch opportunities: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    }
});
