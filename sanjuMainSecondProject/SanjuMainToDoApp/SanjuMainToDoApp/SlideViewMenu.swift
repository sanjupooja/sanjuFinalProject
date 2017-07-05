
import UIKit
import SVProgressHUD
import Firebase
import SDWebImage

class SlideViewMenu: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCropViewControllerDelegate{
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
        
    var arra : [String] = ["Notes","Reminders","Create new Label","Archive","Trash","Settings","Sign Out"]
    var marr : [String] = ["note.png","Reminder","task.png","archive.png","delete.png","setting.png","logout.jpeg"]
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        
        photoImage.layer.cornerRadius = photoImage.frame.width/2
        //logoView.layer.cornerRadius = logoView.frame.width/2
        photoImage.layer.masksToBounds = true
        photoImage.layer.borderWidth = 1
        
        tableview.reloadData()
        let label1 = UILabel()
        label1.frame = CGRect(x: 10, y: 165, width: 200, height: 30)
        label1.backgroundColor = UIColor.clear
        label1.textColor = UIColor.white
        label1.text = UserDefaults.standard.value(forKey: "userEmail") as! String?
        label1.textAlignment = NSTextAlignment.left
        label1.font=UIFont.systemFont(ofSize: 16)
        label1.numberOfLines = 1
        self.view.addSubview(label1)

    
    }
   
    @IBAction func chooseProfilePictureBtnClk(_ sender: UITapGestureRecognizer) {
        self.choosePhoto()
    }
    
    
    func uploadImageIntoFIR(image : UIImage)  {
        
    
        
        
    }
    
    func choosePhoto()
    {
        self.imagePicker.delegate = self
        //  self.imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title:"Add a Picture", message:"Choose From",preferredStyle: .alert)
        
        
        let cameraAction = UIAlertAction(title:"camera",style: .default){(action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title:"Photo Library",style: .default){(action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let savedPhotoAction = UIAlertAction(title:"Saved Photo Album",style: .default){(action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style: .destructive, handler: nil)
        
        alertController.view.layer.borderWidth = 4
        alertController.view.layer.backgroundColor = UIColor.orange.cgColor
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.borderColor = UIColor.white.cgColor
        alertController.view.layer.shadowColor = UIColor.black.cgColor
        alertController.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        alertController.view.layer.shadowOpacity = 2.0
        alertController.view.layer.shadowRadius = 2
        alertController.view.layer.masksToBounds = false
        alertController.view.clipsToBounds = true
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImage.image = selectedImage
        
        // Dismiss the picker.
        
        dismiss(animated: true) { [unowned self] in
            self.openEditor()
        }
        
    }
    
    func openEditor()
    {
        guard let selectedImage = photoImage.image else {
            return
        }
        
        let controller = ImageCropViewController()
        controller.delegate = self
        controller.image = selectedImage
        controller.blurredBackground = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancel(_ controller: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerSuccess(_ controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        photoImage.image = croppedImage
        self.dismiss(animated: true, completion: nil)
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell") as? SlideViewMenuCell
        cell?.label.text = arra[indexPath.row]
        cell?.labelImage.image = UIImage(named: marr[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arra.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealViewController : SWRevealViewController = self.revealViewController()
        let cell : SlideViewMenuCell = (tableview.cellForRow(at: indexPath) as? SlideViewMenuCell)!
        if cell.label.text == "Notes" {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "notes") as? CollectionTableView
            let newFrontController = UINavigationController.init(rootViewController:desController!)
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.label.text == "Archive" {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "ArchiveVC") as? ArchiveVC
            let newFrontController = UINavigationController.init(rootViewController:desController!)
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.label.text == "Reminders" {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "remindersVC") as? RemindersVC
            let newFrontController = UINavigationController.init(rootViewController:desController!)
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.label.text == "Trash" {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "trashview") as? TrashView
            let newFrontController = UINavigationController.init(rootViewController:desController!)
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }

        if cell.label.text == "Sign Out" {
                SVProgressHUD.setBackgroundColor(UIColor.lightGray)
                SVProgressHUD.setForegroundColor(UIColor.black)
                SVProgressHUD.setDefaultStyle(.custom)
                
                SVProgressHUD.show(withStatus: "please wait")
            
                DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute: {
                        SVProgressHUD.dismiss()
                        let label = UILabel()
                        label.frame = CGRect(x: 80, y: 600, width: 200, height: 40)
                        label.backgroundColor = UIColor.lightGray
                        label.textColor = UIColor.black
                        label.textAlignment = NSTextAlignment.center
                        label.font=UIFont.systemFont(ofSize: 14)
                        label.numberOfLines = 2
                        self.view.addSubview(label)
                        label.layer.cornerRadius = 20
                        label.layer.masksToBounds = true
                        label.isHidden = false
                        label.text = "Logout Successful!!"
                        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+3), execute:
                            {
                                GIDSignIn.sharedInstance().signOut()
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginview")
                                _ = self.navigationController?.popToViewController(vc!, animated: true)
                                label.text = ""
                                label.isHidden = true
                                
                                self.present(vc!, animated: true, completion: nil)
                            })
                     })
        }
    }
}
