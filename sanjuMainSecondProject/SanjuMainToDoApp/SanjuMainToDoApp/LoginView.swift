

import UIKit
import Firebase
import SVProgressHUD
import Canvas
import FBSDKLoginKit
class LoginView : UIViewController,AddNoteProtocol,GIDSignInUIDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate
{
    @IBOutlet weak var loginBtnView: CSAnimationView!
    @IBOutlet weak var logGView: CSAnimationView!
    @IBOutlet weak var logFView: CSAnimationView!
    @IBOutlet weak var userPassTxt: UITextField!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var loginFBtn: UIButton!
    @IBOutlet weak var loginGBtn: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    var loginPresenterObjRef : LoginPresenter?
    var labelShowMsg = UILabel()
    var validResult:String?
    override func viewDidLoad()
    {
       super.viewDidLoad()
       self.view.alpha = 0.9
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        logoImage.layer.cornerRadius = logoImage.frame.width/2
        logoImage.layer.masksToBounds = true
       // logoImage.layer.borderWidth = 1
    
        let fbloginBtn = FBSDKLoginButton()
        fbloginBtn.frame = CGRect(x: 90, y: 580, width: 200, height: 40)
        fbloginBtn.delegate = self
        self.view.addSubview(fbloginBtn)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.borderColor = UIColor.white.cgColor
        loginFBtn.layer.borderWidth = 2
        loginFBtn.layer.borderColor = UIColor.white.cgColor
        loginGBtn.layer.borderWidth = 2
        loginGBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.layer.cornerRadius = 25
        loginGBtn.layer.cornerRadius = 25
        loginFBtn.layer.cornerRadius = 25
        labelShowMsg.frame = CGRect(x: 90, y: 580, width: 200, height: 40)
        labelShowMsg.backgroundColor = UIColor.lightGray
        labelShowMsg.textColor = UIColor.black
        labelShowMsg.textAlignment = NSTextAlignment.center
        labelShowMsg.font=UIFont.systemFont(ofSize: 15)
        labelShowMsg.isHidden = true
        labelShowMsg.numberOfLines = 2
        labelShowMsg.layer.cornerRadius = 20
        labelShowMsg.layer.masksToBounds = true
        self.view.addSubview(labelShowMsg)
        logGView.startCanvasAnimation()
        logFView.startCanvasAnimation()
        loginBtnView.startCanvasAnimation()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func userLoginBtnTapped(_ sender: Any) {
        
        if (userEmailTxt.text?.isEmpty)! && (userPassTxt.text?.isEmpty)! {
            self.UserValidationFailed()
        }
        else
        {
            if (userEmailTxt.text?.isEmpty)! {
                self.UserEmailValFailed(email: "emailEmpty")
            }
            else {
                if (userPassTxt.text?.isEmpty)! {
                    self.UserPassValiFailed(pass: "passEmpty")
                }
                else {
                    loginPresenterObjRef = LoginPresenter()
                validResult = loginPresenterObjRef?.userEmailPassAuthentication(email: userEmailTxt.text!, password: userPassTxt.text!)
                    
                    if validResult == "FEmail" {
                        self.UserEmailValFailed(email: "FEmail")
                    }
                    else {
                        if validResult == "FPass" {
                            self.UserPassValiFailed(pass: "FPass")
                        }
                        else {
                            if validResult == "success" {
                                loginPresenterObjRef = LoginPresenter()
                                
                                if LoginPresenter.isConnectedToNetwork() {
                                    self.userLoginAuthChecking(email: userEmailTxt.text!, password: userPassTxt.text!)
                                }
                                else {
                                    
                                    SVProgressHUD.setBackgroundColor(UIColor.clear)
                                    SVProgressHUD.setForegroundColor(UIColor.black)
                                    SVProgressHUD.setDefaultStyle(.custom)
                                    SVProgressHUD.show()
                                    DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+4), execute: {
                                        
                                        SVProgressHUD.dismiss()
                                        self.labelShowMsg.frame = CGRect(x: 80, y: 300, width: 200, height: 100)
                                        self.labelShowMsg.backgroundColor = UIColor.lightGray
                                        self.labelShowMsg.textColor = UIColor.black
                                        self.labelShowMsg.textAlignment = NSTextAlignment.center
                                        self.labelShowMsg.font=UIFont.systemFont(ofSize: 18)
                                        self.labelShowMsg.isHidden = false
                                        self.labelShowMsg.numberOfLines = 3
                                        self.labelShowMsg.text = "Network Error!!  No Internet Connection!!"
                                        self.labelShowMsg.layer.masksToBounds = true
                                        self.view.addSubview(self.labelShowMsg)
                                        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+6), execute: {
                                            self.labelShowMsg.text = ""
                                            self.labelShowMsg.isHidden = true
                                            
                                        })

                                    })
                                }
                            }
                        }
                   }
               }
        }
    }
}
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error) != nil {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            let email = GIDSignIn.sharedInstance().currentUser.profile.email
            let name = GIDSignIn.sharedInstance().currentUser.profile.name
            self.labelShowMsg.isHidden = false
            self.labelShowMsg.textColor = UIColor.white
            self.labelShowMsg.backgroundColor = UIColor.black
            self.labelShowMsg.text = "SignIn via G+"+":"+name!
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+4), execute: {
                
                self.labelShowMsg.text = ""
                self.labelShowMsg.isHidden = true
                UserDefaults.standard.set(email, forKey: "userEmail")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(vc!, animated: true, completion: nil)
            })
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    
    @IBAction func userDidFBLoginBtnClk(_ sender: Any) {
        
    }
    
    @IBAction func userDidGoogleSignInBtnClk(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func UserValidationFailed()
    {
        userEmailTxt.text = "Email should not be empty"
        userPassTxt.text = "password should not be Empty"
        userEmailTxt.textColor = UIColor.red
        userPassTxt.textColor = UIColor.red
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
            self.userEmailTxt.text = ""
            self.userEmailTxt.textColor = UIColor.black
            self.userPassTxt.text = ""
            self.userPassTxt.textColor = UIColor.black
        }
        )
    }
    
    @IBAction func userDidForgotPassward(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordController
        popOverVC.view.frame = self.view.frame
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            print("facebook login failed")
        }
        else
        {
            self.labelShowMsg.isHidden = false
            self.labelShowMsg.textColor = UIColor.white
            self.labelShowMsg.backgroundColor = UIColor.black
            self.labelShowMsg.text = "Facebook login success!!"
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+4), execute: {
                
                self.labelShowMsg.text = ""
                self.labelShowMsg.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(vc!, animated: true, completion: nil)
            })

        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout successfull")
        
        
    }
    
    @IBAction func userDidRegisterBtnClk(_ sender: Any)
    {
        
    performSegue(withIdentifier: "register", sender: nil)
    
    }
    func UserEmailValFailed(email : String)
    {
        if email == "emailEmpty"
        {
            userEmailTxt.text = "email should not Empty"
            userEmailTxt.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userEmailTxt.text = ""
                self.userEmailTxt.textColor = UIColor.black
            }
            )
        }
        else
        {
            userEmailTxt.text = "Invalid email Formate!"
            userEmailTxt.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userEmailTxt.text = ""
                self.userEmailTxt.textColor = UIColor.black
            }
            )
        }
    }
    func UserPassValiFailed(pass : String)
    {
        if pass == "passEmpty"
        {
            userPassTxt.text = "password should not be empty!"
            userPassTxt.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPassTxt.text = ""
                self.userPassTxt.textColor = UIColor.black
            }
            )
        }
        else
        {
            userPassTxt.text = "password (7 char & 2 digit must be)!!"
            userPassTxt.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+1), execute: {
                self.userPassTxt.text = ""
                self.userPassTxt.textColor = UIColor.black
            })
        }
    }
    func onErrorMsg(error:String)
    {
        labelShowMsg.isHidden = false
        labelShowMsg.text = error
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                self.labelShowMsg.text = ""
                self.labelShowMsg.isHidden = true
            })
    }
    
    func onSuccessMsg(success : String)
    {
    
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "checking..";
        spinnerActivity.detailsLabel.text = "Authentication!!";
        spinnerActivity.isUserInteractionEnabled = false;
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute: {
            spinnerActivity.hide(animated: true);
            UserDefaults.standard.set(self.userEmailTxt.text!, forKey: "userEmail")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
           self.present(vc!, animated: true, completion: nil)
            
            
        })
    }
    
    func userLoginAuthChecking(email:String,password:String)
    {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil
            {
                self.onErrorMsg(error: "you not registered user!!")
            }
            else
            {
                self.view.alpha = 0.5
                let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
                spinnerActivity.label.text = "checking..";
                spinnerActivity.detailsLabel.text = "Authentication!!";
                spinnerActivity.isUserInteractionEnabled = false;
                DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute: {
                    spinnerActivity.hide(animated: true);
                    
                    self.onSuccessMsg(success: "")
                })
            }
            
        })
    }

    
}
