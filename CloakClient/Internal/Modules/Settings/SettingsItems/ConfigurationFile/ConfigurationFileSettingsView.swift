//
//  ConfigurationFileSettingsView.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 21.09.2024.
//

import SwiftUI

struct ConfigurationFileSettingsView<ViewModel>: View where ViewModel: ConfigurationFileSettingsViewModelType {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack {
                Color(nsColor: NSColor.textBackgroundColor)
                    .cornerRadius(4)

                TextEditor(text: $viewModel.text)
                    .font(.system(.body, design: .monospaced))
                    .padding(.vertical, 4)
                    .onChange(of: viewModel.text) { _, newText in
                        viewModel.didChange(text: newText)
                    }
            }

            HStack(spacing: 4) {
                Button("Import", action: viewModel.didTapImportButton)

                Button("Export", action: viewModel.didTapExportButton)
                    .disabled(!viewModel.exportButtonIsEnabled)

                Button("Save changes", action: viewModel.didTapSaveButton)
                    .disabled(!viewModel.saveButtonIsEnabled)
            }
        }
        .padding(8)
        .fileImporter(
            isPresented: $viewModel.importerIsShowed,
            allowedContentTypes: [.plainText, .json],
            onCompletion: viewModel.didImportFile(result:)
        )
        .fileExporter(
            isPresented: $viewModel.exporterIsShowed,
            document: JSONFileDocument(text: viewModel.text),
            contentType: .json,
            onCompletion: viewModel.didExportFile(result:)
        )
        .alert(
            viewModel.errorMessage ?? "",
            isPresented: $viewModel.errorMessage.map(get: { $0 != nil }, set: { _ in nil })
        ) {
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Preview
#Preview {
    ConfigurationFileSettingsView(viewModel: ConfigurationFileSettingsViewModelMock())
        .padding()
        .frame(width: 400)
}

#if DEBUG
final class ConfigurationFileSettingsViewModelMock: ConfigurationFileSettingsViewModelType {
    var text: String = "{}"
    var saveButtonIsEnabled = false
    var exportButtonIsEnabled = false
    var importerIsShowed = false
    var exporterIsShowed = false
    var errorIsShowed = false
    var errorMessage: String?

    func didChange(text: String) {}
    func didTapImportButton() {}
    func didTapExportButton() {}
    func didTapSaveButton() {}
    func didImportFile(result: Result<URL, Error>) {}
    func didExportFile(result: Result<URL, Error>) {}
}
#endif
