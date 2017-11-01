//
//  Serializer.swift
//  Receiver
//
//  Created by Mihai Petrenco on 11/1/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class Serializer {
    
    //Creates a JSON formatted dictionary
    static func createJSON(type: Type, command: Command, content: String) -> [String:String]? {
        
        let jsonObject = [
            "Type":type.rawValue ,
            "Command":command.rawValue ,
            "Content":content
            ]
        
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            return nil
        }
        return jsonObject
    }
    
    //Converts JSON dictionary to Data
    static func toData(from obj: [String:String]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            return data
        } catch {
            //Do some shit
        }
        return nil
    }
    
    //Converts Data to JSON dictionary
    static func toJSON(from data: Data) -> [String:Any]? {
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return obj as? [String:String]
        } catch {
            //Do some other shit
        }
        return nil
    }
    
}
