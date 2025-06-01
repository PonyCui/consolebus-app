# Trae Rules for `utils` Directory

## 1. Functionality

The `utils` directory contains utility classes and functions that provide common, reusable logic across different parts of the application. These utilities are generally stateless and offer helper methods for various tasks.

Currently, it includes:

*   **Responsive Design Helpers**: Determining the application's display mode (e.g., mobile vs. desktop) based on screen width.

## 2. Directory Structure

```
utils/
├── apps_util.dart  # Contains utility functions, currently for responsive design.
└── trae_rules.md   # This file.
```

## 3. Coding Standards

*   **Naming Conventions**:
    *   Utility class names should end with `Util` (e.g., `AppsUtil`).
    *   Static methods are preferred for utility functions that do not require an instance of the class.
    *   Method names should be descriptive and use `camelCase`.
*   **Statelessness**: Utility functions should ideally be pure functions, meaning their output depends only on their input arguments, and they should not have side effects or rely on or modify external state.
*   **Granularity**: Utilities should be focused and provide specific, well-defined functionalities.
*   **Documentation**: Public utility methods should be well-documented to explain their purpose, parameters, and return values.

## 4. Dependencies

### Internal Dependencies:

*   Various UI components and layout widgets throughout the application might use `AppsUtil.isMobileMode` to adapt their presentation based on the screen size.

### External Dependencies:

*   **`flutter/material.dart`**: For accessing `BuildContext` and `MediaQuery` to get screen size information.

## 5. State Management

Utility classes and functions within the `utils` directory are generally stateless. They operate on the input provided to them and do not maintain or manage any internal state that persists across calls.

*   The `isMobileMode` function, for example, takes `BuildContext` as input and returns a boolean based on the current screen width derived from that context. It does not store any state itself.

## 6. Summary of Files

*   **`apps_util.dart`**: Defines the `AppsUtil` class, which currently contains a single static method `isMobileMode(BuildContext context)`. This method checks the screen width using `MediaQuery.of(context).size.width` and returns `true` if the width is less than 500 pixels, indicating a mobile-like layout should be used, and `false` otherwise.