//
//  LogSettingsView.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 24.09.2024.
//

import SwiftUI

struct LogSettingsView<ViewModel>: View where ViewModel: LogSettingsViewModelType {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack {
                Color(nsColor: NSColor.textBackgroundColor)
                    .cornerRadius(4)

                TextEditor(text: $viewModel.message)
                    .disabled(true)
                    .font(.system(.body, design: .monospaced))
                    .padding(.vertical, 4)
            }
        }
        .padding(8)
    }
}

// MARK: - Preview
#Preview {
    LogSettingsView(viewModel: LogSettingsViewModelMock())
        .padding()
        .frame(width: 400)
}

#if DEBUG
final class LogSettingsViewModelMock: LogSettingsViewModelType {
    var message: String = "Log message"
}
#endif
