//
//  URL+Timestamp.swift
//
//
//  Created by Anthony Ingle on 2/6/24.
//

import Foundation

extension URL {
    // Inserts a timestamp into a URL's filename
    // e.g. "/path/to/file.ext" -> "/path/to/file~1587197384.ext"
    // credit to: https://gist.github.com/martinhoeller/4bf05d5a647cd465d736d319e17b2bec
    func addingTimestamp(separator: String = "_") -> URL {
        let timestamp = Int(Date().timeIntervalSince1970)
        let filename = deletingPathExtension().lastPathComponent + "\(separator)\(timestamp).\(pathExtension)"
        return deletingLastPathComponent().appendingPathComponent(filename)
    }
}
