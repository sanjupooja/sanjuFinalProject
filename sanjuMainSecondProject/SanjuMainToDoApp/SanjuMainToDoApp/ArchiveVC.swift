//MARK : THIS ARCHIVE CLASS FETCH DATA FROM FIREBASE AND HANDLE ARCHIVED DATA FROM FIR

import UIKit
import  Firebase
import FirebaseDatabase
import FirebaseAuth
var myArchiveData = [[String:String]]()
class ArchiveVC: UIViewController
{
    //MARK : OUTLET
    @IBOutlet weak var archiveBarView: UIView!
    @IBOutlet weak var listGrideButton: UIButton!
    @IBOutlet weak var slideMenuButton: UIButton!
    @IBOutlet weak var archiveSecBarView: UIView!
    @IBOutlet weak var collectionview : UICollectionView!
    
    var archivePresenterObjRef = ArchivePresenter()
    var isGride : Bool = true
    var isSelected :Bool = false
    var checkView : String?
    var archiveArray = [Int]()
    
    var layout : CHTCollectionViewWaterfallLayout!
    var longPressGesture = UILongPressGestureRecognizer()
    
    //ITS EXECUTES ONLY ONCE WHEN VIEW IS LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        archivePresenterObjRef.askPresenterToInteractDBManager(completionHandler: { (results) in
            if results
            {
                self.collectionview.reloadData()
            }
        })
        collectionview.allowsMultipleSelection = false
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ArchiveVC.handleGesture(_:)))
        self.collectionview.addGestureRecognizer(longPressGesture)

        let nib = UINib(nibName: "ArchiveReminderCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "ArchiveReminderCell")
        layout = self.collectionview.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        if self.revealViewController() != nil {
            slideMenuButton.addTarget(self.revealViewController(),
                                   action:#selector(SWRevealViewController.revealToggle(_:)),for:.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteArchiveCell), name: NSNotification.Name("deleteArchiveData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unArchiveCell), name: NSNotification.Name("UnArchiveCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionData), name: NSNotification.Name("loadCollectionView"), object: nil)
    }

    //MARK : ITS EXECUTE EVERY TIME WHEN VIEW WILL APPEARS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        archiveSecBarView.isHidden = true
       // let color = UIColor(red: 257/255, green: 185/255, blue: 15/255, alpha: 1)
      //  navigationController?.navigationBar.barTintColor = color
        navigationController?.isNavigationBarHidden = true
       // archiveBarView.backgroundColor = color
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        myArchiveData.removeAll()
    }
   
    //MARK : THIS FUNC OPENS A OPTION MENU
    @IBAction func userDidMoreBtnClk(_ sender: Any) {
        
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
                
            }.show(PopUpDeleteVC.instance(result: "archive"))
    }
//MARK : THIS FUNC USED FOR REMOVE SUBVIEW FROM PARENT VIEW
    @IBAction func userDidBackBtnClk(_ sender: Any) {
        
        self
            .archiveSecBarView.isHidden = true
        self.isSelected = false
        self.collectionview.allowsMultipleSelection = false
        archiveArray.removeAll()
        self.collectionview.reloadData()
    }
    //MARK : THIS FUNC USED FOR OPEN A SEARCH OPTION MENU

    @IBAction func userDidSearchBtnClk(_ sender: Any) {
        performSegue(withIdentifier: "searchArchive", sender: nil)
    }
    //MARK : THIS FUNC CHANGES THE GRIDE VIEW AND LIST VIEW
    @IBAction func userDidListGrideBtnClk(_ sender: Any) {
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
    
    //MARK : THIS IS HANDLES THE WHEN USER LONG PRESS ON THE COLLECTION CELL
    func handleGesture(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionview.indexPathForItem(at: gesture.location(in: self.collectionview)) else {
                break
            }
            
            isSelected = true
            let cell = collectionview.cellForItem(at: selectedIndexPath)
            cell?.layer.opacity = 0.3
            archiveSecBarView.isHidden = false
            archiveArray.append(selectedIndexPath.row)
            collectionview.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            archiveSecBarView.isHidden = true
            collectionview.allowsMultipleSelection = false
            isSelected = false
        case UIGestureRecognizerState.ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }
    
    //MARK : THIS IS EXECUTE AND LOAD COLLECTION DATA WHEN NOTIFIED
    func loadCollectionData() {
        myArchiveData.removeAll()
        archivePresenterObjRef.askPresenterToInteractDBManager(completionHandler: { (results) in
            if results
            {
                self.collectionview.reloadData()
            }
        })
    }

    func deleteArchiveCell() {
        
        self.archiveSecBarView.isHidden = true
        if archiveArray.count > 0
        {
        archiveArray = archiveArray.sorted(by: >)
        for item in archiveArray
        {
            if archivePresenterObjRef.postArchiveDataIntoTrashFIR(id: item) == true
            {
                if archivePresenterObjRef.removeUnArchiveDataFromNotesFIR(id: item) == true
                {
                    myArchiveData.remove(at: item)
                    let indexPath = IndexPath(row: item, section: 0)
                    collectionview.deleteItems(at: [indexPath])
                }
            }
        }
        
        archiveArray.removeAll()
        collectionview.reloadData()
        }
        
    }
    
    func unArchiveCell() {
        
        self.archiveSecBarView.isHidden = true
        if archiveArray.count > 0
        {
         archiveArray = archiveArray.sorted(by: >)
        for item in archiveArray
        {
            if archivePresenterObjRef.postUnArchiveDataIntoNotesFIR(id: item) == true
            {
                if archivePresenterObjRef.removeUnArchiveDataFromNotesFIR(id: item) == true
                {
                    myArchiveData.remove(at: item)
                    let indexPath = IndexPath(row: item, section: 0)
                    collectionview.deleteItems(at: [indexPath])
                }
            }
        }
        archiveArray.removeAll()
        collectionview.reloadData()
        }
    }
    //MARK : THIS FUNC USED FOR WHEN MOVE THE COLLECTION CELL AND CHANGES THE INDEX
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = myArchiveData.remove(at: sourceIndexPath.item)
        myArchiveData.insert(temp, at: destinationIndexPath.item)
        self.collectionview.collectionViewLayout.invalidateLayout()
        self.collectionview.setCollectionViewLayout(layout, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    //MARK : THIS FUNC USED TO SET THE COLLECTION VIEW INSECT
    func sectionInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchArchive" {
            let vc = segue.destination as! SearchVC
            vc.searchData = "Search within Archive"
            vc.searchTask = myArchiveData
        }
    }
    
    //MARK : THIS FUNC IS USED TO CALCULATES THE HEIGHT FOR LABEL
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }

}
//MARK : THIS  LIBRARY CLASS USED FOR COLLECTION VIEW LAYOUT
 extension ArchiveVC : CHTCollectionViewDelegateWaterfallLayout {
   func numberOfCoulom() -> Int {
    if isGride {
        return 2
    }
    else {
        return 1
    }
   }
    //MARK : OVERRIDEN COLLECTION FUNC EXECUTES AND SET THE LAYOUT FOR COLLECTION VIEW
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if isGride != true {
            let note = myArchiveData[indexPath.row]["notes"]! as String
            let tittle = myArchiveData[indexPath.row]["title"]! as String
            let remindDate = myArchiveData[indexPath.row]["reminderDate"]! as String
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
        else {
        let labelWidth = (self.collectionview.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+self.layout.minimumColumnSpacing))/2
        let note = myArchiveData[indexPath.row]["notes"]! as String
        let tittle = myArchiveData[indexPath.row]["title"]! as String
        let remindDate = myArchiveData[indexPath.row]["reminderDate"]! as String
        let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
        let noteHeight = self.heightForView(text: note, font: labelFont!, width:labelWidth)
        
        let remindDateHeight = self.heightForView(text: remindDate, font: labelFont!, width:labelWidth)
        let tittleHeight = self.heightForView(text: tittle, font: labelFont!, width:labelWidth)
            
        let totalHeight = noteHeight+tittleHeight+remindDateHeight
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
//MARK : COLLECTION VIEW DATASOURCE DELEGATE
 extension ArchiveVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArchiveData.count
    }
    //MARK : OVERRIDEN COLLECTION FUNC EXECUTE REUSE COLLECTION CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "ArchiveReminderCell", for: indexPath) as! ArchiveReminderCell
        cell.tittle.text = myArchiveData[indexPath.row]["title"]! as String
        cell.notes.text = myArchiveData[indexPath.row]["notes"]! as String
        cell.remindDate.text = myArchiveData[indexPath.row]["reminderDate"]! as String
        cell.cellview.backgroundColor = UIColor(hex: myArchiveData[indexPath.row]["color"]! as String)
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
    //MARK : OVERRIDEN COLLECTION FUNC EXECUTE AND DESELECT THE CELL FROM SELECTED CELL WHEN USER CLICK ON COLLECTION CELL
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ArchiveReminderCell
        
        if archiveArray.contains(indexPath.row)
        {
            
            let location = archiveArray.index(of: indexPath.row)
            archiveArray.remove(at: location!)
            cell.layer.opacity = 1
            
        }
    }
    //MARK : OVERRIDEN COLLECTION FUNC EXECUTE WHEN USER CLICK ON COLLECTION CELL AND OPENS ADD NOTES VIEW
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelected
        {
            let cell = collectionView.cellForItem(at: indexPath) as! ArchiveReminderCell
            cell.layer.opacity = 0.3
            collectionView.allowsMultipleSelection = true
            archiveArray.append(indexPath.row)
        }
        else
        {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "task") as! AddNotesView
            popOverVC.checkView = "updateArchive"
            popOverVC.tempData = myArchiveData[indexPath.row]
            let color = myArchiveData[indexPath.row]["color"]
            popOverVC.view.backgroundColor = UIColor(hex: color!)
            self.addChildViewController(popOverVC)
            popOverVC.didMove(toParentViewController: self)
            self.view.addSubview(popOverVC.view)
            popOverVC.view.frame = self.view.frame
        
        }
    }
}


