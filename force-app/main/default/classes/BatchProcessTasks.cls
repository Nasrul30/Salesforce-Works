global class BatchProcessTasks implements Database.Batchable<sObject>, Database.Stateful {
    /**
     *  This BatchClass includes
     *      1.Check the task status is completed or not 
     *      2.Check the task is overdue or not 
     *      3.Update the task status 
     *      4.Update the project cost 
     *      5.Update the task cost
     *      6.Send email notification
     * 
     */


    // Track statistics for the email summary
    Integer totalTasksProcessed = 0;
    Integer tasksMarkedOverdue = 0;
    Map<Id, Decimal> projectCostMap = new Map<Id, Decimal>();

    /**
     * 1.Start method fetch all task record 
     *  
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Fetch all Task__c records
        return Database.getQueryLocator('SELECT Id, Due_Date__c, Task_Status__c, Task_Cost__c, Project__c FROM Task__c');
    }

    /**
     * This execute  method cover 
     *        1.Check the task status is completed or not 
     *        2.Check the task is overdue or not 
     *        3.Update the task status 
     *        4.Update the project cost 
     *        5.Update the task cost
     * 
     */

    global void execute(Database.BatchableContext BC, List<Task__c> scope) {
        List<Task__c> tasksToUpdate = new List<Task__c>();
        Map<Id, Decimal> taskCostByProject = new Map<Id, Decimal>();

        for (Task__c task : scope) {
            totalTasksProcessed++;

            // Check if the task is overdue
            if (task.Due_Date__c < Date.today() && task.Task_Status__c != 'Completed') {
                task.Task_Status__c = 'Overdue';
                tasksToUpdate.add(task);
                tasksMarkedOverdue++;   // tracking the overdue task
            }

            // Calculatin the project task cost
            if (task.Project__c != null && task.Task_Cost__c != null) {
                if (!taskCostByProject.containsKey(task.Project__c)) {
                    taskCostByProject.put(task.Project__c, 0);  //initialize the first value of the map 
                }
                taskCostByProject.put(task.Project__c, taskCostByProject.get(task.Project__c) + task.Task_Cost__c);
            }
        }

        // Update tasks with exception handlaing 
        if (!tasksToUpdate.isEmpty()) {
            try {
                update tasksToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating tasks: ' + e.getMessage());
            }
        }

        // Update the project cost when task is updated
        for (Id projectId : taskCostByProject.keySet()) {
            if (!projectCostMap.containsKey(projectId)) {
                projectCostMap.put(projectId, 0);
            }
            projectCostMap.put(projectId, projectCostMap.get(projectId) + taskCostByProject.get(projectId));
        }
    }

    /**
     * This finish method cover
     *        1.Update the project cost 
     *        2.Send notification email
     */


    global void finish(Database.BatchableContext BC) {
        // Update project costs
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for (Id projectId : projectCostMap.keySet()) {
            projectsToUpdate.add(new Project__c(Id = projectId, Total_Cost__c = projectCostMap.get(projectId)));
        }

        if (!projectsToUpdate.isEmpty()) {
            try {
                update projectsToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating projects: ' + e.getMessage());
            }
        }

        // Send notification email
        String subject = 'Batch Job Completed: Task and Project Processing Summary';
        String body = 'The batch job for task and project processing has completed.\n\n' +
                      'Total Tasks Processed: ' + totalTasksProcessed + '\n' +
                      'Tasks Marked Overdue: ' + tasksMarkedOverdue + '\n' +
                      'Total Projects Updated: ' + projectsToUpdate.size() + '\n\n' +
                      'Thanks';
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'nasrulhasan2010@gmail.com' });
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
