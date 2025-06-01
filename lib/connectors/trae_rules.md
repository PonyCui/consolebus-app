# Trae Rules for `connectors` Directory

## 1. Functionality

The `connectors` directory is intended to house modules responsible for establishing and managing communication links with external systems or client SDKs. These connectors would abstract the specifics of different communication protocols (e.g., WebSockets, HTTP, Bluetooth) and provide a consistent interface for the rest of the application to send and receive data.

**Note:** Based on the current project structure, it appears that the primary connector logic (e.g., `AppsConnector` abstract class and `AppsConnectorWS` WebSocket implementation) has been placed within the <mcfolder name="services" path="lib/services"></mcfolder> directory. This `connectors` directory might be a remnant of a previous structure, intended for future expansion with different types of connectors, or its role has been absorbed by the `services` directory.

If this directory were to be actively used, its key functionalities would include:

*   **Connection Establishment**: Handling the handshake and setup for various communication protocols.
*   **Data Transmission/Reception**: Managing the low-level details of sending and receiving data packets.
*   **Protocol Abstraction**: Providing a higher-level API that hides the complexities of the underlying communication mechanism.
*   **Error Handling and Resilience**: Managing connection errors, retries, and disconnections.

## 2. Directory Structure

Currently, this directory appears to be empty or underutilized, aside from this `trae_rules.md` file.

```
connectors/
└── trae_rules.md  # This file.
```

A typical structure, if populated, might look like:

```
connectors/
├── base_connector.dart       # Abstract base class for all connectors.
├── websocket_connector.dart  # Implementation for WebSocket communication.
├── http_connector.dart       # Implementation for HTTP-based communication (if applicable).
└── trae_rules.md             # This file.
```

## 3. Coding Standards

If this directory were actively developed, the following standards would apply:

*   **Naming Conventions**:
    *   Connector class names should end with `Connector` (e.g., `WebSocketConnector`).
    *   File names should use `snake_case`.
*   **Abstraction**: A base `Connector` class or interface should define a common contract for all specific connector implementations.
*   **Modularity**: Each communication protocol should have its own dedicated connector class.
*   **Configuration**: Connectors should be configurable (e.g., server address, port, credentials).
*   **Asynchronous Operations**: Communication is inherently asynchronous; thus, methods should utilize `Future`s and `Stream`s appropriately.

## 4. Dependencies

### Internal Dependencies:

*   **`services/`**: Services like `AppsConnectService` would likely use instances of these connectors to communicate with client devices.
*   **`protocols/`**: Connectors might need to be aware of basic message framing but would generally pass raw data to services for parsing with specific protocol definitions.

### External Dependencies:

*   Libraries specific to the communication protocol being implemented (e.g., `web_socket_channel` for WebSockets, `http` for HTTP).

## 5. State Management

*   Connectors would manage the state of their respective connections (e.g., connected, disconnected, connecting, error state).
*   They would typically expose this state via streams or callbacks to their consumers (e.g., `AppsConnectService`).
*   They are not responsible for managing application-level data state, but rather the state of the communication link itself.

## 6. Current Status and Recommendation

Given that <mcsymbol name="AppsConnector" path="lib/services/apps_connector.dart" filename="apps_connector.dart" type="class"></mcsymbol> and <mcsymbol name="AppsConnectorWS" path="lib/services/apps_connector_ws.dart" filename="apps_connector_ws.dart" type="class"></mcsymbol> reside in the <mcfolder name="services" path="lib/services"></mcfolder> directory, this `connectors` directory seems redundant for the current WebSocket implementation.

Consider either:
1.  **Removing** this directory if all connector logic is intended to remain within the `services` directory.
2.  **Refactoring** `AppsConnector` and its implementations into this `connectors` directory if a clearer separation between service logic and connection management is desired for future scalability with multiple connector types. This would align better with a layered architecture where `services` use `connectors`.

For now, this `trae_rules.md` documents its potential purpose.