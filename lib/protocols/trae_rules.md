# Trae Rules for `protocols` Directory

## 1. Functionality

The `protocols` directory defines the data structures used for communication between the client application (iOS/Android SDK) and the ConsoleBus desktop application. These data structures, or protocols, ensure that data is consistently formatted and understood by both ends of the communication channel. Each file in this directory typically defines a specific type of data object that corresponds to a feature in the application (e.g., console logs, network requests, device information, preferences).

Key functionalities include:

*   **Data Serialization/Deserialization**: Defines how data is structured for transmission (e.g., as JSON) and how it is parsed back into usable objects.
*   **Type Safety**: Provides clear definitions for data fields, ensuring that data integrity is maintained during communication.
*   **Extensibility**: Allows for new protocol types to be added as new features are developed.
*   **Message Routing**: Includes identifiers (like `featureId`) that help in routing messages to the correct feature module within the ConsoleBus application.

## 2. Directory Structure

The `protocols` directory contains Dart files, each defining a specific protocol class. A central `protocol_defines.dart` file often includes base classes or factories for managing these protocols.

```
protocols/
├── protocol_console.dart       # Defines the data structure for console log messages.
├── protocol_defines.dart       # Defines base classes (e.g., ProtoMessageBase) and factories (e.g., ProtocolMessageFactory) for all protocols.
├── protocol_device.dart        # Defines the data structure for device information.
├── protocol_network.dart       # Defines the data structure for network request/response details.
├── protocol_preference.dart    # Defines the data structure for shared preference data.
└── trae_rules.md               # This file.
```

## 3. Coding Standards

*   **Naming Conventions**:
    *   Protocol class names should be prefixed with `Proto` (e.g., `ProtoConsole`, `ProtoNetwork`).
    *   File names should correspond to the primary protocol class they define (e.g., `protocol_console.dart` for `ProtoConsole`).
    *   Field names within protocol classes should use `camelCase`.
*   **Immutability**: Protocol objects should generally be immutable once created, promoting predictable state management. If modifications are needed, new instances should be created.
*   **Serialization Methods**: Each protocol class should provide methods for converting to and from a common serialization format (e.g., `toJson()`, `fromJson()`).
*   **Clarity and Simplicity**: Protocol definitions should be straightforward and easy to understand, focusing solely on data representation.

## 4. Dependencies

### Internal Dependencies:

*   The protocol classes are used extensively by various feature modules (`console`, `network`, `preference`, etc.) to interpret incoming data from connected devices.
*   The `AppsConnectService` likely uses these protocol definitions to parse messages received from the SDKs.
*   The `ProtocolMessageFactory` in `protocol_defines.dart` is crucial for dynamically creating the correct protocol object based on the `featureId` in a message.

### External Dependencies:

*   Typically, no direct external library dependencies are required for simple data-holding classes. However, if complex serialization/deserialization logic is needed, libraries like `json_serializable` might be used (though not explicitly seen in the provided snippets).

## 5. State Management

Protocol classes themselves are data structures and do not manage state. They are the *content* of the state managed by other services or controllers.

*   **Data Source**: Instances of these protocol classes originate from the connected client SDKs and are received by the `AppsConnectService`.
*   **Data Consumers**: Feature-specific services and UI components consume these protocol objects to display information or perform actions.
*   **Transformation**: Data from protocol objects might be transformed or mapped to different view models or state objects within specific features before being displayed in the UI.

## 6. Summary of Files

*   **`protocol_console.dart`**: Defines `ProtoConsole` for console log messages, including fields like `logTag`, `logContent`, `logContentType`, and `logLevel`.
*   **`protocol_defines.dart`**: Defines `ProtoMessageBase` as a base class for all protocol messages (containing common fields like `deviceId`, `msgId`, `featureId`, `createdAt`). It also includes `ProtocolMessageFactory`, which is responsible for creating specific protocol message instances (e.g., `ProtoConsole`, `ProtoNetwork`) from a generic JSON map based on the `featureId`.
*   **`protocol_device.dart`**: Defines `ProtoDevice` for transmitting device-specific information, such as `deviceName` and `deviceType`.
*   **`protocol_network.dart`**: Defines `ProtoNetwork` for capturing detailed information about network requests and responses. This includes fields for URI, headers, method, body, status code, and timing information for both request and response.
*   **`protocol_preference.dart`**: Defines `ProtoPreference` for managing shared preference data. It includes fields for the preference `key`, `value`, the `operation` being performed (e.g., set, get, sync), and the data `type` (e.g., string, number, boolean, map, list).