
import UIKit

class RegisterPresenter: NSObject
{
    func newUserValidation(name:String,email:String,phoneNo:String,password:String) -> String {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) != true
        {
            return "Femail"
        }
        else
        {
            let PHONE_REGEX = "[0-9]{10}"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            if phoneTest.evaluate(with: phoneNo) != true
            {
                return "Fphone";
            }
            else
            {
                let str = "^(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
                let passTest = NSPredicate(format:"SELF MATCHES %@", str)
                
                if passTest.evaluate(with: password) != true
                {
                    return "Fpass"
                }
                else
                {
                    return "success"
                }
            }

        }
    }

}


