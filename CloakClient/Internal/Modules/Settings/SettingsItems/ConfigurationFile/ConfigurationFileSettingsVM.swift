//
//  ConfigurationFileSettingsVM.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

protocol ConfigurationFileSettingsViewModelType: ObservableObject {
    var text: String { get set }
    var saveButtonIsEnabled: Bool { get set }
    var exportButtonIsEnabled: Bool { get set }
    var importerIsShowed: Bool { get set }
    var exporterIsShowed: Bool { get set }
    var errorMessage: String? { get set }

    func didChange(text: String)
    func didTapImportButton()
    func didTapExportButton()
    func didTapSaveButton()
    func didImportFile(result: Result<URL, Error>)
    func didExportFile(result: Result<URL, Error>)
}

extension ConfigurationFileSettingsViewModelType {
    var real: ConfigurationFileSettingsViewModel {
        guard let viewModel = self as? ConfigurationFileSettingsViewModel else {
            fatalError("Unable to cast to ConfigurationFileSettingsViewModel")
        }

        return viewModel
    }
}

final class ConfigurationFileSettingsViewModel: ConfigurationFileSettingsViewModelType {
    @Published var text: String
    @Published var saveButtonIsEnabled: Bool
    @Published var exportButtonIsEnabled: Bool
    @Published var importerIsShowed: Bool
    @Published var exporterIsShowed: Bool
    @Published var errorMessage: String?

    private var storedText: String?
    private let menuButtonStateService: MenuButtonStateService

    init(menuButtonStateService: MenuButtonStateService) {
        self.menuButtonStateService = menuButtonStateService

        let configText = (try? ConfigFileHelper.readText()) ?? ""
        
        text = configText
        storedText = configText

        saveButtonIsEnabled = false
        exportButtonIsEnabled = !configText.isEmpty

        importerIsShowed = false
        exporterIsShowed = false
    }
}

// MARK: - Events
extension ConfigurationFileSettingsViewModel {
    func didChange(text: String) {
        saveButtonIsEnabled = text != storedText
    }

    func didTapImportButton() {
        importerIsShowed = true
    }

    func didTapExportButton() {
        exporterIsShowed = true
    }

    func didTapSaveButton() {
        do {
            try ConfigFileHelper.write(text: text)

            if storedText == "" {
                menuButtonStateService.startStopButtonKindPublisher = .start
            }

            storedText = text
            exportButtonIsEnabled = true
            saveButtonIsEnabled = false
        } catch {
            errorMessage = error.localizedDescription

            print("File save error: \(error.localizedDescription)")
        }
    }

    func didImportFile(result: Result<URL, Error>) {
        switch result {
            case let .success(url):
                do {
                    text = try ConfigFileHelper.readText(from: url)
                    saveButtonIsEnabled = true
                } catch {
                    errorMessage = error.localizedDescription

                    print("Error reading exported file: \(error.localizedDescription)")
                }
            case let .failure(error):
                errorMessage = error.localizedDescription
                
                print("File import error: \(error.localizedDescription)")
        }
    }

    func didExportFile(result: Result<URL, Error>) {
        switch result {
            case .success:
                break
            case let .failure(error):
                errorMessage = error.localizedDescription

                print("File export error: \(error.localizedDescription)")
        }
    }
}
