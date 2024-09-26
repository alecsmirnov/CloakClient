//
//  BinaryFileExecutionService.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

private enum Constants {
    static func binaryPathComponent(for architectureKind: ArchitectureKind) -> String {
        "/Contents/Resources/ck-client-darwin-\(architectureKind.rawValue)-v2.9.0.dylib"
    }
}

private enum BinaryFileExecutionServiceErrorKind: Error, LocalizedError {
    case binaryFileNotFound
    case configFileNotFound

    var errorDescription: String? {
        switch self {
            case .binaryFileNotFound:
                NSLocalizedString("Binary file not found", comment: "Binary file execution service")
            case .configFileNotFound:
                NSLocalizedString("Config file not found", comment: "Binary file execution service")
        }
    }
}

final class BinaryFileExecutionService {
    @Published private(set) var outputMessagePublisher: String = ""
    
    private var process: Process?
    private let architectureInfoService = ArchitectureInfoService()
}

// MARK: - Public methods
extension BinaryFileExecutionService {
    func execute() throws {
        let architectureKind = architectureInfoService.getArchitectureKind()

        guard let binaryFilePath = Self.binaryFilePath(for: architectureKind) else {
            throw BinaryFileExecutionServiceErrorKind.binaryFileNotFound
        }

        guard let configFilePath = Self.configFilePath() else {
            throw BinaryFileExecutionServiceErrorKind.configFileNotFound
        }

        let commandArguments = "-u -c \(configFilePath)"
        let commandLaunchParameters = Self.launchParameters()
        let command = commandLaunchParameters.isEmpty
            ? "\(binaryFilePath) \(commandArguments)"
            : "\(binaryFilePath) \(commandArguments) \(commandLaunchParameters)"

        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            let availableData = fileHandle.availableData

            guard !availableData.isEmpty else {
                pipe.fileHandleForReading.readabilityHandler = nil
                return
            }

            guard let message = String(data: availableData, encoding: .utf8) else { return }

            DispatchQueue.main.async {
                self?.outputMessagePublisher = message
            }
        }

        let errorPipe = Pipe()
        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            let availableData = fileHandle.availableData

            guard !availableData.isEmpty else {
                errorPipe.fileHandleForReading.readabilityHandler = nil
                return
            }

            guard let message = String(data: availableData, encoding: .utf8) else { return }

            DispatchQueue.main.async {
                self?.outputMessagePublisher = message
            }
        }

        process = Process()
        process?.launchPath = "/bin/sh"
        process?.arguments = ["-c", command]
        process?.standardOutput = pipe
        process?.standardError = errorPipe

        do {
            try process?.run()
        } catch {
            throw error
        }
    }

    func kill() {
        process?.terminate()
    }
}

// MARK: - Helper methods
private extension BinaryFileExecutionService {
    static func binaryFilePath(for architectureKind: ArchitectureKind) -> String? {
        let bundlePath = Bundle.main.bundlePath
        let binaryFilePath = bundlePath + Constants.binaryPathComponent(for: architectureKind)

        return FileManager.default.fileExists(atPath: binaryFilePath) ? binaryFilePath : nil
    }

    static func configFilePath() -> String? {
        guard let configFilePath = try? ConfigFileHelper.configFileURL.path else {
            return nil
        }

        return FileManager.default.fileExists(atPath: configFilePath) ? configFilePath : nil
    }

    static func launchParameters() -> String {
        UserDefaultsHelper.getLaunchParameters() ?? ""
    }
}
