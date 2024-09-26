//
//  MenuView.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 21.09.2024.
//

import SwiftUI

struct MenuView<ViewModel>: View where ViewModel: MenuViewModelType {
    @StateObject var viewModel: ViewModel
    let didStart: () -> Void
    let didStop: () -> Void

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 0) {
            Button(startStopButtonTitle) {
                viewModel.didTapStartStopButton()

                if viewModel.startStopButtonStateKind == .start {
                    didStop()
                } else {
                    didStart()
                }
            }
            .disabled(startStopButtonIsDisabled)
            
            Divider()

            Button("Settings") {
                openWindow(id: WindowIdentifiers.settings)
                NSApp.activate(ignoringOtherApps: true)
            }

            Divider()
            
            Button("Quit CloakClient", action: viewModel.didTapQuitButton)
                .keyboardShortcut("q")
        }
        .alert(
            viewModel.errorMessage ?? "",
            isPresented: $viewModel.errorMessage.map(get: { $0 != nil }, set: { _ in nil })
        ) {
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Helpers
private extension MenuView {
    var startStopButtonTitle: String {
        switch viewModel.startStopButtonStateKind {
            case .start:
                "Start"
            case .stop:
                "Stop"
            case .configurationFileIsMissing:
                "Configuration file is missing: add in Settings"
        }
    }

    var startStopButtonIsDisabled: Bool {
        viewModel.startStopButtonStateKind == .configurationFileIsMissing
    }
}

// MARK: - Preview
#Preview {
    Menu("Menu") {
        MenuView(
            viewModel: MenuViewModelMock(),
            didStart: {},
            didStop: {}
        )
    }
    .frame(width: 200)
    .fixedSize()
}

#if DEBUG
private final class MenuViewModelMock: MenuViewModelType {
    var startStopButtonStateKind: StartStopButtonStateKind = .configurationFileIsMissing
    var errorIsShowed = false
    var errorMessage: String?

    func didTapStartStopButton() {}
    func didTapSettingsButton() {}
    func didTapQuitButton() {}
}
#endif
