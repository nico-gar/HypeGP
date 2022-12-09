//
//  Hype.swift
//  HypeGP
//
//  Created by Nicolas Garaycochea on 12/7/22.
//

import Foundation
import CloudKit

struct HypeStrings {
    static let recordTypeKey = "Hype"
    //recordTypeKey is the identifier to connect it to CloudKit similar to view identifiers that connect to code
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}

class Hype {
    
    var body: String
    var timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
    }
}

extension Hype {
    /*
     Taking a CKRecord and pulling out the values found to initialize out Hype model
    */
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
              let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
        else { return nil }
        
        self.init(body: body, timestamp: timestamp)
    }
}

extension CKRecord {
    /*
    Packaging our Hype model properties to be stored in a CDRecord and saved to the cloud
    */
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey)
        //two ways to set keys for key:value pairs
        //first way (visually easy to understand [key:value]):
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey: hype.timestamp
        ])
        
        //second way (it reads like its assigning a key to the value):
//        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
        //                  value                    assigned key
    }
}
