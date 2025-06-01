# Trae Rules for `services` Directory

## 1. Functionality

The `services` directory is responsible for managing the communication layer and data handling between the ConsoleBus application and connected client devices (SDKs). It orchestrates message reception, parsing, storage, and distribution to relevant parts of the application.

Key functionalities include:

*   **Connection Management**: Establishing and maintaining connections with client SDKs. The `AppsConnectorWS` specifically handles WebSocket connections.
*   **Message Handling**: Receiving raw messages from clients, parsing them using protocol definitions (from the `protocols` directory), and processing them.
*   **Data Aggregation and Storage**: Storing all received messages (e.g., console logs, network requests, device information) in a central place (`AppsConnectService`).
*   **State Notification**: Notifying other parts of the application (typically UI components or feature-specific controllers) about new data or changes in connection status or selected devices using the `ChangeNotifier` pattern.
*   **Device Management**: Tracking connected devices (`ProtoDevice`) and allowing selection of a specific device for focused data viewing.
*   **Data Filtering and Clearing**: Providing methods to clear specific types of logs (e.g., console, network) or remove data associated with a disconnected device.
*   **Data Import**: Supporting import of log data from local files.

## 2. Directory Structure

```
services/
├── apps_connect_service.dart  # Central service for managing all incoming messages, device list, and selected device state.
├── apps_connector.dart        # Abstract base class defining the interface for a connection mechanism.
├── apps_connector_ws.dart     # Concrete implementation of AppsConnector using WebSockets.
└── trae_rules.md              # This file.
```

## 3. Coding Standards

*   **Naming Conventions**:
    *   Service class names should end with `Service` (e.g., `AppsConnectService`).
    *   Connector class names should end with `Connector` (e.g., `AppsConnector`, `AppsConnectorWS`).
    *   Method names should be descriptive and use `camelCase`.
*   **Singleton Pattern**: `AppsConnectService` is implemented as a singleton (`AppsConnectService.shared`) to ensure a single source of truth for all application data originating from clients.
*   **Abstraction**: `AppsConnector` provides an abstraction for different communication methods, allowing `AppsConnectorWS` to be a specific implementation (e.g., for WebSockets). This promotes flexibility if other connection types are needed in the future.
*   **State Management**: `AppsConnectService` extends `ChangeNotifier` to broadcast updates to listeners (typically UI components or other services).
*   **Error Handling**: Basic error handling is present (e.g., `try-catch` during file import), but could be expanded for network operations or message parsing.
*   **Dependency Injection**: The `AppsConnector` instance is injected into `AppsConnectService` via the `setAppsConnector` method, promoting loose coupling.

## 4. Dependencies

### Internal Dependencies:

*   **`protocols/`**: Critically depends on all protocol definitions (`ProtoMessageBase`, `ProtoConsole`, `ProtoDevice`, `ProtoNetwork`, `ProtocolMessageFactory`) for parsing and identifying incoming messages.
*   **UI Components/Features**: Various features (console, network, preference) and UI components listen to `AppsConnectService` for data updates and to display information related to connected devices and their messages.

### External Dependencies:

*   **`flutter/material.dart`**: For `ChangeNotifier`.
*   **`dart:convert`**: For JSON decoding (`json.decode`).
*   **`dart:io`**: For file operations (`File` class in `importFromLogFile`).
*   **`shelf/shelf.dart`**, **`shelf/shelf_io.dart`**, **`shelf_web_socket/shelf_web_socket.dart`**: Used by `AppsConnectorWS` for setting up the WebSocket server.

## 5. State Management

*   **`AppsConnectService`**: This is the primary state holder in this directory.
    *   `allMessages`: A `List<ProtoMessageBase>` storing all messages received from all connected devices.
    *   `allDevices`: A `Set<ProtoDevice>` storing information about all currently or previously connected devices.
    *   `selectedDevice`: A `ProtoDevice?` indicating the currently active device whose data might be prioritized or exclusively shown in the UI.
    *   It uses `notifyListeners()` to inform dependent widgets/services about changes to these states.
*   **`AppsConnectorWS`**: Manages the state of the WebSocket connection (`webSocket` instance).
*   **Callbacks**: The `onReceiveMessage` callback in `AppsConnector` (and its implementations) is a key part of the data flow, linking the raw message reception to the processing logic in `AppsConnectService`.

## 6. Summary of Files

*   **`apps_connect_service.dart`**: Defines `AppsConnectService`, a `ChangeNotifier` that acts as the central hub for all data coming from connected devices. It stores all messages, manages a list of connected devices, handles device selection, provides methods to clear logs, and can import logs from a file. It uses `ProtocolMessageFactory` to parse incoming JSON messages into their respective `ProtoMessageBase` subtypes.
*   **`apps_connector.dart`**: Defines an abstract class `AppsConnector` which outlines the basic interface for a communication channel. It includes a callback `onReceiveMessage` for when a message is received and a `sendMessage` method placeholder.
*   **`apps_connector_ws.dart`**: Defines `AppsConnectorWS`, a concrete implementation of `AppsConnector` that uses WebSockets for communication. It sets up a WebSocket server using the `shelf` and `shelf_web_socket` packages, listens for incoming messages on the WebSocket, and forwards them via the `onReceiveMessage` callback. It also implements `sendMessage` to send data back through the WebSocket.