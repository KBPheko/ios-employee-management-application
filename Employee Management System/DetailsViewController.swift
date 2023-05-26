//
//  DetailsViewController.swift
//  Employee Management System
//
//  Created by DA MAC M1 151 on 2023/05/24.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!

    
    var idLabel: String?
    var firstNameLabel: String?
    var lastNameLabel: String?
    var departmentLabel: String?
    var emailLabel: String?
    var numberLabel: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        idLbl.text = idLabel
        firstNameLbl.text = firstNameLabel
        
        lastNameLbl.text = lastNameLabel
        departmentLbl.text = departmentLabel
        emailLbl.text = emailLabel
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
