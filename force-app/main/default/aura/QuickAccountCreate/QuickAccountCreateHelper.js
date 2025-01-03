({
    navigateToRecord: function (recordId) {
        let navService = $A.get("e.force:navigateToSObject");
        navService.setParams({
            recordId: recordId
        });
        navService.fire();
    }
});
