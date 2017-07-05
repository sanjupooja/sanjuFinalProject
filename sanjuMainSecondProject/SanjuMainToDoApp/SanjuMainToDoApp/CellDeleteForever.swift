

import UIKit

class CellDeleteForever: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 180, height: 60)
    }
    class func instance() -> CellDeleteForever{
        let storyboard = UIStoryboard(name: "CellDeleteForever", bundle: nil)
        return storyboard.instantiateInitialViewController() as! CellDeleteForever
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"DeleteForever") as! DeleteForeverCell
        cell.deleteForever.text = "Delete forever"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            NotificationCenter.default.post(name: NSNotification.Name("selectedCell"), object: nil,userInfo:["results":"True"])
            
            self.view.removeFromSuperview()
        }
        
        
    }
}
