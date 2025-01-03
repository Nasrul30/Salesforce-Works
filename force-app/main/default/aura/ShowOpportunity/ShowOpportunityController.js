({
    doInit: function (component, event, helper) {
        console.log('doInit');
        if (component.get("v.recordId")) {
            helper.fetchOpportunity(component);
        }
    }
});
