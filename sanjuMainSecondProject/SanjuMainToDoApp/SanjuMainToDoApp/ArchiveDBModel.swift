


import UIKit
import Firebase

class ArchiveDBModel: NSObject {
    var id : Int? = nil
    
    func fetchFIRData(completionHandler:@escaping (_ postNotesResult:Bool) -> Void)
    {
        let ref = Database.database().reference().child("UserDatabase").child((Auth.auth().currentUser?.uid)!)
        
        ref.child("ArchiveData").observeSingleEvent(of: .value, with: {
            snapshot in
            for key in snapshot.children {
                let taskKey = (key as! DataSnapshot).key
                
                let data = (key as! DataSnapshot).value as! [String:String]
                
                let dict = ["title":data["title"],"notes":data["notes"],"reminderDate":data["reminderDate"],"color":data["color"],"key":taskKey]
                myArchiveData.append(dict as! [String:String])
                completionHandler(true)
            }
        })
       
    }

    func pushUnArchivedDataIntoNotesFIR(completionHandler:@escaping ( _ postNotesResult:Bool) -> Void)
    {
        let title = myArchiveData[id!]["title"]! as String
        let desc = myArchiveData[id!]["notes"]! as String
        let reminderDate = myArchiveData[id!]["reminderDate"]! as String
        let color = myArchiveData[id!]["color"]! as String
        let note:[String:String] = [
            "title":title,
            "notes":desc,
            "reminderDate": reminderDate,
            "color": color
        ]
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("UserDatabase").child(uid!).child("Notes").childByAutoId().setValue(note)
        completionHandler(true)
    }
    
   func deleteUnArchivedDataFromFIR(completionHandler:@escaping ( _ postNotesResult:Bool) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        let tempData = myArchiveData[id!]
        
        let ref = Database.database().reference().child("UserDatabase").child(uid!).child("ArchiveData").child(tempData["key"]!)
        ref.removeValue()
        completionHandler(true)
    }

    func pushArchivedDataIntoTrashFIR(completionHandler:@escaping ( _ postNotesResult:Bool) -> Void)
    {
        let title = myArchiveData[id!]["title"]! as String
        let desc = myArchiveData[id!]["notes"]! as String
        let reminderDate = myArchiveData[id!]["reminderDate"]! as String
        let color = myArchiveData[id!]["color"]! as String
        let note:[String:String] = [
            "title":title,
            "notes":desc,
            "reminderDate": reminderDate,
            "color": color
        ]
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("UserDatabase").child(uid!).child("TrashData").childByAutoId().setValue(note)
        completionHandler(true)

    }
    
    
    
}
