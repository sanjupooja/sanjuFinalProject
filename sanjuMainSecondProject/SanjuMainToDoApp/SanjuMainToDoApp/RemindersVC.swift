

import UIKit
import FirebaseDatabase
import  Firebase
class RemindersVC: UIViewController
{
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var listGrideButton: UIButton!
    @IBOutlet weak var slidemenubutton: UIButton!
    
    @IBOutlet weak var collectionview: UICollectionView!
    var layout : CHTCollectionViewWaterfallLayout!
    var myReminderData = [[String:String]]()
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    var isGride : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(RemindersVC.handleLongGesture(_:)))
        self.collectionview.addGestureRecognizer(longPressGesture)
        
        let nib = UINib(nibName: "ArchiveReminderCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "ArchiveReminderCell")
        layout = self.collectionview.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        let ref = Database.database().reference().child("UserDatabase").child((Auth.auth().currentUser?.uid)!)
        
        ref.child("ReminderNotes").observeSingleEvent(of: .value, with: {
            snapshot in
            for key in snapshot.children {
                let taskKey = (key as! DataSnapshot).key
                
                let data = (key as! DataSnapshot).value as! [String:String]
                
                let dict = ["title":data["title"],"notes":data["notes"],"reminderDate":data["reminderDate"],"color":data["color"],"key":taskKey]
                
                self.myReminderData.append(dict as! [String:String])
                
            }
            self.collectionview.reloadData()
        })

        if self.revealViewController() != nil {
            slidemenubutton.addTarget(self.revealViewController(),
                                      action:#selector(SWRevealViewController.revealToggle(_:)),for:.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

   func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    
    return label.frame.height
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //let color = UIColor(red: 257/255, green: 185/255, blue: 15/255, alpha: 1)
        self.collectionview.reloadData()
       // barView.backgroundColor = color
        navigationController?.isNavigationBarHidden = true
    }
    func collectionTableData(_ sender : UIBarButtonItem) {
        if isGride {
            listGrideButton.setImage(UIImage(named:"whiteTable"),for:UIControlState.normal)
            isGride = false
        }
        else {
            listGrideButton.setImage(UIImage(named:"whiteGride"),for:UIControlState.normal)
            isGride = true
        }
        self.collectionview.reloadData()
    }
    
        func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionview.indexPathForItem(at: gesture.location(in: self.collectionview)) else {
                break
            }
            collectionview.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }

    @IBAction func userDidListGrideBtnClk(_ sender: Any) {
        if isGride {
            listGrideButton.setImage(UIImage(named:"whiteTable"),for:UIControlState.normal)
            isGride = false
        }
        else {
            isGride = true
            listGrideButton.setImage(UIImage(named:"whiteGride"),for:UIControlState.normal)
        }
        self.collectionview.reloadData()
    }
    
    @IBAction func userDidSearchBtnClk(_ sender: Any) {
        
        performSegue(withIdentifier: "searchReminder", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchReminder" {
            let vc = segue.destination as! SearchVC
            vc.searchData = "Search within Reminders"
            vc.searchTask = myReminderData
        }
    }

    func numberOfCoulom() -> Int {
        if isGride{
            return 2
        }
        else {
            return 1
        }
    }

    func sectionInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: -5, left: 10, bottom: 10, right: 10)
    }
}

 extension RemindersVC : CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if isGride != true {
            let note = myReminderData[indexPath.row]["notes"]! as String
            let tittle = myReminderData[indexPath.row]["title"]! as String
            let remindDate = myReminderData[indexPath.row]["reminderDate"]! as String
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            let noteHeight = self.heightForView(text: note, font: labelFont!, width:(view.bounds.width - 40))
            let dateHeight = self.heightForView(text:remindDate, font: labelFont!, width:(view.bounds.width - 40))
            let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:(view.bounds.width - 40))
            let totalHeight = noteHeight+tittleHeight+dateHeight
            if remindDate == "" {
                
                return CGSize(width: (view.bounds.width - 40), height: totalHeight+20)
            }
            else
            {
                return CGSize(width: (view.bounds.width - 40), height: totalHeight+30)
            }

        }
        else {
            
        let labelWidth = (self.collectionview.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+self.layout.minimumColumnSpacing))/2
        let note = myReminderData[indexPath.row]["notes"]! as String
        let tittle = myReminderData[indexPath.row]["title"]! as String
        let remindDate = myReminderData[indexPath.row]["reminderDate"]! as String
        let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
        let noteHeight = self.heightForView(text: note, font: labelFont!, width:labelWidth)
        let dateHeight = self.heightForView(text:remindDate, font: labelFont!, width:labelWidth)
        let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:labelWidth)
        let totalHeight = noteHeight+tittleHeight+dateHeight
            if remindDate == "" {
                
                return CGSize(width:labelWidth, height: totalHeight+20)
            }
            else
            {
                return CGSize(width: labelWidth, height: totalHeight+30)
            }


        }
    }
}

extension RemindersVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myReminderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "ArchiveReminderCell", for: indexPath) as! ArchiveReminderCell
        cell.tittle.text = myReminderData[indexPath.row]["title"]! as String
        cell.notes.text = myReminderData[indexPath.row]["notes"]! as String
    
        cell.remindDate.text = myReminderData[indexPath.row]["reminderDate"]! as String
        let color = myReminderData[indexPath.row]["color"]! as String
        cell.cellview.backgroundColor = UIColor(hex: color)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        cell.contentView.clipsToBounds = true
        cell.layer.masksToBounds = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = myReminderData.remove(at: sourceIndexPath.item)
        myReminderData.insert(temp, at: destinationIndexPath.item)
        self.collectionview.collectionViewLayout.invalidateLayout()
        self.collectionview.setCollectionViewLayout(layout, animated: false)
        self.collectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}







