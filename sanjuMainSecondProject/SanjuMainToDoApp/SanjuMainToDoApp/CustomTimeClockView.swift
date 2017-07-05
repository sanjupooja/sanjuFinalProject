
import UIKit

class CustomTimeClockView: UIViewController,PopupContentViewController,ESTimePickerDelegate{
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
        let timePicker = ESTimePicker(delegate: self)
        timePicker?.frame = CGRect(x: 25, y: 120, width: 250, height: 250)
        timePicker?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.0)
        self.view.addSubview(timePicker!)
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 300, height: 450)
    }
    class func instance() -> CustomTimeClockView{
        let storyboard = UIStoryboard(name: "CustomTimeClockView", bundle: nil)
        return storyboard.instantiateInitialViewController() as! CustomTimeClockView
    }

    func timePickerHoursChanged(_ timePicker: ESTimePicker!, toHours hours: Int32) {
        
        hourLabel.text = String(hours)
        
    }
    func timePickerMinutesChanged(_ timePicker: ESTimePicker!, toMinutes minutes: Int32) {
        minuteLabel.text = String(minutes)
    }

    @IBAction func userDidDoneBtnClk(_ sender: Any) {
        
            let times = hourLabel.text!+":"+minuteLabel.text!
            timeLabel = times
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            self.view.removeFromSuperview()
        
    }
    
}

