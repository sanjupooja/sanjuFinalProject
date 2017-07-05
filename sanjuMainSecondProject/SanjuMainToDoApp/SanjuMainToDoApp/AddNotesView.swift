
// MARK : PURPOSE
// 1 : THIS CLASS IS HANDLE THE VIEW CONTROLLER 
// 2 : THIS CLASS FUNC IS USED FOR ADD A USER TASK INTO THE FIREBASE
// 3 : UPDATE THE USER TASK FROM FIREBASE

// IMPORTED NECCESSARY HEADER FILES FOR FIREBASE
import UIKit
import Firebase
class AddNotesView: UIViewController,UIPickerViewDelegate,UITextFieldDelegate,AddNoteProtocol
{
    // MARK : TAKEN OUTLET FOR USER ENTERED TEXT FIELD
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var tittle: UITextField!
    
    // MARK : DECLARED CLASS VARIABLE & DICTIONARY
    var checkView : String? = nil
    var tempData = [String:String]()
    var notes = [String : String]()
    let showMsg = UILabel()
    var addNotePresenterObjRef : AddNotePresenterController!
   
    // MARK : AT LOADING TIME IT IS EXECUTED AT ONLY ONE TIME
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
        showMsg.frame = CGRect(x: 90, y: 300, width: 200, height: 40)
        showMsg.backgroundColor = UIColor.lightGray
        showMsg.textColor = UIColor.black
        showMsg.textAlignment = NSTextAlignment.center
        showMsg.font=UIFont.systemFont(ofSize: 15)
        showMsg.isHidden = true
        showMsg.numberOfLines = 2
        showMsg.layer.cornerRadius = 20
        showMsg.layer.masksToBounds = true
        self.view.addSubview(showMsg)
     
        
        self.showAnimate()
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderData), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    //MARK : IT IS EXECUTED WHEN VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        
        if tempData.count > 0 {
               tittle.text = tempData["title"]! as String
                descript.text = tempData["notes"]! as String
                datePickerTxt.text = tempData["reminderDate"]
        }
    }
    //MARK : THIS FUNC IS USED FOR WHEN USER PICK A REMINDER IT WILL BE EXECUTED
    func loadReminderData()
    {
        if remindData != nil
        {
            datePickerTxt.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            datePickerTxt.text = remindData
        }
    }

    // MARK : THIS OUTLET FUNC USED FOR OPEN A REMINDER POPUP VIEW
    @IBAction func userDidReminderBtnClk(_ sender: Any)
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "reminderPopUpView") as! ReminderPopUpView
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    // MARK : THIS OUTLET FUNC USED FOR SAVE USER TASK
    @IBAction func userDidAddNoteBtnClk(_ sender: Any)
    {
        if (descript.text.isEmpty && (tittle.text?.isEmpty)!)
        {
            self.onErrorMsg(error: "please Take Notes!!")
        }
        else
        {
        self.pushUserNotesIntoPresenter { (pushedResults) in
            if pushedResults
            {
            self.onSuccessMsg(success: "successfull added!!")
                NotificationCenter.default.post(name: NSNotification.Name("loadCollectionView"), object: nil)
            }
            else
            {
                self.onErrorMsg(error: "Oops!! something went wrong!!")
            }
          }
        }
    }
    // MARK : THIS HANDLE FUNC USED FOR SEND USER DATA INTO PRESENTER
    func pushUserNotesIntoPresenter(completionHandler:@escaping (_ result:Bool) -> Void) {
        
        if checkView == nil
        {
            notes = ["title" : tittle.text!,"notes": descript.text!,"reminderDate":datePickerTxt.text as Any,"color": "0xFFFFFF"] as [String : Any] as! [String : String]
            addNotePresenterObjRef = AddNotePresenterController()
            addNotePresenterObjRef.tempPostData = notes
            addNotePresenterObjRef.checkResults = checkView
            addNotePresenterObjRef.sendNotesDataModel(completionHandler: { (postNotesResult) in
                if postNotesResult
                {
                    completionHandler(true)
                }
                else
                {
                    completionHandler(true)
                }
            })
        }
        else
        {
            if checkView == "updateNotes"
            {
            notes = ["title" : tittle.text!,"notes": descript.text!,"reminderDate":datePickerTxt.text as Any,"key" : tempData["key"] as Any,"userNotes": tempData["notes"] as Any,"color":tempData["color"] as Any] as [String : Any] as! [String : String]
            addNotePresenterObjRef = AddNotePresenterController()
            addNotePresenterObjRef.tempPostData = notes
            addNotePresenterObjRef.checkResults = checkView
            addNotePresenterObjRef.sendNotesDataModel(completionHandler: { (postNotesResult) in
                if postNotesResult
                {
                    completionHandler(true)
                }
                else
                {
                    completionHandler(true)
                }
            })
            }
            else
            {
                notes = ["title" : tittle.text!,"notes": descript.text!,"reminderDate":datePickerTxt.text as Any,"key" : tempData["key"] as Any,"userNotes": tempData["notes"] as Any,"color":tempData["color"] as Any] as [String : Any] as! [String : String]
                addNotePresenterObjRef = AddNotePresenterController()
                addNotePresenterObjRef.tempPostData = notes
                addNotePresenterObjRef.checkResults = checkView
                addNotePresenterObjRef.sendNotesDataModel(completionHandler: { (postNotesResult) in
                    if postNotesResult
                    {
                        completionHandler(true)
                    }
                    else
                    {
                        completionHandler(true)
                    }
                })
            }
    }
    
}
    // MARK : THIS PROTOCOL FUNC USED FOR CALL BACK WHEN SUCCESS
    func onErrorMsg(error: String) {
        showMsg.isHidden = false
        showMsg.text = error
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                self.showMsg.text = ""
                self.showMsg.isHidden = true
        })
    }
    // MARK : THIS PROTOCOL FUNC USED FOR CALL BACK WHEN ERROR
    func onSuccessMsg(success: String) {
        showMsg.isHidden = false
        showMsg.text = success
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute:
            {
                self.showMsg.text = ""
                self.showMsg.isHidden = true
                self.removeAnimate()
        })
    }
    // MARK : THIS ANIMATE FUNC USED WHEN VIEW WILL APPEARS
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 0.7,y: 0.7)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
        
    }
    
    // MARK : THIS ANIMATE FUNC USED WHEN VIEW WILL REMOVE
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
            self.view.alpha = 0.0
        },
                       completion :
            {
                (finished : Bool) in
                if(finished)
                {
                    self.view.removeFromSuperview()
                }
        })
    }
}
 
 
