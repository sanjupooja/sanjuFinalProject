
import UIKit
var remindData : String?
class ReminderPopUpView: UIViewController,PopupContentViewController {

    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var timePickLabel: UILabel!
    @IBOutlet weak var dateLabelPick: UILabel!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
       // popUpView.layer.cornerRadius = 20
       // popUpView.layer.masksToBounds = true
        self.showAnimate()
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadLabel), name: NSNotification.Name(rawValue: "load"), object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(setReminder(Notification:)), name: NSNotification.Name("selectReminder"), object: nil)
       // NotificationCenter.default.post(name: NSNotification.Name("selectReminder"), object: nil,userInfo:["Sanju":"sanju"])
        
         NotificationCenter.default.addObserver(self, selector: #selector(reminderTimeClock), name: NSNotification.Name("selectedTime"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderDatePicker), name: NSNotification.Name("selectedDate"), object: nil)
    }
    func loadLabel() {
        dateLabelPick.text = dateLabel
        timePickLabel.text = timeLabel
        remindLabel.text = remindRepeat
    }
    func reminderTimeClock() {
       
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.bottom) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                    
                ]
            )
            .didShowHandler { _ in
                
                print("opened")
                
            }
            .didCloseHandler { _ in
                print("closed")
                
            }.show(CustomTimeClockView.instance())
        

    }
    func reminderDatePicker() {
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.center) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                    
                ]
            )
            .didShowHandler { _ in
                
                print("opened")
                
            }
            .didCloseHandler { _ in
                print("closed")
                
            }.show(FSCalendarVC.instance())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM dd"
        dateLabel = dateFormate.string(from: date)
        dateLabelPick.text = dateLabel
        timeLabel = "8:00 AM"
        timePickLabel.text = timeLabel
        remindRepeat = "Does Not Repeat"
        remindLabel.text = remindRepeat
        
    }
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 300, height: 300)
    }

    @IBAction func userDidTimesBtnClk(_ sender: Any) {
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.mychoise2) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                    
                ]
            )
            .didShowHandler { _ in
                
                print("opened")
                
            }
            .didCloseHandler { _ in
                print("closed")
                
            }.show(PopUpDatePickVC.instance())
    }
    @IBAction func userDidOptionRemBtnClk(_ sender: Any)
    {
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.mychoise1) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                    
                ]
            )
            .didShowHandler { _ in
                
                print("opened")
                
            }
            .didCloseHandler { _ in
                print("closed")
                
            }.show(PopUpReminderVC.instance())
    }

    @IBAction func userDidSaveReminderBtnClk(_ sender: Any) {
        
        let reminderPicked = dateLabelPick.text!+","+timePickLabel.text!
        remindData = reminderPicked
        NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.01), execute: {
            self.removeAnimate()
        })
    }
    
    @IBAction func userDidCloseBtnClk(_ sender: Any) {
        
    self.removeAnimate()
    }
    
    @IBAction func didClkDateButton(_ sender: Any) {
       
        let pop = PopupController
            
            .create(self)
            .customize(
                [     .layout(.mychoise) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                    
                ]
            )
            .didShowHandler { _ in
                
                print("opened")
                
            }
            .didCloseHandler { _ in
       print("closed")
                
        }
        
        pop.show(PopUpTableVC.instance())
    }
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
        
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            self.view.alpha = 0.0
        },completion :{(finished : Bool) in
            if(finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}
