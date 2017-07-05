
import UIKit

class ColorPickerView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,PopupContentViewController{

    @IBOutlet weak var collectionview: UICollectionView!
    let colorArray = ["0xffffff","0xf55131","0x59cc50","0x49c7f3","0xefe357","0xf085e1","0x85b2f0","0xf5a02d","0xb8b6b3","008080","F5DEB3","0000FF"]
    var inboxCollectionObjRef = CollectionTableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.dataSource = self
        collectionview.delegate = self
        self.showAnimate()
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
}
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 300, height: 280)
    }
    class func instance() -> ColorPickerView{
        let storyboard = UIStoryboard(name: "ColorPickerView", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ColorPickerView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "colorcell", for: indexPath) as! ColorPickerViewCell
        
        let color = colorArray[indexPath.row]
        cell.contentView.backgroundColor = UIColor(hex : color)
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.width/2
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        cell.contentView.layer.shadowOpacity = 1.0
        cell.contentView.layer.shadowRadius = 2
        cell.contentView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.masksToBounds = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionview.cellForItem(at: indexPath) as! ColorPickerViewCell
        cell.imageRight.image = UIImage(named: "rightImage")
        NotificationCenter.default.post(name: NSNotification.Name("selectedCell"), object: nil,userInfo:["color":colorArray[indexPath.row]])
       
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.5), execute: {
           self.removeAnimate()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 0.7,y: 0.7)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
        
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.5, animations:
            {
                self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
                self.view.alpha = 0.0
        },
                       completion :
            {
                (finished : Bool) in
                if(finished)
                {
                    self.view.removeFromSuperview()
                }
                
        })
        
    }

}
