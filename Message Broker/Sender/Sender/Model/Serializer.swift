//
//  Serializer.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

class Serializer {
    
    static func toJSON(from data: Data) -> [String:Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let dictionary = json as? [String:Any] else {
                return nil
            }
            return dictionary
        } catch {
            print("Error at " + #function)
        }
        return nil
    }
    
    static func toData(from json: [String:Any]) -> Data? {
        if !JSONSerialization.isValidJSONObject(json) {
            print("Error at" + #function)
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return data
        } catch {
            print("Error at" + #function)
            return nil
        }
    }
    
    static func generate(command: String, to queues:[String], with content: String) -> [String:Any] {
        let dict: [String:Any] = [
            "Command":command,
            "Queues": queues,
            "Content":content
        ]
        return dict
    }
    
}
