//
//  CloakClientApp.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import SwiftUI

@main
struct CloakClientApp: App {
    @State private var buttonIsEnabled = false

    private var menuImage: ImageResource {
        buttonIsEnabled 
            ? ImageResource.Menu.ckClientMenuActive
            : ImageResource.Menu.ckClientMenuInactive
    }

    private let menuViewModel: any MenuViewModelType
    private let settingsViewModel: any SettingsViewModelType

    var body: some Scene {
        MenuBarExtra("CloakClient", image: menuImage) {
            MenuView(
                viewModel: menuViewModel.real,
                // Bad code, but I still wanted to do everything on SwiftUI.
                // SwiftUI is still very sad :(
                didStart: {
                    buttonIsEnabled = true
                },
                didStop: {
                    buttonIsEnabled = false
                }
            )
        }

        Window("ClockClient Settings", id: WindowIdentifiers.settings) {
            SettingsView(viewModel: settingsViewModel.real)
        }
    }

    init() {
        let menuButtonStateService = MenuButtonStateService()
        let binaryFileExecutionService = BinaryFileExecutionService()

        menuViewModel = MenuViewModel(
            menuButtonStateService: menuButtonStateService,
            binaryFileExecutionService: binaryFileExecutionService
        )
        settingsViewModel = SettingsViewModel(
            menuButtonStateService: menuButtonStateService,
            binaryFileExecutionService: binaryFileExecutionService
        )
    }
}
