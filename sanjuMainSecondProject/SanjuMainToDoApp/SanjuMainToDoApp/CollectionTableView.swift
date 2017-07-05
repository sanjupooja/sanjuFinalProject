

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CollectionTableView : UIViewController,PopupContentViewController {
    
    
    @IBOutlet weak var listGrideBtn: UIButton!
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var slideMenuBtn: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var menuBarViewSecond: UIView!
    @IBOutlet weak var bottomOptionView: UIView!
    
    
    var selectedIndexColor : IndexPath?
    var layout : CHTCollectionViewWaterfallLayout!
    var isGride : Bool = true
    var isSelected :Bool = false
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    var myData = [[String:String]]()
    var trashArray = [Int]()
    var testView : UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchingFRData()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CollectionTableView.handleLongGesture(_:)))
        self.collectionview.addGestureRecognizer(longPressGesture)
        
        let nib = UINib(nibName: "RemindMeCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "RemindMeCell")
        layout = self.collectionview.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        
        if self.revealViewController() != nil {
            slideMenuBtn.addTarget(self.revealViewController(),
                                   action:#selector(SWRevealViewController.revealToggle(_:)),for:.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.menuBarViewSecond.isHidden = true
        testView.frame = CGRect(x: 0, y: 580, width: 375, height: 50)
        testView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        self.view.addSubview(testView)
        testView.isHidden = true
        let button = UIButton();
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.frame = CGRect(x: 300, y: 0, width: 60, height: 50)
        button.addTarget(self, action: #selector(CollectionTableView.undoArchivedData(_:)), for: .touchUpInside)
        self.testView.addSubview(button)
        let testViewLabel = UILabel()
        testViewLabel.frame = CGRect(x: 15, y: 0, width: 200, height: 50)
        testViewLabel.backgroundColor = UIColor.clear
        testViewLabel.textColor = UIColor.white
        testViewLabel.textAlignment = NSTextAlignment.center
        testViewLabel.font=UIFont.systemFont(ofSize: 15)
        testViewLabel.numberOfLines = 1
        testViewLabel.text = "Note moved to Archive"
        self.testView.addSubview(testViewLabel)
        self.bottomOptionView.layer.shadowColor = UIColor.black.cgColor
        self.bottomOptionView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.bottomOptionView.layer.shadowOpacity = 2.0
        self.bottomOptionView.layer.shadowRadius = 2
        self.bottomOptionView.layer.masksToBounds = false
        self.bottomOptionView.clipsToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionData), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCollectionCell), name: NSNotification.Name("deleteCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(colorForSelectedCell(colors :)), name: NSNotification.Name("selectedCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionData), name: NSNotification.Name("loadCollectionView"), object: nil)
        
    }
    
    @IBAction func userDidPickColorBtnClk(_ sender: Any) {
        
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
                
            }.show(ColorPickerView.instance())
    }
    
    
    func undoArchivedData(_ sender: Any){
        
    }
    func postColorIntoFIR(color:String) {
        
        let key = myData[(selectedIndexColor?.row)!]["key"]! as String
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("UserDatabase").child(uid!).child("Notes").child(key).updateChildValues(["color": color as String])
    }
    
    func colorForSelectedCell(colors:Notification)  {
        
        if let colorValue = colors.userInfo?["color"] as? String
        {
            let cell = collectionview.cellForItem(at: selectedIndexColor!) as! RemindMeCell
            cell.cellview.backgroundColor = UIColor(hex: colorValue)
            self.menuBarViewSecond.isHidden = true
            collectionview.allowsMultipleSelection = false
            isSelected = false
            cell.layer.opacity = 1
            self.postColorIntoFIR(color: (colors.userInfo?["color"] as! String))
            //myData.removeAll()
           // self.fetchingFRData()
            //collectionview.reloadData()
        
        }
    }
    
    func postTrashData(index:Int)
    {
        
        let title = myData[index]["title"]! as String
        let desc = myData[index]["notes"]! as String
        let reminderDate = myData[index]["reminderDate"]! as String
        let color = myData[index]["color"]! as String
        let note:[String:String] = [
            "title":title,
            "notes":desc,
            "reminderDate": reminderDate,
            "color": color
        ]
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("UserDatabase").child(uid!).child("TrashData").childByAutoId().setValue(note)
        
    }
    func removeTrashDataFromFIR(indexValue : Int)  {
    
        let uid = Auth.auth().currentUser?.uid
        let tempData = self.myData[indexValue]
        
        let ref = Database.database().reference().child("UserDatabase").child(uid!).child("Notes").child(tempData["key"]!)
    
        ref.removeValue()
        
    }
    
    func deleteCollectionCell() {
        
        self.menuBarViewSecond.isHidden = true
        if trashArray.count > 0
        {
            trashArray = trashArray.sorted(by: >)
        for item in trashArray
        {
            self.postTrashData(index: item)
           self.removeTrashDataFromFIR(indexValue: item)
            myData.remove(at: item)
          let indexPath = IndexPath(row: item, section: 0)
          collectionview.deleteItems(at: [indexPath])
            
        }
        
        trashArray.removeAll()
        collectionview.reloadData()
        
        }
    }
    // this is func is fetching data from firebase
    func fetchingFRData(){
        let ref = Database.database().reference().child("UserDatabase").child((Auth.auth().currentUser?.uid)!)
        
        ref.child("Notes").observeSingleEvent(of: .value, with: {
            snapshot in
            for key in snapshot.children
            {
                let taskKey = (key as! DataSnapshot).key
                
                let data = (key as! DataSnapshot).value as! [String:String]
                
                let dict = ["title":data["title"],"notes":data["notes"],"reminderDate":data["reminderDate"],"color":data["color"],"key":taskKey]
                
                self.myData.append(dict as! [String : String])
                
            }
            self.collectionview.reloadData()
        })

    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 170, height: 250)
    }

    func loadCollectionData() {
        myData.removeAll()
        self.fetchingFRData()
        collectionview.reloadData()
    }
    // this func is used for user did long press on collection cell
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
    
            switch(gesture.state) {
                        
                    case UIGestureRecognizerState.began:
                         let selectedIndexPath = self.collectionview.indexPathForItem(at: gesture.location(in: self.collectionview))
                       
                       self.isSelected = true
                         collectionview.allowsMultipleSelection = true
                         isSelected = true
                       self.selectedIndexColor = selectedIndexPath
                       self.menuBarViewSecond.isHidden = false
                      trashArray.append((selectedIndexPath?.row)!)
                      let cell = collectionview.cellForItem(at: selectedIndexPath!) as! RemindMeCell
                      cell.layer.opacity = 0.3
                       collectionview.beginInteractiveMovementForItem(at: selectedIndexPath!)
                
                    case UIGestureRecognizerState.changed:
                    collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                    collectionview.allowsMultipleSelection = false
                       menuBarViewSecond.isHidden = true
                       isSelected = false
                
            
                    case UIGestureRecognizerState.ended:
                        collectionview.endInteractiveMovement()
                
                    default:
                        collectionview.cancelInteractiveMovement()
                
                    }
}
    
    @IBAction func menuSecdeletwOptionBtnClk(_ sender: Any){
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
                
            }.show(PopUpDeleteVC.instance(result: "inbox"))
    }
    
    @IBAction func menuSecBackBtnClk(_ sender: Any) {
        
        self
        .menuBarViewSecond.isHidden = true
        self.isSelected = false
        self.collectionview.allowsMultipleSelection = false
        trashArray.removeAll()
        collectionview.reloadData()
    }
    
    // override method used for no of column needfull in collection view
    func numberOfCoulom() -> Int {
        if isGride
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell = collectionview.cellForItem(at: indexPath) as! RemindMeCell
            if trashArray.contains(indexPath.row)
            {
                let location = trashArray.index(of: indexPath.row)
                trashArray.remove(at: location!)
                cell.layer.opacity = 1
                
            }
        
    }
    // user did tap on collection cell perform this func
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionview.cellForItem(at: indexPath) as! RemindMeCell
        if isSelected
        {
           collectionView.allowsMultipleSelection = true
            cell.layer.opacity = 0.3
            trashArray.append(indexPath.row)
        }
        else
        {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "task") as! AddNotesView
            
            popOverVC.checkView = "updateNotes"
            popOverVC.tempData = myData[indexPath.row]
            let color = myData[indexPath.row]["color"]
            popOverVC.view.backgroundColor = UIColor(hex: color!)
            self.addChildViewController(popOverVC)
            popOverVC.didMove(toParentViewController: self)
            self.view.addSubview(popOverVC.view)
            popOverVC.view.frame = self.view.frame
            
        }
    }

    
      //this func exe when collection cell moving
   
// when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let color = UIColor(red: 257/255, green: 185/255, blue: 15/255, alpha: 1)
        self.collectionview.reloadData()
        navigationController?.navigationBar.barTintColor = color
        navigationController?.isNavigationBarHidden = true
        
    }
    //this func is called when user did search button clicked
    @IBAction func userDidSearchBtnClk(_ sender: Any)
    {
        
        performSegue(withIdentifier: "searchcell", sender: Any?.self)
    }
    
    @IBAction func CollectionTableBtnClk(_ sender: Any)
    {
        if isGride
        {
           
            listGrideBtn.setImage(UIImage(named:"whiteTable"),for:UIControlState.normal)
            self.collectionview.reloadData()
            isGride = false
        }
        else
        {
           
            listGrideBtn.setImage(UIImage(named:"whiteGride"),for:UIControlState.normal)
            self.collectionview.reloadData()
            isGride = true
           
        }
        
    }
    
    func sectionInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }

    func searchListData(_ sender : Any)
    {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "searchcell"
        {
            let vc = segue.destination as! SearchVC
            vc.searchData = "Search within Notes"
            vc.searchTask = myData
        }
    }
    // user did click take note button for adding notes
    @IBAction func userTakeNotes(_ sender: Any)
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "task") as! AddNotesView
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        popOverVC.view.frame = self.view.frame
        
    }
    
    // this func is used for finding the height of the Label
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


extension CollectionTableView : CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if isGride != true
        {
            let note = myData[indexPath.row]["notes"]! as String
            let tittle = myData[indexPath.row]["title"]! as String
            let remindDate = myData[indexPath.row]["reminderDate"]! as String
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            let noteHeight = self.heightForView(text: note, font: labelFont!, width:(view.bounds.width - 40))
            
            let remindDateHeight = self.heightForView(text: remindDate, font: labelFont!, width:(view.bounds.width - 40))
            let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:(view.bounds.width - 40))
            
            let totalHeight = noteHeight+tittleHeight+remindDateHeight
            
            if remindDate == "" {
                
                return CGSize(width: (view.bounds.width - 40), height: totalHeight+20)
            }
            else
            {
                return CGSize(width: (view.bounds.width - 40), height: totalHeight+30)
            }
        }
        else
        {
            
        let labelWidth = (self.collectionview.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+self.layout.minimumColumnSpacing))/2
        let note = myData[indexPath.row]["notes"]! as String
        let tittle = myData[indexPath.row]["title"]! as String
        let remindDate = myData[indexPath.row]["reminderDate"]! as String
        let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
        let noteHeight = self.heightForView(text: note, font: labelFont!, width:labelWidth)
        
        //let remindDateHeight = self.heightForView(text: remindDate, font: labelFont!, width:labelWidth)
        let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:labelWidth)
        let totalHeight = noteHeight+tittleHeight
            if remindDate == "" {
                
                return CGSize(width: labelWidth, height: totalHeight+20)
            }
            else
            {
              return CGSize(width: labelWidth, height: totalHeight+30)
            }
        }
        
    }
}


extension CollectionTableView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RemindMeCell", for: indexPath) as! RemindMeCell
        let color = myData[indexPath.row]["color"]! as String
        cell.cellview.backgroundColor = UIColor(hex: color)
        cell.tittle.text = myData[indexPath.row]["title"]! as String
        cell.notes.text = myData[indexPath.row]["notes"]! as String
        cell.remindDate.text = myData[indexPath.row]["reminderDate"]! as String
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
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?)
    {
        testView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute: {
            self.testView.isHidden = true
        })
        let note:[String:String] = [
            "title":self.myData[indexPath.row]["title"]! as String,
            "notes":self.myData[indexPath.row]["notes"]! as String,"reminderDate":self.myData[indexPath.row]["reminderDate"]! as String,"color":self.myData[indexPath.row]["color"]! as String
        ]
        
        let databaseref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        databaseref.child("UserDatabase").child(uid!).child("ArchiveData").childByAutoId().setValue(note)
        let tempData = self.myData[indexPath.row]
        let ref = Database.database().reference().child("UserDatabase").child(uid!).child("Notes").child(tempData["key"]!)
        self.myData.remove(at: indexPath.row)
        ref.removeValue()
        
        collectionview.deleteItems(at: [indexPath])
        collectionview.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = myData.remove(at: sourceIndexPath.item)
        myData.insert(temp, at: destinationIndexPath.item)
        self.collectionview.collectionViewLayout.invalidateLayout()
        self.collectionview.setCollectionViewLayout(layout, animated: false)
        self.collectionview.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}



