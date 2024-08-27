//
//  ShellHandler.swift
//  
//
//  Created by Michael Karagiorgos on 2/8/24.
//

import Foundation

enum ShellHandler {
    static func shell(_ command: String) throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["bash", "-c", command]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
