//
//  SPMFlowHandler.swift
//  
//
//  Created by Michael Karagiorgos on 2/8/24.
//

import Foundation

final class SPMCommandFlowHandler: CommandFlowHandler {
    let fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol) {
        self.fileManager = fileManager
    }
    
    func handleCommand(
        withRelations: Bool,
        shouldWrap: Bool,
        rootDirectoryURL: URL,
        packageResolvedURL: URL?
    ) throws {
        var appSDKsString: String?
        if let packageResolvedURL {
            appSDKsString = try parsePackageResolved(url: packageResolvedURL)
        }
        try parseAllPackages(
            for: rootDirectoryURL,
            appSDKsString: appSDKsString,
            withRelations: withRelations,
            shouldWrap: shouldWrap
        )
    }
}

private extension SPMCommandFlowHandler {
    func parsePackageResolved(url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        let resolvedDependencies = try JSONDecoder().decode(Pins.self, from: data)
        var appSDKString = ""
        appSDKString += "columns 1\n"
        var pinsCounter = 0
        appSDKString += "\tblock:AppSDKs\n"
        for pin in resolvedDependencies.pins.compactMap(\.identity) {
            pinsCounter += 1
            appSDKString += "\t\t\(pin)\n"
            if pinsCounter > 3 && pinsCounter % 4 == 0, pinsCounter < resolvedDependencies.pins.count {
                appSDKString += "\tend\n"
                appSDKString += "\tblock:AppSDKs\(pinsCounter)\n"
            }
        }
        appSDKString += "\tend\n"
        appSDKString += "\tblockArrowIdT9999<[\"3rd party SDKs\"]>(up)\n"
        appSDKString = appSDKString.replacingOccurrences(of: "-", with: ".")
        appSDKString = "block-beta\n" + appSDKString
        return appSDKString
    }
    
    func findPackageSwiftFiles(in directory: URL) -> [URL] {
        guard let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles],
            errorHandler: nil
        ) else {
            return []
        }
        var packageFiles: [URL] = []
        while let file = enumerator.nextObject() as? URL {
            if file.lastPathComponent == "Package.swift" {
                packageFiles.append(file)
            }
        }
        return packageFiles
    }
    
    func parseAllPackages(
        for url: URL,
        appSDKsString: String?,
        withRelations: Bool,
        shouldWrap: Bool
    ) throws {
        let urls = findPackageSwiftFiles(in: url)
        let packageWrappers = try urls.map { url in
            let package = try parsePackageSwift(at: url)
            let packageMetadata = try parsePackageSwiftMetadata(for: url)
            return CustomPackageWrapper(
                package: package,
                metadata: packageMetadata
            )
        }
        let targetWrappers = packageWrappers.map(transformToTargetWrappers(packageWrapper:)).flatMap { $0 }
        var diagramString = makeDiagramString(
            targetWrappers: targetWrappers,
            appSDKsString: appSDKsString,
            withRelations: withRelations
        )
        if shouldWrap {
            diagramString = "```mermaid\n" + diagramString + "\n```"
        }
        try writeFile(with: diagramString, at: url)
    }
    
    func writeFile(with string: String, at url: URL) throws {
        let fileURL = url.appendingPathComponent("Architecture.md")
        try string.write(to: fileURL, atomically: true, encoding: .utf8)
        debugPrint("New diagram created: \(fileURL)")
    }
    
    func transformToTargetWrappers(packageWrapper: CustomPackageWrapper) -> [TargetWrapper] {
        return (packageWrapper.package.targets ?? []).compactMap { target in
            guard target.type == .regular else { return nil }
            guard let metadata = packageWrapper.metadata.first(where: { $0.target == target.name }) else { return nil }
            return TargetWrapper(
                target: target,
                metadata: metadata
            )
        }
    }
    
    func makeDiagramString(
        targetWrappers: [TargetWrapper],
        appSDKsString: String?,
        withRelations: Bool
    ) -> String {
        let levels = targetWrappers.compactMap { Int($0.metadata.level ?? "") }.removeDuplicates().sorted()
        var diagramString = ""
        if let appSDKsString {
            diagramString += appSDKsString
        } else {
            diagramString += "block-beta\n"
            diagramString += "columns 1\n"
        }
        diagramString += "\tApp((\"APP\"))\n"
        var dependenciesString = "\n"
        dependenciesString += "\t%% Relations between modules\n"
        var sdksString = "\tblockArrowIdB9999<[\"3rd Party SDKs\"]>(down)\n"
        sdksString += "\tblock:3rd_Party_SDKs\n"
        let targetNames = targetWrappers.map(\.target.name)
        var parsedSDKs: [String] = []
        var sdksCounter = 0
        for level in levels {
            let levelModulesWithDuplicates = targetWrappers.filter { Int($0.metadata.level ?? "") == level }
            let levelModules = levelModulesWithDuplicates.removeDuplicates().sorted { m1, m2 in
                m1.target.dependencies.count > m2.target.dependencies.count
            }
            guard let firstModule = levelModules.first else { continue }
            diagramString += "\tblockArrowId\(level)<[\"\(firstModule.metadata.layer ?? "")\"]>(down)\n"
            diagramString += "\tblock:\(firstModule.metadata.layer ?? "")\n"
            var modulesCounter = 0
            for module in levelModules {
                modulesCounter += 1
                diagramString += "\t\t\(module.target.name)\n"
                if modulesCounter > 3 && modulesCounter % 4 == 0, modulesCounter < levelModules.count {
                    diagramString += "\tend\n"
                    diagramString += "\tblock:\(firstModule.metadata.layer ?? "")\(modulesCounter)\n"
                }
                for dependency in module.target.dependencies {
                    if let dependencyName = dependency.name() {
                        dependenciesString += "\t\(module.target.name) ---> \(dependencyName)\n"
                    }
                    if dependency.isRemote(), let dependencyName = dependency.name(), !targetNames.contains(dependencyName), !parsedSDKs.contains(dependencyName) {
                        parsedSDKs.append(dependencyName)
                        sdksCounter += 1
                        sdksString += "\t\t\(dependencyName)\n"
                        if sdksCounter > 3 && sdksCounter % 4 == 0 {
                            sdksString += "\tend\n"
                            sdksString += "\tblock:3rd_Party_SDKs\(sdksCounter)\n"
                        }
                    }
                }
                if !module.target.dependencies.isEmpty {
                    dependenciesString += "\n"
                }
            }
            diagramString += "\tend\n"
        }
        // we might need to remove 2 previous lines if they are empty block lines
        sdksString += "\tend\n"
        return diagramString + sdksString + (withRelations ? dependenciesString : "")
    }
    
    func parsePackageSwiftMetadata(for url: URL) throws -> [CustomTargetMetadata] {
        let fileContent = try String(contentsOf: url, encoding: .utf8)
        let lines = fileContent.split(separator: "\n")
        var layers: [String] = []
        var levels: [String] = []
        var targets: [String] = []
        for line in lines {
            if let target = extractMetadata(for: line, prefix: "// swift-arch-target:") {
                targets.append(target)
            }
            if let layer = extractMetadata(for: line, prefix: "// swift-arch-layer:") {
                layers.append(layer)
            }
            if let level = extractMetadata(for: line, prefix: "// swift-arch-level:") {
                levels.append(level)
            }
        }
        guard targets.count == layers.count && targets.count == levels.count else {
            throw CommandFlowError.invalidModuleComments
        }
        return targets.enumerated().map { index, target  in
            CustomTargetMetadata(
                target: target,
                level: levels[index],
                layer: layers[index]
            )
        }
    }
    
    func extractMetadata(for line: String.SubSequence, prefix: String) -> String? {
        guard
            line.trimmingCharacters(in: .whitespaces).contains(prefix),
            let range = line.range(of: prefix) 
        else { return nil }
        return line[range.upperBound...].trimmingCharacters(in: .whitespaces)
    }
    
    func parsePackageSwift(at url: URL) throws -> CustomPackage {
        let output =  try ShellHandler.shell("swift package --package-path \(url.deletingLastPathComponent().path) dump-package")
        guard let data = output?.data(using: .utf8) else {
            throw CommandFlowError.shellOutputNil
        }
        let decoder = JSONDecoder()
        let package = try decoder.decode(CustomPackage.self, from: data)
        return package
    }
}
