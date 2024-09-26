//
//  LaunchParametersSettingsView.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 21.09.2024.
//

import SwiftUI

struct LaunchParametersSettingsView<ViewModel>: View where ViewModel: LaunchParametersSettingsViewModelType {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            TextField("Launch parameters", text: $viewModel.text)
                .lineLimit(1)
                .font(.system(.body, design: .monospaced))
                .onChange(of: viewModel.text) { _, newText in
                    viewModel.didChange(text: newText)
                } 

            HStack(spacing: 4) {
                Button("Clear", action: viewModel.didTapClearButton)
                    .disabled(!viewModel.clearButtonIsEnabled)

                Button("Save changes", action: viewModel.didTapSaveButton)
                    .disabled(!viewModel.saveButtonIsEnabled)
            }

            Spacer()
        }
        .padding(8)
    }
}

// MARK: - Preview
#Preview {
    LaunchParametersSettingsView(viewModel: LaunchParametersSettingsViewModelMock())
        .padding()
        .frame(width: 400)
}

#if DEBUG
final class LaunchParametersSettingsViewModelMock: LaunchParametersSettingsViewModelType {
    var text = ""
    var clearButtonIsEnabled = false
    var saveButtonIsEnabled = false

    func didChange(text: String) {}
    func didTapClearButton() {}
    func didTapSaveButton() {}
}
#endif
