//
//  MenuViewModel.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 22.09.2024.
//

import Combine
import SwiftUI

enum StartStopButtonStateKind {
    case start
    case stop
    case configurationFileIsMissing
}

protocol MenuViewModelType: ObservableObject {
    var startStopButtonStateKind: StartStopButtonStateKind { get }
    var errorMessage: String? { get set }

    func didTapStartStopButton()
    func didTapQuitButton()
}

extension MenuViewModelType {
    var real: MenuViewModel {
        guard let viewModel = self as? MenuViewModel else {
            fatalError("Unable to cast to MenuViewModel")
        }

        return viewModel
    }
}

final class MenuViewModel: MenuViewModelType {
    @Published var startStopButtonStateKind: StartStopButtonStateKind
    @Published var errorMessage: String?

    private var disposeBag = Set<AnyCancellable>()

    private let binaryFileExecutionService: BinaryFileExecutionService

    init(
        menuButtonStateService: MenuButtonStateService,
        binaryFileExecutionService: BinaryFileExecutionService
    ) {
        self.binaryFileExecutionService = binaryFileExecutionService

        startStopButtonStateKind = ConfigFileHelper.isConfigFileExists
            ? .start
            : .configurationFileIsMissing

        menuButtonStateService.$startStopButtonKindPublisher
            .dropFirst()
            .sink { [weak self] in
                self?.startStopButtonStateKind = $0
            }
            .store(in: &disposeBag)
    }
}

// MARK: - Events
extension MenuViewModel {
    func didTapStartStopButton() {
        switch startStopButtonStateKind {
            case .start:
                do {
                    try binaryFileExecutionService.execute()

                    startStopButtonStateKind = .stop
                } catch {
                    errorMessage = error.localizedDescription

                    print("Error running file: \(error.localizedDescription)")
                }
            case .stop:
                binaryFileExecutionService.kill()

                startStopButtonStateKind = .start
            case .configurationFileIsMissing:
                break
        }
    }

    func didTapQuitButton() {
        binaryFileExecutionService.kill()
        
        NSApplication.shared.terminate(nil)
    }
}
