//
//  CommandFlowHandler.swift
//  
//
//  Created by Michael Karagiorgos on 2/8/24.
//

import Foundation

protocol CommandFlowHandler {
    func handleCommand(
        withRelations: Bool,
        rootDirectoryURL: URL,
        packageResolvedURL: URL?
    ) throws
}
