

//MARK : THIS IS PRESENTER CLASS ITS CONTAINS BUSINESS LOGIC AND CONTROL FLOW



class AddNotePresenterController: NSObject {
    
    //MARK : DECLARED TEMPORARY INSTANCE VARIBLE
    var checkResults : String? = nil
    var tempPostData : [String : String]? = nil
    var addNoteModelObjRef : AddNotesModel!
    
    //MARK : THIS FUNC USED TO PASS USER DATA INTO DBMANAGER
    func sendNotesDataModel(completionHandler:@escaping (_ postNotesResult:Bool) -> Void) {
        
        if checkResults == nil
        {
            addNoteModelObjRef = AddNotesModel()
            addNoteModelObjRef.title = tempPostData?["title"]
            addNoteModelObjRef.notes = tempPostData?["notes"]
            addNoteModelObjRef.reminderDate = tempPostData?["reminderDate"]
            addNoteModelObjRef.postNotesDataIntoFirebase { (storedResult) in
                if storedResult
                {
                    completionHandler(true)
                }
                else
                {
                    completionHandler(false)
                }
            }
        }
        else
        {
            if checkResults == "updateNotes"
            {
                addNoteModelObjRef = AddNotesModel()
                addNoteModelObjRef.title = tempPostData?["title"]
                addNoteModelObjRef.notes = tempPostData?["notes"]
                addNoteModelObjRef.reminderDate = tempPostData?["reminderDate"]
                addNoteModelObjRef.color = tempPostData?["color"]
                addNoteModelObjRef.id = tempPostData?["key"]
                addNoteModelObjRef.userUpdateNotes = tempPostData?["userNotes"]
                addNoteModelObjRef.updateSelectedNotesFIR(completionHandler: { (results) in
                    
                    if results
                    {
                        completionHandler(true)
                    }
                    else
                    {
                        completionHandler(false)
                    }
                })
            }
            else
            {
                if checkResults == "updateArchive"
                {
                    addNoteModelObjRef = AddNotesModel()
                    addNoteModelObjRef.notes = tempPostData?["notes"]
                    addNoteModelObjRef.title = tempPostData?["title"]
                    addNoteModelObjRef.reminderDate = tempPostData?["reminderDate"]
                    addNoteModelObjRef.id = tempPostData?["key"]
                    addNoteModelObjRef.color = tempPostData?["color"]
                    addNoteModelObjRef.updateSelectedArchivedFIR(completionHandler: { (results) in
                        
                        if results
                        {
                            completionHandler(true)
                        }
                        else
                        {
                            completionHandler(false)
                        }
                    })
                }
            
            }
            
            
        }
        
    }
}
