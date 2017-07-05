
//MARK : THIS IS PRESENTER CLASS ITS HANDLES THE BUSINESS LOGIC

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ForgotPasswordPresenter: NSObject {

    var userEmail : String? = nil
    var modelObjRef : ForgotPassDBModel?
    
    func forgotPasswordReset(completionHandler:@escaping (_ result:Bool) -> Void) {
    
        if userEmail != nil
        {
            modelObjRef = ForgotPassDBModel()
            modelObjRef?.userEmail = userEmail
            modelObjRef?.userForgotPasswordReset(completionHandler: { (results) in
                if results
                {
                    completionHandler(true)
                }
                else
                {
                    completionHandler(false)
                }
            })
        }
    }
}
