
import UIKit
class SearchVC: UIViewController,UISearchBarDelegate{

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    var searchData = String()
    var searchState : Bool = false
    var searchTask = [[String:String]]()
    var tempArray = [[String:String]]()
    var layout : CHTCollectionViewWaterfallLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 50, y: 25, width: 300, height: 30)
        searchBar.placeholder = searchData
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        self.view.addSubview(searchBar)
        let nib = UINib(nibName: "ArchiveReminderCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "ArchiveReminderCell")
        layout = self.collectionview.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        collectionview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func userDidPreviousBtnClk(_ sender: Any) {
        searchTask.removeAll()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTask.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        let color = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.isNavigationBarHidden = true
        self.collectionview.reloadData()
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
    
    func numberOfCoulom() -> Int {
        
        return 2
    }
    
    func sectionInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchState = false
        searchBar.text = ""
        collectionview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchState = true
        
        tempArray.removeAll()
        let searchPredicate = NSPredicate(format: "title contains[c] %@ OR notes contains[c] %@", searchBar.text!)
        let array = (searchTask as NSArray).filtered(using: searchPredicate)
        tempArray = array as! [[String:String]]
        collectionview.reloadData()
        
        if ((searchText.characters.count) < 1)
        {
            searchBar.resignFirstResponder()
        }
        if searchText == "" {
            
            searchState = false
            collectionview.reloadData()
        }
    }
    
}

extension SearchVC: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
            let labelWidth = (self.collectionview.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+self.layout.minimumColumnSpacing))/2
            let note = searchTask[indexPath.row]["notes"]! as String
            let tittle = searchTask[indexPath.row]["title"]! as String
            let remindDate = searchTask[indexPath.row]["reminderDate"]! as String
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

extension SearchVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchState {
            return tempArray.count
        }
        else
        {
            return searchTask.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "ArchiveReminderCell", for: indexPath) as! ArchiveReminderCell
        
        if searchState
        {
            cell.tittle.text = tempArray[indexPath.row]["title"]! as String
            cell.notes.text = tempArray[indexPath.row]["notes"]! as String
            
            cell.remindDate.text = tempArray[indexPath.row]["reminderDate"]! as String
            let color = tempArray[indexPath.row]["color"]! as String
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
        else
        {
        cell.tittle.text = searchTask[indexPath.row]["title"]! as String
        cell.notes.text = searchTask[indexPath.row]["notes"]! as String
        
        cell.remindDate.text = searchTask[indexPath.row]["reminderDate"]! as String
        let color = searchTask[indexPath.row]["color"]! as String
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
    }
}



