
import ArgumentParser
import Foundation
import Yams

@main
struct SwiftArchDiagram: ParsableCommand {
    @Option(name: .shortAndLong, help: "Directory to search.")
    var directory: String
    
    @Option(name: .shortAndLong, help: "Package.resolved path")
    var rpath: String?
    
    @Flag(name: .shortAndLong, help: "Should add relation arrows for modules")
    var withRelations: Bool = false

    func run() throws {
        let directoryURL = URL(fileURLWithPath: directory)
        var resolvedURL: URL?
        if let rpath {
            resolvedURL = URL(fileURLWithPath: rpath)
        }
        let spmHandler = SPMCommandFlowHandler(fileManager: FileManager.default)
        let parser = MainCommandHandler(handlers: [spmHandler])
        try parser.handleCommand(
            withRelations: withRelations,
            rootDirectoryURL: directoryURL,
            packageResolvedURL: resolvedURL
        )
        print("Diagram has been generated successfully.")
    }
}
