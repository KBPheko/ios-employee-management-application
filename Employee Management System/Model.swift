//
//  Model.swift
//  Employee Management System
//
//  Created by DA MAC M1 151 on 2023/05/24.
//


import Foundation


struct Employee: Codable {
    let employeeNumber: Int
    let firstName, middleName, surname, email: String
    let department: String
}

    

