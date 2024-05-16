using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab07
{
    class Program
    {
        static void Main(string[] args)
        {
            // Creating a Manager object
            Manager manager1 = new Manager(22, 2, "Jack", "Electronic", 30, 16.5, 1000);

            // Printing Manager's information
            Console.WriteLine(manager1);

            // Calculating and printing Manager's salary
            Console.WriteLine($"Manager's Salary: {manager1.CalcSalary()}");


            Console.WriteLine();

            Manager.DefineManagerRole("Project Manager");
            Manager.DefineManagerRole("Department Manager", "Production Department");
            Manager.DefineManagerRole("Senior Manager", 2);

            Console.ReadLine();
        }
    }
}
