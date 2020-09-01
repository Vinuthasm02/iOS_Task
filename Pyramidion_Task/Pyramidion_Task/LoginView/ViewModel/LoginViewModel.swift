//
//  LoginViewModel.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func isEmailValid(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassWordAndReturnRespectMessage(password: String) -> String?{
        if password.count >= 8 {
            let uppercaseRegEx = ".*[A-Z]+.*"

            let uppercasePred = NSPredicate(format:"SELF MATCHES %@", uppercaseRegEx)
            if !uppercasePred.evaluate(with: password) {
                return "Please enter atleast one upper case"
            }
            let lowercaseRegEx = ".*[a-z]+.*"

            let lowercasePred = NSPredicate(format:"SELF MATCHES %@", lowercaseRegEx)
            if !lowercasePred.evaluate(with: password) {
                return "Please enter atleast one lower case"
            }
            let numericRegEx = ".*[0-9]+.*"

            let numericPred = NSPredicate(format:"SELF MATCHES %@", numericRegEx)
            if !numericPred.evaluate(with: password) {
                return "Please enter atleast one numeric"
            }
            let specialCharacterRegEx = ".*[!&^%$#@()/_*+-]+.*"

            let specialCharacterPred = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if !specialCharacterPred.evaluate(with: password) {
                return "Please enter atleast one special character"
            }
            return nil
        } else {
            return "Please enter min 8 character password"
        }
    }
}
