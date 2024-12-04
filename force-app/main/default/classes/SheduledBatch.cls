global class SheduledBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchInsert(),100);
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchProcessTasks(),100);
    }
}

