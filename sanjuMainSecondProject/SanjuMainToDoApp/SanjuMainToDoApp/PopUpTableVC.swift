
import UIKit
var dateLabel : String?
class PopUpTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var datePicker = UIDatePicker()
    var arra : [String] = ["Today","Tomorrow","D'After Tomorrow","Pick a Date..."]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
       tableview.dataSource = self
       // self.tableview.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        
        self.view.layer.shadowColor = UIColor.white.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true

    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 500, height: 600)
    }
    class func instance() -> PopUpTableVC{
        let storyboard = UIStoryboard(name: "PopUpTableVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpTableVC
    }

    override func viewWillAppear(_ animated: Bool){
        tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arra.count
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "popupcell") as! PopUpTableVCCell
        cell.label.text = arra[indexPath.row]
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.contentView.clipsToBounds = true
        cell.layer.masksToBounds = false
        cell.contentView.backgroundColor = UIColor.black
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            
            let date = Date()
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "MMMM dd"
            dateLabel = dateFormate.string(from: date)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            
            break
            
        case 1:
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "MMMM dd"
            dateLabel = dateFormate.string(from: tomorrow!)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            break
            
        case 2:
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "MMMM dd"
            dateLabel = dateFormate.string(from: tomorrow!)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            break
        case 3:
            
            NotificationCenter.default.post(name: NSNotification.Name("selectedDate"), object: nil)
            self.view.removeFromSuperview()
            
            break
        default:
            
            break
        }
    }
}

