//
//  LogSettingsVM.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 24.09.2024.
//

import Combine

protocol LogSettingsViewModelType: ObservableObject {
    var message: String { get set }
}

extension LogSettingsViewModelType {
    var real: LogSettingsViewModel {
        guard let viewModel = self as? LogSettingsViewModel else {
            fatalError("Unable to cast to LogSettingsViewModel")
        }

        return viewModel
    }
}

final class LogSettingsViewModel: LogSettingsViewModelType {
    @Published var message: String = ""

    private var disposeBag = Set<AnyCancellable>()

    init(binaryFileExecutionService: BinaryFileExecutionService) {
        binaryFileExecutionService.$outputMessagePublisher
            .dropFirst()
            .sink { [weak self] in
                self?.message += $0
            }
            .store(in: &disposeBag)
    }
}
