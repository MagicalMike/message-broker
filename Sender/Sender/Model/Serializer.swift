//
//  Serializer.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

class Serializer {
    
    static func jsonData(with command: String, message: String) -> Data? {
        var collection = [
            ["Command":command],
            ["Message":message]
        ]
        do {
            if JSONSerialization.isValidJSONObject(collection) {
                var data = try JSONSerialization.data(withJSONObject: collection, options: .prettyPrinted)
                
                return data
            } else {
                print("Not a valid JSON object")
            }
        } catch {
           print("Could not serialize object")
        }
        return nil
    }
    
}
