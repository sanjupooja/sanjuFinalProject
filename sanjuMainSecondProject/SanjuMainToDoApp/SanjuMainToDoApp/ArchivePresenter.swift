

import UIKit

class ArchivePresenter: NSObject {
    var modelResults : Bool? = false
    var archiveDataObjRef : ArchiveDBModel!
    func askPresenterToInteractDBManager(completionHandler:@escaping (_ postNotesResult:Bool) -> Void)
    {
        archiveDataObjRef = ArchiveDBModel()
        archiveDataObjRef.fetchFIRData { (results) in
            if results
            {
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
            }
        }
    }

    func postUnArchiveDataIntoNotesFIR(id : Int)->Bool
    {
        archiveDataObjRef.id = id
        archiveDataObjRef.pushUnArchivedDataIntoNotesFIR { (results) in
            if results
            {
                self.modelResults = true
            }
            else
            {
                self.modelResults = false
            }
        
        }
        return modelResults!
    }
    
    
    func removeUnArchiveDataFromNotesFIR(id : Int)->Bool
    {
        archiveDataObjRef.id = id
        archiveDataObjRef.deleteUnArchivedDataFromFIR { (results) in
            if results
            {
                self.modelResults = true
            }
            else
            {
                self.modelResults = false
            }
        }
        return modelResults!
    }

    func postArchiveDataIntoTrashFIR(id : Int) -> Bool {
        archiveDataObjRef.id = id
        archiveDataObjRef.pushArchivedDataIntoTrashFIR { (results) in
            if results
            {
                self.modelResults = true
            }
            else
            {
                self.modelResults = false
            }
        }
        return modelResults!
        
    }
    
}
