//
//  MainCommandHandler.swift
//
//
//  Created by Michael Karagiorgos on 29/7/24.
//

import Foundation

final class MainCommandHandler: CommandFlowHandler {
    let handlers: [CommandFlowHandler]
    
    init(
        handlers: [CommandFlowHandler]
    ) {
        self.handlers = handlers
    }
    
    func handleCommand(
        withRelations: Bool,
        rootDirectoryURL: URL,
        packageResolvedURL: URL?
    ) throws {
        try handlers.forEach {
            try $0.handleCommand(
                withRelations: withRelations,
                rootDirectoryURL: rootDirectoryURL,
                packageResolvedURL: packageResolvedURL
            )
        }
    }
}
