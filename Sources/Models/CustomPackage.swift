//
//  File.swift
//  
//
//  Created by Michael Karagiorgos on 2/8/24.
//

import Foundation

struct TargetWrapper {
    let target: CustomTarget
    let metadata: CustomTargetMetadata
}

struct CustomPackageWrapper {
    let package: CustomPackage
    let metadata: [CustomTargetMetadata]
}

struct ModuleDefinition: Codable {
    let name: String
    let containerName: String?
    let canImport: [String]
    let level: Int
}

struct CustomTargetMetadata {
    let target: String?
    let level: String?
    let layer: String?
}

struct CustomPackage: Codable {
    let targets: [CustomTarget]?
}

struct CustomTarget: Codable {
    let name: String
    let type: CustomTargetType
    let dependencies: [CustomTargetDependency]
}

enum CustomTargetType: String, Codable {
    case regular
    case test
}

struct CustomTargetDependency: Codable {
    let product: [String?]?
    let byName: [String?]?
    
    func name() -> String? {
        let firstProduct = product?.compactMap { $0 }.first
        let firstByName = byName?.compactMap { $0 }.first
        return firstProduct ?? firstByName
    }
    
    func isRemote() -> Bool {
        product?.compactMap { $0 }.first != nil
    }
}
