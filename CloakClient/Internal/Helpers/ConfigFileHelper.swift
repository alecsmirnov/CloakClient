//
//  ConfigFileHelper.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

private enum Constants {
    static let configFileName = "ck-client-config.json"
}

enum ConfigFileHelper {
    static var configFileURL: URL {
        get throws {
            let fileURL = try FileManager.default
                .url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                .appendingPathComponent(Constants.configFileName)

            return fileURL
        }
    }

    static var isConfigFileExists: Bool {
        guard let configFilePath = try? configFileURL.path else {
            return false
        }

        return FileManager.default.fileExists(atPath: configFilePath)
    }

    static func readText(from url: URL) throws -> String {
        try String(contentsOf: url, encoding: .utf8)
    }

    static func readText() throws -> String {
        let configFileURL = try configFileURL

        return try String(contentsOf: configFileURL, encoding: .utf8)
    }

    static func write(text: String) throws {
        let configFileURL = try configFileURL

        try text.write(to: configFileURL, atomically: true, encoding: .utf8)
    }
}
