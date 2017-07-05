//
//MARK : THIS IS VIEW CONTROLLER TO HANDLE THE VIEW

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgotPasswordController: UIViewController {
    
    //MARK : OUTLET FOR BUTTON
    @IBOutlet weak var forgotView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var userEmailTxt: UITextField!
    var forgotPassObjRef : ForgotPasswordPresenter!
    
    //ITS EXECUTE WHEN VIEW IS LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        self.forgotView.layer.shadowColor = UIColor.black.cgColor
        self.forgotView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.forgotView.layer.shadowOpacity = 2.0
        self.forgotView.layer.shadowRadius = 2
        self.forgotView.layer.borderWidth = 4
        self.forgotView.layer.borderColor = UIColor.white.cgColor
        self.forgotView.layer.cornerRadius = 15
        self.forgotView.layer.masksToBounds = false
        self.forgotView.clipsToBounds = true
        self.backBtn.layer.cornerRadius = 25
        self.backBtn.layer.borderWidth = 2
        self.backBtn.layer.borderColor = UIColor.white.cgColor
        self.forgotPassBtn.layer.cornerRadius = 25
        self.forgotPassBtn.layer.borderWidth = 2
        self.forgotPassBtn.layer.borderColor = UIColor.white.cgColor
        self.userEmailTxt.layer.cornerRadius = 25
        self.userEmailTxt.layer.borderWidth = 2
        self.userEmailTxt.layer.borderColor = UIColor.white.cgColor
        self.userEmailTxt.layer.shadowColor = UIColor.white.cgColor
        self.userEmailTxt.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.userEmailTxt.layer.shadowOpacity = 2.0
        self.userEmailTxt.layer.shadowRadius = 2
        self.userEmailTxt.layer.masksToBounds = false
        self.userEmailTxt.clipsToBounds = true
    }
    //MARK : THIS FUNC USED FOR COME BACK TO PARENT VIEW AND REMOVED THE SUBVIEW

    @IBAction func userDidBackBtnClk(_ sender: Any) {
        
        self.view.removeFromSuperview()
        
    }
    //MARK : THIS FUNC USED FOR OPEN A RESET PASSWORD VIEW 
    @IBAction func userDidResetPassBtnClk(_ sender: Any) {
        
        if (userEmailTxt.text?.isEmpty)! {
            userEmailTxt.textColor = UIColor.red
            userEmailTxt.text = "Enter Valid Email"
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userEmailTxt.textColor = UIColor.darkGray
                self.userEmailTxt.text = ""
            })
        }
        else
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: userEmailTxt.text) != true
            {
                userEmailTxt.textColor = UIColor.red
                userEmailTxt.text = "Email formate @gmail.com"
                DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                    self.userEmailTxt.textColor = UIColor.darkGray
                    self.userEmailTxt.text = ""
                })

            }
            else
            {
                forgotPassObjRef = ForgotPasswordPresenter()
                forgotPassObjRef.userEmail = userEmailTxt.text
                forgotPassObjRef.forgotPasswordReset(completionHandler: { (result) in
                    
                    if result{
                        
                        let alertController = UIAlertController(title: "Sent OTP", message: "An email with information how to reset password has been send to you. Thank You", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { Void in
                            
                            self.view.removeFromSuperview()
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        
                    }
                })
                
            }

            
        }
    }
}
