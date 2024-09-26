//
//  JSONFileDocument.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import SwiftUI
import UniformTypeIdentifiers

private enum ErrorKind: Error {
    case unableToGetTextFromReadConfiguration
    case fileNotFound
}

struct JSONFileDocument: FileDocument {
    static let readableContentTypes: [UTType] = [.json]

    private let text: String?

    init(text: String) {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw ErrorKind.unableToGetTextFromReadConfiguration
        }

        text = String(data: data, encoding: .utf8)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let text else {
            throw ErrorKind.fileNotFound
        }

        let data = Data(text.utf8)

        return FileWrapper(regularFileWithContents: data)
    }
}
