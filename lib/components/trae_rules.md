# Trae Rules for `components` Directory

## 1. Functionality

The `components` directory serves as a container for reusable UI widgets and components that are shared across different features or parts of the ConsoleBus application. These components are designed to be generic and configurable to fit various contexts.

This directory itself might not contain direct widget implementations but rather organizes subdirectories, each dedicated to a specific complex component or a group of related smaller components.

Key functionalities of components within this directory (or its subdirectories) typically include:

*   **Encapsulation of UI Logic**: Bundling specific UI elements and their behaviors into self-contained units.
*   **Reusability**: Allowing a single component to be used in multiple places, reducing code duplication.
*   **Consistency**: Ensuring a consistent look and feel across the application by using standardized components.
*   **Modularity**: Breaking down complex UIs into smaller, manageable, and testable pieces.

## 2. Directory Structure

The `components` directory organizes its contents into subdirectories, each representing a distinct UI component or a set of related components.

```
components/
├── info_bar/               # Contains components related to the information bar (e.g., device list, import button).
│   ├── device_list.dart
│   ├── import_button.dart
│   ├── info_bar.dart
│   └── trae_rules.md
├── menu_bar/               # Contains components related to the main menu or navigation bar.
│   ├── menu_bar.dart
│   └── trae_rules.md
└── trae_rules.md           # This file, describing the overall components directory.
```

## 3. Coding Standards

*   **Naming Conventions**:
    *   Component widget class names should be descriptive and use `PascalCase` (e.g., `DeviceList`, `MenuBar`).
    *   File names should use `snake_case` and generally match the primary widget they define (e.g., `device_list.dart`).
*   **Stateless vs. Stateful**: Components should be `StatelessWidget` if they don't manage internal state that changes over time. Use `StatefulWidget` only when necessary for managing local UI state.
*   **Props/Parameters**: Components should accept data and callbacks via constructor parameters to remain configurable and reusable.
*   **Modularity**: Break down complex components into smaller, simpler sub-components.
*   **Documentation**: Publicly exposed components and their parameters should be well-documented.
*   **Styling**: Consistent styling should be applied, potentially using themes or shared style constants.

## 4. Dependencies

### Internal Dependencies:

*   **`features/`**: Various feature modules will import and use these shared components to build their UIs.
*   **`services/`**: Components might interact with services (like `AppsConnectService`) to get data or trigger actions, often through providers or direct service calls if appropriate for the component's scope.
*   **`utils/`**: May use utility functions (e.g., `AppsUtil.isMobileMode`) for responsive behavior.
*   **`protocols/`**: Components displaying data might indirectly depend on protocol objects if they receive them as props.

### External Dependencies:

*   **`flutter/material.dart`** or **`flutter/cupertino.dart`**: For core Flutter widgets and UI building blocks.
*   Potentially other UI utility libraries (e.g., for icons, specific UI patterns) as needed.

## 5. State Management

*   **Local UI State**: Individual components might manage their own local UI state using `StatefulWidget` and `setState` (e.g., dropdown open/closed, animation states).
*   **Shared Application State**: For state that needs to be shared across multiple components or features, components will typically receive data via constructor parameters or access it through state management solutions like Provider, Riverpod, BLoC, or by listening to `ChangeNotifier` services (e.g., `AppsConnectService`).
*   Components should not directly modify global application state unless it's part of their defined responsibility and handled through appropriate service calls or callbacks.

## 6. Summary of Sub-directories

*   **`info_bar/`**: Contains components that make up the application's information bar. This typically includes elements for displaying connected device information, allowing device selection, and providing actions like importing log files. See <mcfolder name="info_bar" path="lib/components/info_bar"></mcfolder> and its `trae_rules.md` for more details.
*   **`menu_bar/`**: Contains components related to the application's main menu or navigation bar, facilitating navigation between different features or sections of the app. See <mcfolder name="menu_bar" path="lib/components/menu_bar"></mcfolder> and its `trae_rules.md` for more details.