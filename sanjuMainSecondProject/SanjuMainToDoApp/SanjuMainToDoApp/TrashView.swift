

import UIKit
import Firebase
class TrashView: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var slideMenuButton: UIButton!
    var trashData = [[String:String]]()
   // var data = [[String:String]]()
    var layout : CHTCollectionViewWaterfallLayout!
    var isSelected : Bool = false
    var tempTrashArray = [Int]()
    var showMsgNotselectCell = UILabel()
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            slideMenuButton.addTarget(self.revealViewController(),
                                      action:#selector(SWRevealViewController.revealToggle(_:)),for:.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let nib = UINib(nibName: "ArchiveReminderCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "ArchiveReminderCell")
        layout = self.collectionview.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        self.fetchingFRData()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(TrashView.handleLongGesture(_:)))
        self.collectionview.addGestureRecognizer(longPressGesture)
        collectionview.allowsMultipleSelection = false
        
        
        self.showMsgNotselectCell.frame = CGRect(x: 80, y: 300, width: 200, height: 40)
        self.showMsgNotselectCell.backgroundColor = UIColor.black
        self.showMsgNotselectCell.textColor = UIColor.white
        self.showMsgNotselectCell.textAlignment = NSTextAlignment.center
        self.showMsgNotselectCell.font=UIFont.systemFont(ofSize: 18)
        self.showMsgNotselectCell.isHidden = true
        self.showMsgNotselectCell.numberOfLines = 1
        self.showMsgNotselectCell.layer.cornerRadius = 10
        self.showMsgNotselectCell.layer.masksToBounds = true
        self.view.addSubview(self.showMsgNotselectCell)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCellDeleteForever(results : )), name: NSNotification.Name("selectedCell"), object: nil)
    }
    
    func selectedCellDeleteForever(results:Notification) {

         if tempTrashArray.isEmpty
         {
            
            if trashData.isEmpty
            {
                self.showMsgNotselectCell.isHidden = false
                self.showMsgNotselectCell.text = "Empty Trash!!"
            }
            else
            {
                self.showMsgNotselectCell.text = "Select cell first!!"
                self.showMsgNotselectCell.isHidden = false
            }
        
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute: {
                self.showMsgNotselectCell.isHidden = true
                
            })
            collectionview.allowsMultipleSelection = false
            isSelected = false

        }
        else
         {
            tempTrashArray = tempTrashArray.sorted(by: >)
          for item in tempTrashArray
          {
            self.removeTrashDataFromFIR(indexValue: item)
            trashData.remove(at: item)
            let indexPath = IndexPath(row: item, section: 0)
           collectionview.deleteItems(at: [indexPath])
            
          }
           tempTrashArray.removeAll()
            collectionview.allowsMultipleSelection = false
            isSelected = false
            collectionview.reloadData()
            self.showMsgNotselectCell.isHidden = false
            showMsgNotselectCell.text = "Deleted permanentally!!"
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+4), execute: {
                self.showMsgNotselectCell.isHidden = true
                
            })
        }
    }
    func removeTrashDataFromFIR(indexValue : Int)  {
        
        let uid = Auth.auth().currentUser?.uid
        let tempData = self.trashData[indexValue]
        let ref = Database.database().reference().child("UserDatabase").child(uid!).child("TrashData").child(tempData["key"]!)
        ref.removeValue()
    }

    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            let selectedIndexPath = self.collectionview.indexPathForItem(at: gesture.location(in: self.collectionview))
            self.isSelected = true
            let cell = collectionview.cellForItem(at: selectedIndexPath!) as! ArchiveReminderCell
            cell.layer.opacity = 0.3
            tempTrashArray.append((selectedIndexPath?.row)!)
            collectionview.beginInteractiveMovementForItem(at: selectedIndexPath!)
            
        case UIGestureRecognizerState.changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            collectionview.allowsMultipleSelection = false
            isSelected = false
            
        case UIGestureRecognizerState.ended:
            collectionview.endInteractiveMovement()
            
        default:
            collectionview.cancelInteractiveMovement()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = trashData.remove(at: sourceIndexPath.item)
        trashData.insert(temp, at: destinationIndexPath.item)
        
    }
    
    
    @IBAction func userDidSearchBtnClk(_ sender: Any) {
        
        performSegue(withIdentifier: "searchTrash", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTrash" {
            let vc = segue.destination as! SearchVC
            vc.searchData = "Search within Trash"
            vc.searchTask = trashData
        }
    }
    
    @IBAction func userDidDeleteForeverBtnClk(_ sender: Any) {
        
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.top) ,
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
                
            }.show(CellDeleteForever.instance())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //let color = UIColor(red: 257/255, green: 185/255, blue: 15/255, alpha: 1)
        //navigationController?.navigationBar.barTintColor = color
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(hex: "F0F8FF")
        collectionview.reloadData()
        
        self.showMsgNotselectCell.isHidden = true
        /*
        if trashArray.isEmpty
        {
        let showLabel = UILabel()
        showLabel.frame = CGRect(x: 100, y: 330, width: 200, height: 40)
        showLabel.text = "Empty Trash!!"
        showLabel.textColor = UIColor(hex:"778899")
        showLabel.backgroundColor = UIColor.clear
       showLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.view.addSubview(showLabel)
        self.view.backgroundColor = UIColor(hex: "FFFFE0")
        }
        */
    }
    
    
    func fetchingFRData(){
        let ref = Database.database().reference().child("UserDatabase").child((Auth.auth().currentUser?.uid)!)
        
        ref.child("TrashData").observeSingleEvent(of: .value, with: {
            snapshot in
            for key in snapshot.children
            {
                let taskKey = (key as! DataSnapshot).key
                
                let data = (key as! DataSnapshot).value as! [String:String]
                
                let dict = ["title":data["title"],"notes":data["notes"],"reminderDate":data["reminderDate"],"color":data["color"],"key":taskKey]
                
                self.trashData.append(dict as! [String:String])
                
            }
            self.collectionview.reloadData()
        })
    }
    
    func numberOfCoulom() -> Int {
        
        return 2
        }
    func sectionInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }

    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension TrashView : CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
            
            let labelWidth = (self.collectionview.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+self.layout.minimumColumnSpacing))/2
            let note = trashData[indexPath.row]["notes"]! as String
            let tittle = trashData[indexPath.row]["title"]! as String
           // let remindDate = trashData[indexPath.row]["reminderDate"]! as String
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            let noteHeight = self.heightForView(text: note, font: labelFont!, width:labelWidth)
            
            //let remindDateHeight = self.heightForView(text: remindDate, font: labelFont!, width:labelWidth)
            let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:labelWidth)
            let totalHeight = noteHeight+40+tittleHeight
            return CGSize(width: labelWidth, height: totalHeight)
    }
}

extension TrashView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trashData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArchiveReminderCell", for: indexPath) as! ArchiveReminderCell
        cell.cellview.backgroundColor = UIColor(hex: trashData[indexPath.row]["color"]! as String)
        cell.tittle.text = trashData[indexPath.row]["title"]! as String
        cell.notes.text = trashData[indexPath.row]["notes"]! as String
        cell.remindDate.text = trashData[indexPath.row]["reminderDate"]! as String
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.clipsToBounds = true
        cell.layer.masksToBounds = false
        cell.contentView.layer.masksToBounds = true
        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelected{
            collectionview.allowsMultipleSelection = true
            let cell = collectionview.cellForItem(at: indexPath) as! ArchiveReminderCell
            cell.layer.opacity = 0.3
            tempTrashArray.append(indexPath.row)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionview.cellForItem(at: indexPath) as! ArchiveReminderCell
        if tempTrashArray.contains(indexPath.row)
        {
            let location = tempTrashArray.index(of: indexPath.row)
            tempTrashArray.remove(at: location!)
            cell.layer.opacity = 1
        }

    }
    

}
