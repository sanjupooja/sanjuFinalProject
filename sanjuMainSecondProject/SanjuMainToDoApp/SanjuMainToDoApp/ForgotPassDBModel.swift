
//MARK : THIS IS DB - MANAGER INTERACT WITH FIREBASE

import UIKit
import Firebase
class ForgotPassDBModel: NSObject {
    
    // DECLARED INSTANCE VARIABLE
    var userEmail : String? = nil
    // THIS FUNC USED TO SEND MSG TO UR GMAIL FOR HOW TO CHANGE USER PASSWORD
    func userForgotPasswordReset(completionHandler:@escaping (_ result:Bool) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (error) in
            if error == nil
            {
                // print("An email with information how to reset password has been send to you. Thank You")
                completionHandler(true)
            }
            else{
                
                //print("Error")
                completionHandler(false)
            }
            
        })
        
        
    }
    

}
