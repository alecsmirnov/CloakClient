//
//  View+isPreview.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 24.09.2024.
//

import SwiftUI

extension View {
    var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
