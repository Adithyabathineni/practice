using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab07
{
    // Define the base class Employee
    public abstract class Employee
    {
        // Fields
        private int empId;
        private int storeId;
        private string lastName;
        private string department;

        // Properties
        public int EmpId
        {
            get { return empId; }
            set { empId = value; }
        }

        public int StoreId
        {
            get { return storeId; }
            set { storeId = value; }
        }

        public string LastName
        {
            get { return lastName; }
            set { lastName = value; }
        }

        public string Department
        {
            get { return department; }
            set { department = value; }
        }

        // Constructors
        public Employee()
        {
            empId = 11;
            storeId = 1;         //Parameterless
            lastName = "Jhon";
            department = "Production";
        }

        public Employee(int empId, int storeId, string lastName, string department)
        {
            this.empId = empId;
            this.storeId = storeId;  //Parameterized
            this.lastName = lastName;
            this.department = department;
        }

        // Abstract method for calculating salary
        public abstract double CalcSalary();

        // Override ToString() method to print employee information
        public override string ToString()
        {
            return $"Employee ID: {empId}\nStore ID: {storeId}\nLast Name: {lastName}\nDepartment: {department}";
        }
    }
}



