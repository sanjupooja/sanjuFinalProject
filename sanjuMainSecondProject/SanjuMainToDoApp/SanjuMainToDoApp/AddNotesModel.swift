
//MARK : 1--> THIS IS POJO CLASS FOR DBMANAGER INTERACT WITH THE FIREBASE 
        // 2 --> THIS CLASS FUNC IS USED FOR STORED AND UPDATE USER TASK INTO FIREBASE
       // 3-- > USING THE CALLBACK FUNC TO RETURNBACK CALL TO VIEW CONTROLLER

import UIKit
import Firebase
class AddNotesModel: NSObject {

    //THIS PROPERTY USED FOR CLASS INSTANCE
    var notes : String? = nil
    var title : String? = nil
    var reminderDate : String? = nil
    var id : String? = nil
    var color : String? = nil
    var userUpdateNotes : String? = nil
    var tempReminder = [[String:String]]()

    //INITIALIZATION
    override init() {
        
    }
    
    //MARK: THIS FUNC USED FOR PUSH AND STORED USER TASK INTO FIREBASE
    func postNotesDataIntoFirebase(completionHandler:@escaping (_ postNotesResult:Bool) -> Void)
    {
        if reminderDate == ""
        {
            let color = "0xFFFFFF"
            let title = self.title
            let desc = notes
            let createdDate = reminderDate
            let note:[String:String] = [
                "title":title!,
                "notes":desc!,
                "reminderDate": createdDate!,
                "color" : color
            ]
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("UserDatabase").child(uid!).child("Notes").childByAutoId().setValue(note)
             completionHandler(true)
        }
        else
        {
            let color = "0xFFFFFF"
            let title = self.title
            let desc = notes
            let createdDate = reminderDate
            let note:[String:String] = [
                "title":title!,
                "notes":desc!,
                "reminderDate": createdDate!,
                "color": color
            ]
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("UserDatabase").child(uid!).child("Notes").childByAutoId().setValue(note)
            ref.child("UserDatabase").child(uid!).child("ReminderNotes").childByAutoId().setValue(note)
            completionHandler(false)
        }
    }
    //MARK : THIS FUNC USED FOR UPDATE THE USER NOTES DATA INTO FIREBASE
    func updateSelectedNotesFIR(completionHandler:@escaping (_ postNotesResult:Bool) -> Void)
    {
        
        if reminderDate == ""
        {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("UserDatabase").child(uid!).child("Notes").child(id!).updateChildValues(["title": title!,"notes":notes!,"reminderDate":reminderDate!,"color":self.color!])
        completionHandler(true)
            
        }
        else
        {
            let ref = Database.database().reference().child("UserDatabase").child((Auth.auth().currentUser?.uid)!)
            
            ref.child("ReminderNotes").observeSingleEvent(of: .value, with: {
                snapshot in
                for key in snapshot.children
                {
                    let taskKey = (key as! DataSnapshot).key
                    
                    let data = (key as! DataSnapshot).value as! [String:String]
                    
                    let dictionary = ["notes":data["notes"],"key":taskKey]
                    
                    let userData = (dictionary as! [String : String])
                    
                    if self.userUpdateNotes == userData["notes"]! as String
                    {
                        let uid = Auth.auth().currentUser?.uid
                        let ref = Database.database().reference()
                        ref.child("UserDatabase").child(uid!).child("ReminderNotes").child(userData["key"]!).updateChildValues(["title": self.title!,"notes":self.notes!,"reminderDate":self.reminderDate!,"color":self.color!])
                        ref.child("UserDatabase").child(uid!).child("Notes").child(self.id!).updateChildValues(["title": self.title!,"notes":self.notes!,"reminderDate":self.reminderDate!,"color":self.color!])
                        completionHandler(true)
                    }
                }
                
            })
        }
    }
    
    //MARK : THIS FUNC USED FOR UPDATE THE USER ARCHIVE DATA INTO FIREBASE
    func updateSelectedArchivedFIR(completionHandler:@escaping (_ postNotesResult:Bool) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("UserDatabase").child(uid!).child("ArchiveData").child(id!).updateChildValues(["title": title!,"notes":notes!,"reminderDate":reminderDate!,"color":self.color!])
          completionHandler(true)
    }
    
}
