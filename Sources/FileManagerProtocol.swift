//
//  FileManagerProtocol.swift
//
//
//  Created by Michael Karagiorgos on 2/8/24.
//

import Foundation

protocol FileManagerProtocol {
    func enumerator(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options mask: FileManager.DirectoryEnumerationOptions,
        errorHandler handler: ((URL, Error) -> Bool)?
    ) -> FileManager.DirectoryEnumerator?
}

extension FileManager: FileManagerProtocol {}
