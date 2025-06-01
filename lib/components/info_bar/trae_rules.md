# Info Bar 组件 (`/lib/components/info_bar`)

## 1. 功能与用途

`info_bar` 组件主要用于在应用界面底部显示一个信息栏。这个信息栏包含以下核心功能：

*   **设备列表展示与管理**：
    *   显示当前连接的设备数量或选定设备的名称。
    *   提供一个可点击的区域，用于弹出设备列表对话框。
    *   在对话框中，用户可以查看所有已连接设备的列表。
    *   用户可以从列表中选择一个特定设备以进行数据筛选。
    *   用户可以从列表中移除（断开）一个设备。
*   **日志文件导入**：
    *   提供一个“导入日志文件”按钮。
    *   点击按钮后，允许用户选择本地的 `.cblog` 格式的日志文件进行导入。

该组件的目的是为用户提供一个便捷的方式来查看和管理连接的设备，并导入外部日志数据进行分析。

## 2. 目录结构与文件说明

```
info_bar/
|-- device_list.dart     # UI 组件，负责显示设备列表和处理设备选择/移除逻辑
|-- import_button.dart   # UI 组件，负责提供导入日志文件的按钮和处理文件选择逻辑
|-- info_bar.dart        # 主 UI 组件，整合 device_list.dart 和 import_button.dart，构成完整的信息栏
`-- trae_rules.md        # (本文档) 组件规则说明
```

*   `device_list.dart`: 实现了一个 `DeviceList` StatelessWidget，用于展示设备信息。当用户点击时，会弹出一个 `AlertDialog`，列出所有通过 `AppsConnectService` 获取的设备。用户可以在此选择或移除设备。
*   `import_button.dart`: 实现了一个 `ImportButton` StatelessWidget，提供一个 `MaterialButton`。点击后，使用 `file_picker` 插件让用户选择 `.cblog` 文件，并通过 `AppsConnectService` 进行导入。
*   `info_bar.dart`: 实现了一个 `AppsInfoBar` StatefulWidget，作为信息栏的容器。它监听 `AppsConnectService` 中设备列表的变化，并相应地更新 `DeviceList` 的显示。它将 `DeviceList` 和 `ImportButton` 左右排列显示。

## 3. 编码规范

*   **命名规范**：
    *   类名使用大驼峰命名法 (e.g., `DeviceList`, `AppsInfoBar`)。
    *   文件名使用蛇形命名法 (e.g., `device_list.dart`)。
    *   变量和方法名使用小驼峰命名法 (e.g., `selectedDevice`, `onTap`).
*   **代码风格**：
    *   遵循 Flutter 和 Dart 的官方编码风格指南。
    *   使用 `const` 关键字优化性能，特别是在 Widget 构造函数中。
    *   UI 组件应尽可能为 `StatelessWidget`，除非需要管理内部状态，则使用 `StatefulWidget`。
*   **依赖管理**：
    *   明确导入所需的包，避免不必要的导入。
    *   状态管理主要通过 `AppsConnectService` 进行，组件通过监听该服务的变化来更新 UI。

## 4. 引用关系

### 内部引用：

*   `info_bar.dart` 引用了：
    *   `./device_list.dart` (用于显示设备列表)
    *   `./import_button.dart` (用于显示导入按钮)

### 外部引用（项目内其他模块）：

*   `device_list.dart` 引用了：
    *   `package:consoleapp/protocols/protocol_device.dart` (使用了 `ProtoDevice` 数据模型)
    *   `package:consoleapp/services/apps_connect_service.dart` (用于获取设备列表、选择设备、移除设备)
*   `import_button.dart` 引用了：
    *   `package:consoleapp/services/apps_connect_service.dart` (用于导入日志文件)
*   `info_bar.dart` 引用了：
    *   `package:consoleapp/services/apps_connect_service.dart` (用于监听设备变化、获取设备列表和当前选定设备)

### 外部引用（第三方库）：

*   `device_list.dart` 引用了：
    *   `package:flutter/material.dart`
*   `import_button.dart` 引用了：
    *   `package:flutter/material.dart`
    *   `package:file_picker/file_picker.dart` (用于文件选择功能)
*   `info_bar.dart` 引用了：
    *   `package:flutter/material.dart`

## 5. 状态管理

`info_bar` 组件本身不直接管理复杂的应用状态。它依赖于 `AppsConnectService` 来获取和更新设备信息以及处理日志导入的逻辑。

*   `_AppsInfoBarState` (在 `info_bar.dart` 中) 监听 `AppsConnectService.shared` 的变化。当设备列表或选定设备发生改变时，`AppsConnectService` 会通知监听器，`_AppsInfoBarState` 则调用 `setState(() {})` 来触发 UI 重建，从而更新 `DeviceList` 的显示。
*   设备的选择和移除操作通过调用 `AppsConnectService.shared` 的相应方法来完成，状态的变更由 `AppsConnectService` 内部处理并通知所有监听者。
*   日志文件的导入也通过调用 `AppsConnectService.shared.importFromLogFile()` 方法完成。