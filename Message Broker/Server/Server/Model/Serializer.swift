//
//  Serializer.swift
//  Server
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import SwiftSocket

class Serializer {
    
    //Converts Data object to a valid JSON dictionary
    static func toJSON(from data: Data) -> [String:Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dictionary = json as? [String:Any] else {
                return nil
            }
            return dictionary
        } catch {
            print("Error at " + #function)
        }
        return nil
    }
    
    //Converts a valid JSON dictionary into a Data object
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
    
    //Generates a valid JSON dictionary from a set of parameters
    static func generate(with command: String, and contents: String) -> [String:Any] {
        let dict: [String:Any] = [
            "Command":command,
            "Contents":contents
        ]
        return dict
    }
    
    
    //Converts the Message Queue into a valid JSON Data object
    static func convert(queue: [(name: String, subscribers: [TCPClient], contents: [String])]) -> Data? {
        var array = [[[String:Any]]]()
        for element in queue {
            let name = ["Name":element.name]
            let contents = ["Contents":element.contents]
            let collection: [[String:Any]] = [name,contents]
            array.append(collection)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            return data
        } catch {
            print("Could not generate Data.")
            return nil
        }
    }
    
    
    
    
    
    
}
