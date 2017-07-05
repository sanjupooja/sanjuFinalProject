//
//  FSCalendarView.swift
//  SanjuMainToDoApp
//
//  Created by BridgeLabz on 12/06/17.
//  Copyright © 2017 BridgeLabz Solutions LLP. All rights reserved.
//

import UIKit
import FSCalendar
class FSCalendarVC: UIViewController,PopupContentViewController,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAnimate()
        doneBtn.layer.cornerRadius = 20
        doneBtn.layer.borderWidth = 2
        doneBtn.layer.borderColor = UIColor.black.cgColor
        doneBtn.layer.masksToBounds = true
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 2.0
        self.view.layer.shadowRadius = 2
        self.view.layer.masksToBounds = false
        self.view.clipsToBounds = true
    
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 325, height: 450)
    }
    class func instance() -> FSCalendarVC{
        let storyboard = UIStoryboard(name: "FSCalendarVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! FSCalendarVC
    }
    @IBAction func userDoneBtnClk(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
        self.removeAnimate()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formater = DateFormatter()
        formater.dateFormat = "MMMM dd"
        dateLabel = formater.string(from: date)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
        
    }

    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            self.view.alpha = 0.0
        },completion :{(finished : Bool) in
            if(finished) {
                self.view.removeFromSuperview()
            }
        })
    }

}
