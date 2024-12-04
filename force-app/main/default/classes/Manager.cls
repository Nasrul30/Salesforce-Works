public class  Manager extends Employee {

    Integer teamSize;
    public Manager(String employeeName, Integer employeeID, String department,Integer teamSize) {
        super(employeeName, employeeID, department);
        this.teamSize = teamSize;
    }

    
    public override  void display() {

       // super.display();
        System.debug('Team Size:' + teamSize);
        System.debug('Employee Name:' + employeeName);
        System.debug('Employee ID:' + employeeID);
        System.debug('Employee Department:' + department);

    }
}