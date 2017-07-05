
import UIKit
var checkView = String()
class PopUpDeleteVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController {
    @IBOutlet weak var tableView: UITableView!

    
    var menuBarOptionArray : [String] = ["UnArchive","Delete","Make a Copy","Send","Copy to Google Docs"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
        
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 170, height: 230)
    }
    class func instance(result : String) -> PopUpDeleteVC {
    
        checkView = result
        let storyboard = UIStoryboard(name: "PopUpDeleteVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpDeleteVC
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuBarOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell") as! PopUpDeleteVCCell
        cell.popUpOptionLabel.text = menuBarOptionArray[indexPath.row]
        
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.clipsToBounds = true
        cell.layer.masksToBounds = false
        cell.contentView.backgroundColor = UIColor.brown
        //cell.layer.masksToBounds = true
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            if checkView == "archive"
            {
                NotificationCenter.default.post(name: NSNotification.Name("UnArchiveCell"), object: nil)
                self.view.removeFromSuperview()
                
            }
            else
            {
                
            }
            
            break
        case 1:
            if checkView == "inbox"{
                NotificationCenter.default.post(name: NSNotification.Name("deleteCell"), object: nil)
                self.view.removeFromSuperview()
            }
            else
            {
                if checkView == "archive" {
                    NotificationCenter.default.post(name: NSNotification.Name("deleteArchiveData"), object: nil)
                    self.view.removeFromSuperview()
                    
                }
            }
            
            
            break
        default:
            break
        }
    }
   
    

}
