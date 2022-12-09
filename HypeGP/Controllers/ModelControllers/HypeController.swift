//
//  HypeController.swift
//  HypeGP
//
//  Created by Nicolas Garaycochea on 12/7/22.
//

import Foundation
import CloudKit

class HypeController {
    
    static let shared = HypeController()
    // Source of Truth Array named "hypes" all hypes and timestamps will go in this array to be displayed on the view
    var hypes: [Hype] = []
    // Constant to access our publicCloudDatabase
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK - CRUD
    // Create
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        // Init a Hype object
        let newHype = Hype(body: text)
        // Package the newHype into a CKRecord
        let hypeRecord = CKRecord(hype: newHype)
        // Saving the hypeRecord to the cloud
        publicDB.save(hypeRecord) { (record, error) in
            // Handling the error if there is one
            if let error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            // Unwrapping the record that was saved
            guard let record = record,
                  // Ensuring that we can init a Hype from that record
                  let savedHype = Hype(ckRecord: record)
            else { completion(false) ; return }
            // Add it to our SoT array
            print("Saved Hype successfully")
            self.hypes.insert(savedHype, at: 0)
            completion(true)
        }
    }
    // Fetch
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        // Step 3 - Init the requisite predicate for the query
        let predicate = NSPredicate(value: true)
        // Step 2 - Init the requisite query for the .perform method
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        // Step 1 - Perform query on the database
        publicDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let (matchResults, _)):
                let fetchedHypes: [Hype] = matchResults.compactMap { recordID, result in
                    switch result {
                    case .success(let record):
                        return Hype(ckRecord: record)
                    case .failure(let error):
                        print(error)
                        return nil
                    }
                }
                self.hypes = fetchedHypes
                completion(true)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
        }
        /*
        depreciated code:
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            // Handle the optional error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            // Unwrap the found records
            guard let records = records else { completion(false) ; return }
            print("Fetched all hypes")
            // Compact map through the found records to return the non-nil Hype objects
            let fetchedHypes = records.compactMap { Hype(ckRecord: $0) }
            // Set our source of truth
            self.hypes = fetchedHypes
            completion(true)
        }
         */
    }
}
