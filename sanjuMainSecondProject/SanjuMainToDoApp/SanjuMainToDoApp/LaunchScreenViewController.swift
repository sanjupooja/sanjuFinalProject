

import UIKit

class LaunchScreenViewController: UIViewController
{

    var myFirstlabel : UILabel!
    var mySecondLabel : UILabel!
    var tapgasture : UITapGestureRecognizer!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.alpha = 0.9
        myFirstlabel = UILabel()
        mySecondLabel = UILabel()
        
        addLabel()
        
        
        tapgasture = UITapGestureRecognizer(target: self, action: #selector(LaunchScreenViewController.handleTapGasture(_:)))
        view.addGestureRecognizer(tapgasture)
        self.navigationController?.navigationBar.isHidden = true
    }

    
    func addLabel() {
        
        myFirstlabel.text = "My First "
        myFirstlabel.font = UIFont.systemFont(ofSize: 36)
        myFirstlabel.sizeToFit()
        myFirstlabel.center = CGPoint(x: 100, y: 40)
        view.addSubview(myFirstlabel)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            
            
            self.myFirstlabel.center = CGPoint(x: 100, y: 40+200)
        }, completion: nil)
        
        
        mySecondLabel.text = "iPhone App"
        mySecondLabel.font = UIFont.boldSystemFont(ofSize: 48)
        mySecondLabel.sizeToFit()
        mySecondLabel.center = CGPoint(x: 200, y: 90)
        view.addSubview(mySecondLabel)
        mySecondLabel.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options:.curveEaseIn, animations: {
            
            
            self.mySecondLabel.center = CGPoint(x: 200, y: 90+200)
            self.mySecondLabel.alpha = 1
        }, completion: nil)
    }
    
    func handleTapGasture(_ gesture: UITapGestureRecognizer)  {
        addLabel()
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+2), execute: {
            self.performSegue(withIdentifier: "login", sender: nil)
        })
    }
}
