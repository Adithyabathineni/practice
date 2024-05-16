using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab07
{
    public class Manager : Employee
    {
        // Fields specific to Manager
        private int hours;
        private double pay;
        private double bonusAmount;

        // Properties
        public int HoursWorked
        {
            get { return hours; }
            set { hours = value; }
        }

        public double PayRate
        {
            get { return pay; }
            set { pay = value; }
        }

        public double Bonus
        {
            get { return bonusAmount; }
            set { bonusAmount = value; }
        }

        // Constructors
        public Manager()
        {
            // Default constructor
        }

        public Manager(int empId, int storeId, string lastName, string department, int hours, double pay, double bonusAmount)
            : base(empId, storeId, lastName, department)
        {
            this.hours = hours;
            this.pay = pay;
            this.bonusAmount = bonusAmount;
        }

        // Override the CalcSalary method to calculate Manager's salary
        public override double CalcSalary()
        {
            return (hours * pay) + bonusAmount;
        }

        // Override ToString() method to print Manager's information
        public override string ToString()
        {
            return $"Manager\n{base.ToString()}\nHours Worked: {hours}\nPay Rate: {pay}\nBonus Amount: {bonusAmount}";
        }

        // Method overloading to define different roles of a manager
        public static void DefineManagerRole(string role)
        {
            Console.WriteLine($"Manager's Role: {role}");
        }

        public static void DefineManagerRole(string role, string responsibility)
        {
            Console.WriteLine($"Manager's Role: {role}, Responsibility: {responsibility}");
        }
        public static void DefineManagerRole(string role, int level)
        {
            Console.WriteLine($"Manager's Role: {role}, Level: {level}");
        }
    }
}

