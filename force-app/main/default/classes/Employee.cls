public virtual class Employee {

    public String employeeName;
    public Integer employeeID;
    public String department;

    //a constructor for initialize ing the class
    public Employee(String employeeName, Integer employeeID, String department) {
        this.employeeName = employeeName;
        this.employeeID = employeeID;
        this.department = department;

    }

    public virtual void display() {
        System.debug('Employee Name:' + employeeName);
        System.debug('Employee ID:' + employeeID);
        System.debug('Employee Department:' + department);

    }
}