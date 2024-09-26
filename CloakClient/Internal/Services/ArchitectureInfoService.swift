//
//  ArchitectureInfoService.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

enum ArchitectureKind: String {
    case arm64
    case amd64
}

final class ArchitectureInfoService {
    private var cachedArchitectureKind: ArchitectureKind?

    func getArchitectureKind() -> ArchitectureKind {
        if let cachedArchitectureKind {
            return cachedArchitectureKind
        }

        let pipe = Pipe()

        let process = Process()
        process.launchPath = "/bin/sh"
        process.arguments = ["-c", "uname -m"]
        process.standardOutput = pipe

        process.launch()

        guard let outputData = try? pipe.fileHandleForReading.readToEnd(),
              let machineSystemInformation = String(data: outputData, encoding: .utf8),
              machineSystemInformation.contains(ArchitectureKind.arm64.rawValue)
        else {
            cachedArchitectureKind = .amd64
            
            return .amd64
        }

        cachedArchitectureKind = .arm64

        return .arm64
    }
}
