//
//  EmployeeViewController.swift
//  Employee Management System
//
//  Created by DA MAC M1 151 on 2023/05/24.
//

import UIKit

class EmployeeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var employees = [Employee]()
    
    //to search through the array
    var searchingEmployees = [Employee]()
    
    //setting this variable false cause we're not searching when our app launches
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //http://localhost:8080/employeeapi
        
        fetchApiData(URL: "http://localhost:8080/employeeapi") { result in
            self.employees = result
            print(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    @objc func callPullToRefresh(){
        self.fetchApiData(URL: "http://localhost:8080/employeeapi"){result in
            self.employees = result
            self.searchingEmployees = result
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
    }
    func deleteEmployee(employeeNumber: Int) {
        let urlString = "http://localhost:8080/employeeapi/\(employeeNumber)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 200 {
                // Employee deleted successfully
                print("Employee deleted successfully")
            } else {
                print("Failed to delete employee. Status code: \(httpResponse.statusCode)")
            }
        }

        task.resume()
    }
    
    
    func fetchApiData(URL url: String, completion: @escaping ([Employee]) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let parsingData = try JSONDecoder().decode([Employee].self, from: data)
                completion(parsingData)
            } catch {
                print("Parsing error: \(error)")
            }
        }
        dataTask.resume()
    }
    
    
}


//MARK: - TableView Methods
extension EmployeeViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
   
    //tell the DS to return the number of rows in a given table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchingEmployees.count
        } else {
            return employees.count
        }
    }
    
    //asks DS for a cell to insert into a particular location in a tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmployeeTableViewCell else { return UITableViewCell() }

        
        let employee: Employee
                
                if searching {
                    employee = searchingEmployees[indexPath.row]
                } else {
                    employee = employees[indexPath.row]
                }
                
                cell.idlbl.text = "\(employee.employeeNumber)"
                cell.firstNamelbl.text = employee.firstName
                cell.lastNamelbl.text = employee.surname
                cell.departmentlbl.text = employee.department
        return cell
    }
    
    //Ask for permission to modify rows
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        .delete
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        // Create an alert controller with a title and message
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this cell", preferredStyle: .alert)
        
        // Create a "Yes" action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // Remove the corresponding data from the data source
            self.employees.remove(at: indexPath.row)
            
            // Delete the row from the table view
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        // Add the "Yes" action to the alert
        alert.addAction(yesAction)
        
        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the "Cancel" action to the alert
        alert.addAction(cancelAction)
        
        // Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    //implementation
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let employeeNumberToDelete = employees[indexPath.row].employeeNumber
            deleteEmployee(employeeNumber: employeeNumberToDelete)
            
            tableView.beginUpdates()
            employees.remove(at: indexPath.row)
            //presentDeletionFailsafe(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
        
    }
    

    
    //search bar functionn
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingEmployees = employees.filter {
            $0.firstName.lowercased().contains(searchText.lowercased()) ||
            $0.surname.lowercased().contains(searchText.lowercased()) ||
            $0.department.lowercased().contains(searchText.lowercased())
        }
        searching = !searchText.isEmpty
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ec = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        
        let employee: Employee
        
        if searching {
            employee = searchingEmployees[indexPath.row]
        } else {
            employee = employees[indexPath.row]
        }
        
        ec?.idLabel = "\(employee.employeeNumber)"
        ec?.firstNameLabel = employee.firstName
        ec?.lastNameLabel = employee.surname
        ec?.departmentLabel = employee.department
        ec?.emailLabel = employee.email
        
        self.navigationController?.pushViewController(ec!, animated: true)
    }

    
}
