
import UIKit
import Firebase
import SVProgressHUD
import  Canvas
class RegisterView: UIViewController,AddNoteProtocol
{
    
    @IBOutlet weak var regView: CSAnimationView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var userPhoneNo: UITextField!
    @IBOutlet weak var userPassTxt: UITextField!
    var regPresenterObjRef = RegisterPresenter()
    var labelShowMsg = UILabel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        labelShowMsg.frame = CGRect(x: 80, y: 600, width: 250, height: 50)
        labelShowMsg.backgroundColor = UIColor.black
        labelShowMsg.textColor = UIColor.white
        labelShowMsg.textAlignment = NSTextAlignment.center
        labelShowMsg.font=UIFont.systemFont(ofSize: 16)
        labelShowMsg.isHidden = true
        labelShowMsg.numberOfLines = 2
        regView.layer.cornerRadius = 25
        regView.layer.borderWidth = 2
        regView.layer.borderColor = UIColor.white.cgColor
        regView.layer.masksToBounds = true
        regView.startCanvasAnimation()
        labelShowMsg.layer.cornerRadius = 20
        labelShowMsg.layer.masksToBounds = true
        self.view.addSubview(labelShowMsg)
        
    }
    
    @IBAction func userDidBackBtnClk(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func userRegisterBtnClk(_ sender: Any)
    {
        self.view.alpha = 0.6
        if (userName.text?.isEmpty)! && (userEmailTxt.text?.isEmpty)! && (userPhoneNo.text?.isEmpty)! && (userPassTxt.text?.isEmpty)!
        {
            self.userTappedWithoutData()
        }
        else
        {
            if (userName.text?.isEmpty)!
            {
                self.userNameFailed()
            }
            else
            {
                if (userEmailTxt.text?.isEmpty)!
                {
                    self.userEmailFailed(emailError: "empty")
                }
                else
                {
                    if (userPhoneNo.text?.isEmpty)!
                    {
                        self.userPhoneNoFailed(phoneNoError: "empty")
                    }
                    else
                    {
                        if (userPassTxt.text?.isEmpty)!
                        {
                            self.userPasswordFailed(passwordError: "empty")
                        }
                        else
                        {
                            let regValdResults = regPresenterObjRef.newUserValidation(name: userName.text!, email: userEmailTxt.text!, phoneNo: userPhoneNo.text!, password: userPassTxt.text!)
                            if regValdResults == "Femail"
                            {
                                self.userEmailFailed(emailError: regValdResults)
                            }
                            else
                            {
                                if regValdResults == "Fphone"
                                {
                                    self.userPhoneNoFailed(phoneNoError: regValdResults)
                                }
                                else
                                {
                                    if regValdResults == "Fpass"
                                    {
                                        self.userPasswordFailed(passwordError: regValdResults)
                                    }
                                    else
                                    {
                                       if regValdResults == "success"
                                        {
                                            self.newUserRegister(name: userName.text!, email: userEmailTxt.text!, phoneNo: userPhoneNo.text!, password: userPassTxt.text!)
                                       
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func userNameFailed()
    {
        userName.text = "Name is Madatory"
        userName.textColor = UIColor.red
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
            self.userName.text = ""
            self.userName.textColor = UIColor.black
            })
    }
    
    func userEmailFailed(emailError: String)
    {
        if emailError == "empty"
        {
        userEmailTxt.text = "Email should not be empty "
        userEmailTxt.textColor = UIColor.red
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
            self.userEmailTxt.text = ""
            self.userEmailTxt.textColor = UIColor.black
            })
        }
        else
        {
            userEmailTxt.text = "Invalid Email Formate,@gmail.com"
            userEmailTxt.textColor = UIColor.red
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userEmailTxt.text = ""
                self.userEmailTxt.textColor = UIColor.black
            })

        }
    }
    
    func userPasswordFailed(passwordError: String)
    {
        if passwordError == "empty"
        {
            userPassTxt.text = "Email should not be empty "
            userPassTxt.textColor = UIColor.red
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPassTxt.text = ""
                self.userPassTxt.textColor = UIColor.black
            })
        }
        else
        {
            userPassTxt.text = "password 2 char & 2 digit"
            userPassTxt.textColor = UIColor.red
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPassTxt.text = ""
                self.userPassTxt.textColor = UIColor.black
            })
        }
    }
    
    func userPhoneNoFailed(phoneNoError: String)
    {
        if phoneNoError == "empty"
        {
            userPhoneNo.text = "Email should not be empty "
            userPhoneNo.textColor = UIColor.red
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPhoneNo.text = ""
                self.userPhoneNo.textColor = UIColor.black
            })
        }
        else
        {
            userPhoneNo.text = "enter 10 digit phone no"
            userPhoneNo.textColor = UIColor.red
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPhoneNo.text = ""
                self.userPhoneNo.textColor = UIColor.black
            })
 
        }
    }
    
    func userTappedWithoutData()
    {
        userEmailTxt.text = "Email should not be empty "
        userPassTxt.text = "password should not be Empty "
        userEmailTxt.textColor = UIColor.red
        userPassTxt.textColor = UIColor.red
        userName.text = "Name is Madatory"
        userPhoneNo.text = "valid phone no madatory"
        userPhoneNo.textColor = UIColor.red
        userName.textColor = UIColor.red
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
            self.userEmailTxt.text = ""
            self.userEmailTxt.textColor = UIColor.black
            self.userPassTxt.text = ""
            self.userPassTxt.textColor = UIColor.black
            self.userName.text = ""
            self.userName.textColor = UIColor.black
            self.userPhoneNo.text = ""
            self.userPhoneNo.textColor = UIColor.black
           })
    }
    
    func showPopUpMsg(msg: String)
    {
            }

  func newUserRegister(name:String,email:String,phoneNo:String,password:String)
  {
        
        Auth.auth().createUser(withEmail: email, password: password, completion:
            {
                (user, error) in
                
                if error != nil
                {
                    self.onErrorMsg(error: "you already registered user,Just login!!")
                }
                else
                {
                    let userEmail = email
                    let userPassword = password
                    let Phone = phoneNo
                    let userName = name
                    let profile:[String:String] = [
                        "userName":userName,
                        "userEmail":userEmail,
                        "userPassword":userPassword,
                        "userPhone-No":Phone]
                    let uid = Auth.auth().currentUser?.uid
                    
                    let ref = Database.database().reference()
                    
                    ref.child("UserDatabase").child(uid!).child("UserProfile").setValue(profile)
                    
                    SVProgressHUD.show(withStatus: "Loading..")
                    DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute:
                        {
                            SVProgressHUD.dismiss()
                            self.onSuccessMsg(success: "")
                       })
                }
        })
    }

    
    func onSuccessMsg(success: String) {
        self.labelShowMsg.isHidden = false
        self.labelShowMsg.text = "Registration Completed!!"
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                self.labelShowMsg.text = ""
                self.labelShowMsg.isHidden = true
        })
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(vc!, animated: true, completion: nil)
                
        })

    }
    
    func onErrorMsg(error: String)
    {
        labelShowMsg.isHidden = false
        labelShowMsg.text = error
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                self.labelShowMsg.text = ""
                self.labelShowMsg.isHidden = true
        })

    }
}
