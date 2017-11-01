//
//  Protocols.swift
//  Receiver
//
//  Created by Mihai Petrenco on 11/1/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

enum Type: String {
    case all = "All"
    case specific = "Specific"
}

enum Command: String {
    case none = "NONE"
    case put = "PUT"
    case get = "GET"
    case count = "COUNT"
    case subscribe = "SUBSCRIBE"
    case error = "ERROR"
    case response = "RESPONSE"
}


