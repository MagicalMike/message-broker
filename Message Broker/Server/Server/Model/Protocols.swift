//
//  Protocols.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/3/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

enum Command: String {
    case none = "NONE"
    case put = "PUT"
    case count = "COUNT"
    case remove = "REMOVE"
    case get = "GET"
    case subscribe = "SUBSCRIBE"
    case response = "RESPONSE"
    case error = "ERROR"
}
