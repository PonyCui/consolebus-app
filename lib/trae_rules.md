# Trae Rules for `lib` Directory (ConsoleBus Application Core)

## 1. Functionality

The `lib` directory is the heart of the ConsoleBus Flutter application, containing all the Dart code that defines its features, user interface, services, communication protocols, and utilities. It orchestrates the entire application lifecycle, from initialization to feature management and UI rendering.

Key functionalities managed within `lib` include:

*   **Application Initialization**: Setting up the Flutter application, initializing window properties, and launching the main UI (handled in `main.dart`).
*   **Core UI Structure**: Defining the main application layout, including navigation (menu bar/bottom navigation) and content areas (handled in `apps_home.dart`).
*   **Feature Management**: Abstracting application features (Console, Network, Preferences) and providing a system for registering and accessing them (defined in `apps_feature.dart` and utilized in `apps_home.dart`).
*   **Modular Design**: Organizing code into distinct subdirectories for `components`, `features`, `protocols`, `services`, and `utils`, promoting separation of concerns.
*   **Service Layer**: Managing background tasks, data handling, and communication with client SDKs (primarily in the `services` subdirectory).
*   **Data Protocols**: Defining the structure of data exchanged with client SDKs (in the `protocols` subdirectory).
*   **Reusable UI Components**: Providing shared widgets for consistent UI across features (in the `components` subdirectory).
*   **Utility Functions**: Offering common helper functions (in the `utils` subdirectory).

## 2. Directory Structure

The `lib` directory is organized into several key subdirectories and root-level files:

```
lib/
├── apps_feature.dart         # Defines the abstract AppsFeature class and AppsFeatureManager for feature registration and retrieval.
├── apps_home.dart            # Defines the main application widget (AppsHome), managing overall layout and feature navigation.
├── main.dart                 # The main entry point of the Flutter application.
|
├── components/               # Contains reusable UI components shared across features.
│   └── trae_rules.md
├── connectors/               # Intended for communication connectors (currently underutilized, logic might be in services).
│   └── trae_rules.md
├── features/                 # Contains modules for distinct application features (Console, Filesystem, Network, Preference).
│   └── trae_rules.md
├── protocols/                # Defines data structures for communication with client SDKs.
│   └── trae_rules.md
├── services/                 # Manages background services, data handling, and WebSocket communication.
│   └── trae_rules.md
├── utils/                    # Provides utility functions, like responsive design helpers.
│   └── trae_rules.md
└── trae_rules.md             # This file, describing the overall lib directory.
```

## 3. Coding Standards (General for `lib`)

*   **Flutter & Dart Best Practices**: Adherence to official Flutter and Dart coding guidelines (e.g., effective Dart, linting rules from `analysis_options.yaml`).
*   **Modularity and Separation of Concerns**: Code should be organized logically into the predefined directory structure.
*   **Naming Conventions**:
    *   `PascalCase` for class names.
    *   `camelCase` for method/function names and variables.
    *   `snake_case` for file names and directory names (except where class name matches file name, e.g. `AppsHome.dart` could be `apps_home.dart`).
*   **State Management**: Consistent use of state management solutions (e.g., `ChangeNotifier` with Provider, or other chosen patterns like BLoC/Riverpod) for shared application state. Local UI state managed with `StatefulWidget`.
*   **Immutability**: Prefer immutable data structures where possible, especially for state objects and protocol messages.
*   **Asynchronous Programming**: Correct use of `async/await`, `Future`s, and `Stream`s for non-blocking operations.
*   **Error Handling**: Robust error handling for network operations, file I/O, and data parsing.
*   **Widget Composition**: Building complex UIs by composing smaller, reusable widgets.
*   **Documentation**: Public APIs, complex logic, and non-obvious code sections should be well-commented.

## 4. Dependencies

### Internal Dependencies:

*   All subdirectories within `lib` are interdependent, forming the complete application.

### External Dependencies (from `pubspec.yaml` - partial list based on observed imports):

*   **`flutter/material.dart`**: Core Flutter framework for UI.
*   **`window_manager`**: For managing desktop window properties (`main.dart`).
*   **`shelf`**, **`shelf_io`**, **`shelf_web_socket`**: For WebSocket server implementation in `services/apps_connector_ws.dart`.
*   (Other dependencies as listed in `pubspec.yaml` for features like file picking, path providing, etc.)

## 5. State Management Overview

*   **Global Application State**: Primarily managed by `AppsConnectService` (<mcfile name="apps_connect_service.dart" path="lib/services/apps_connect_service.dart"></mcfile>), which is a `ChangeNotifier` holding all received messages, device lists, and the selected device. This service is a singleton and provides data to various parts of the UI.
*   **Feature-Specific State**: Individual features (e.g., `ConsoleFilterController`, `NetworkFilterController`) manage their own local state related to filtering and UI presentation, often also using `ChangeNotifier`.
*   **UI State**: Local widget state is managed using `StatefulWidget` and `setState` within components and feature screens (e.g., `_AppsHomeState` manages `selectedFeature`).
*   **Navigation State**: Managed by `AppsHome` for switching between features.

## 6. Summary of Root-Level Files

*   **`apps_feature.dart`**: Defines the <mcsymbol name="AppsFeature" filename="apps_feature.dart" path="lib/apps_feature.dart" startline="3" type="class"></mcsymbol> abstract class, which serves as a blueprint for all major application features (like Console, Network). It requires implementing methods for an identifier, icon, title, and the feature's main UI body. It also includes <mcsymbol name="AppsFeatureManager" filename="apps_feature.dart" path="lib/apps_feature.dart" startline="9" type="class"></mcsymbol>, a singleton responsible for registering and retrieving `AppsFeature` instances.
*   **`apps_home.dart`**: Implements the <mcsymbol name="AppsHome" filename="apps_home.dart" path="lib/apps_home.dart" startline="11" type="class"></mcsymbol> widget, which is the main screen of the application. It initializes and registers all available features (Console, Network, Preference) using `AppsFeatureManager`. It sets up the `AppsConnectorWS` for WebSocket communication and links it to `AppsConnectService`. The UI dynamically displays either a side menu bar (desktop) or a bottom navigation bar (mobile) for feature selection, and renders the body of the currently selected feature. It also includes the `AppsInfoBar` for desktop layouts.
*   **`main.dart`**: The entry point of the Flutter application. It initializes Flutter bindings, sets up desktop window options (size, centering) using the `window_manager` package, and runs the `MyApp` widget. `MyApp` is a `StatelessWidget` that defines the `MaterialApp`, setting the application title, theme (including primary color and Material 3 usage), and making `AppsHome` the home screen.