//
//  Serializer.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class Serializer {
    
    static func jsonData(with command: String, message: String) -> Data? {
        let collection = [
            ["Command":command],
            ["Message":message]
        ]
        do {
            if JSONSerialization.isValidJSONObject(collection) {
                let data = try JSONSerialization.data(withJSONObject: collection, options: .prettyPrinted)
                
                return data
            } else {
                print("Not a valid JSON object")
            }
        } catch {
            print("Could not serialize object")
        }
        return nil
    }
    
    static func deserialize(from data: Data) -> [[String:AnyObject]]? {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return object as? [[String:AnyObject]]
        } catch {
            print("Could not deserialize object.")
        }
        return nil
    }
    
    static func toData(from bytes: [UInt8]) -> Data? {
        let data = Data(bytes: bytes)
        return data
    }
    
    
    
    
}
