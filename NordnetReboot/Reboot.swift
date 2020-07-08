//
//  Reboot.swift
//  NordnetReboot
//
//  Created by Nathan FALLET on 08/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import APIRequest

class Reboot {
    
    static let authorization = "Basic bm9yZG5ldDpub3JkbmV0"
    
    static func reboot(completionHandler: @escaping () -> ()) {
        // Set configuration if not done yet
        if APIConfiguration.current == nil {
            APIConfiguration.current = APIConfiguration(host: "192.168.5.1", scheme: "http").with(decoder: RebootDecoder())
        }
        
        // Send an HTTP request to reboot the rooter
        APIRequest("GET", path: "/resetrouter.html").with(header: "Authorization", value: authorization).execute(String.self) { data, status in
            // Check if response is successful
            if let data = data {
                // Extract session key
                let groups = data.groups(for: "var sessionKey ?= ?'([0-9]+)' ?;")
                
                // If we got it
                if let group = groups.first {
                    // Call the request with the session key
                    APIRequest("GET", path: "/rebootinfo.cgi").with(header: "Authorization", value: authorization).with(name: "sessionKey", value: group[1]).execute(String.self) { data2, status2 in
                        // Show success back
                        completionHandler()
                    }
                }
            }
        }
    }
    
}

extension String {
    
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

class RebootDecoder: APIDecoder {
    
    func decode<T>(from data: Data, as type: T.Type) -> T? where T : Decodable {
        return String(bytes: data, encoding: .utf8) as? T
    }
    
}
