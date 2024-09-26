//
//  LaunchParametersSettingsVM.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Foundation

protocol LaunchParametersSettingsViewModelType: ObservableObject {
    var text: String { get set }

    var clearButtonIsEnabled: Bool { get set }
    var saveButtonIsEnabled: Bool { get set }

    func didChange(text: String)
    func didTapClearButton()
    func didTapSaveButton()
}

extension LaunchParametersSettingsViewModelType {
    var real: LaunchParametersSettingsViewModel {
        guard let viewModel = self as? LaunchParametersSettingsViewModel else {
            fatalError("Unable to cast to LaunchParametersSettingsViewModel")
        }

        return viewModel
    }
}

final class LaunchParametersSettingsViewModel: LaunchParametersSettingsViewModelType {
    @Published var text: String = ""
    @Published var clearButtonIsEnabled: Bool = false
    @Published var saveButtonIsEnabled: Bool = false

    private var storedText: String?

    init() {
        let launchParametersText = UserDefaultsHelper.getLaunchParameters() ?? ""

        text = launchParametersText
        storedText = launchParametersText

        clearButtonIsEnabled = !launchParametersText.isEmpty
        saveButtonIsEnabled = false
    }
}

// MARK: - Events
extension LaunchParametersSettingsViewModel {
    func didChange(text: String) {
        clearButtonIsEnabled = text != ""
        saveButtonIsEnabled = text != storedText
    }

    func didTapClearButton() {
        text = ""
        storedText = ""

        clearButtonIsEnabled = false
        saveButtonIsEnabled = false

        UserDefaultsHelper.clearLaunchParameters()
    }

    func didTapSaveButton() {
        storedText = text
        saveButtonIsEnabled = false

        UserDefaultsHelper.set(launchParameters: text)
    }
}
