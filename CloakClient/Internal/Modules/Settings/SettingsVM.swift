//
//  SettingsVM.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Combine

protocol SettingsViewModelType: AnyObject {
    var configFileSettingsViewModel: any ConfigurationFileSettingsViewModelType { get }
    var launchParametersSettingsViewModel: any LaunchParametersSettingsViewModelType { get }
    var logSettingsViewModel: any LogSettingsViewModelType { get }
}

extension SettingsViewModelType {
    var real: SettingsViewModel {
        guard let viewModel = self as? SettingsViewModel else {
            fatalError("Unable to cast to SettingsViewModel")
        }

        return viewModel
    }
}

final class SettingsViewModel: SettingsViewModelType {
    let configFileSettingsViewModel: any ConfigurationFileSettingsViewModelType
    let launchParametersSettingsViewModel: any LaunchParametersSettingsViewModelType
    let logSettingsViewModel: any LogSettingsViewModelType

    init(
        menuButtonStateService: MenuButtonStateService,
        binaryFileExecutionService: BinaryFileExecutionService
    ) {
        configFileSettingsViewModel = ConfigurationFileSettingsViewModel(
            menuButtonStateService: menuButtonStateService
        )
        
        launchParametersSettingsViewModel = LaunchParametersSettingsViewModel()
        
        logSettingsViewModel = LogSettingsViewModel(
            binaryFileExecutionService: binaryFileExecutionService
        )
    }
}
