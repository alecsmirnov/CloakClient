//
//  SettingsView.swift
//  CloakClient
//
//  Created by Alexander Smirnov on 21.09.2024.
//

import SwiftUI

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModelType {
    let viewModel: ViewModel

    var body: some View {
        NavigationSplitView(
            preferredCompactColumn: .constant(.sidebar),
            sidebar: {
                List(selection: .constant(0)) {
                    NavigationLink(
                        destination: {
                            // I still don't like that there is no normal solution
                            // to use ObservableObject with protocol.
                            //
                            // To be able to use different VMs during runtime in View,
                            // I have to use tricks like this
                            if isPreview {
                                ConfigurationFileSettingsView(
                                    viewModel: viewModel.configFileSettingsViewModel.mock
                                )
                            } else {
                                ConfigurationFileSettingsView(
                                    viewModel: viewModel.configFileSettingsViewModel.real
                                )
                            }
                        },
                        label: {
                            Text("Configuration file")
                        }
                    )
                    .listRowSeparator(.hidden)
                    .tag(0)

                    NavigationLink(
                        destination: {
                            if isPreview {
                                LaunchParametersSettingsView(
                                    viewModel: viewModel.launchParametersSettingsViewModel.mock
                                )
                            } else {
                                LaunchParametersSettingsView(
                                    viewModel: viewModel.launchParametersSettingsViewModel.real
                                )
                            }
                        },
                        label: {
                            Text("Launch parameters")
                        }
                    )
                    .tag(1)

                    NavigationLink(
                        destination: {
                            if isPreview {
                                LogSettingsView(viewModel: viewModel.logSettingsViewModel.mock)
                            } else {
                                LogSettingsView(viewModel: viewModel.logSettingsViewModel.real)
                            }
                        },
                        label: {
                            Text("Log")
                        }
                    )
                    .tag(2)
                }
                .navigationSplitViewColumnWidth(180)
                .toolbar(.hidden, for: .windowToolbar)
            },
            detail: {}
        )
    }
}

// MARK: - Preview
#Preview {
    SettingsView(viewModel: SettingsViewModelMock())
}

#if DEBUG
private final class SettingsViewModelMock: SettingsViewModelType {
    let configFileSettingsViewModel: any ConfigurationFileSettingsViewModelType
    let launchParametersSettingsViewModel: any LaunchParametersSettingsViewModelType
    let logSettingsViewModel: any LogSettingsViewModelType

    init() {
        configFileSettingsViewModel = ConfigurationFileSettingsViewModelMock()
        launchParametersSettingsViewModel = LaunchParametersSettingsViewModelMock()
        logSettingsViewModel = LogSettingsViewModelMock()
    }
}

private extension ConfigurationFileSettingsViewModelType {
    var mock: ConfigurationFileSettingsViewModelMock {
        guard let viewModel = self as? ConfigurationFileSettingsViewModelMock else {
            fatalError("Unable to cast to ConfigurationFileSettingsViewModelMock")
        }

        return viewModel
    }
}

private extension LaunchParametersSettingsViewModelType {
    var mock: LaunchParametersSettingsViewModelMock {
        guard let viewModel = self as? LaunchParametersSettingsViewModelMock else {
            fatalError("Unable to cast to LaunchParametersSettingsViewModelMock")
        }

        return viewModel
    }
}

private extension LogSettingsViewModelType {
    var mock: LogSettingsViewModelMock {
        guard let viewModel = self as? LogSettingsViewModelMock else {
            fatalError("Unable to cast to LogSettingsViewModelMock")
        }

        return viewModel
    }
}
#endif
