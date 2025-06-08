# Filesystem 功能模块 (`/lib/features/filesystem`)

## 1. 功能与用途

`filesystem` 功能模块主要用于浏览和管理连接设备上的文件系统。它允许用户查看目录内容、读取文件、写入文件、删除文件/目录以及下载文件。

核心功能包括：

*   **文件/目录列表展示** (`FilesystemHome`):
    *   以列表形式展示当前路径下的文件和目录。
    *   区分文件和目录的显示样式（例如，通过图标）。
    *   支持导航到子目录和返回上一级目录。
    *   列表会根据从设备获取的 `ProtoFilesystem` 消息（`operation == "list"`）动态更新。
*   **文件操作** (`FilesystemHome`, `FilesystemListItem`):
    *   **读取文件**: 允许用户选择一个文件并查看其内容（可能在 `FilesystemDetail` 或一个对话框中显示）。
    *   **更新文件**: 允许用户修改文件内容并保存回设备。
    *   **删除文件/目录**: 提供删除操作，并向设备发送删除请求。
    *   **下载文件**: 允许用户将设备上的文件下载到运行 ConsoleApp 的主机上。
    *   **(可选) 上传文件**: 允许用户从主机上传文件到设备指定路径。
    *   **(可选) 创建目录**: 允许用户在设备上创建新目录。
*   **路径导航** (`FilesystemHome`):
    *   显示当前路径。
    *   允许用户直接输入路径进行跳转（可选）。
*   **设备筛选** (`FilesystemHome`):
    *   如果 `AppsConnectService` 中选定了特定设备，则仅与该设备的文件系统交互。

该模块旨在为开发者提供一个直观的界面来检查和操作目标设备上的文件。

## 2. 目录结构与文件说明

```
filesystem/
|-- filesystem_defines.dart  # 定义 FilesystemFeature 类，实现 AppsFeature 接口
|-- filesystem_home.dart     # Filesystem 功能模块的主页面，负责展示文件列表和处理用户交互
|-- filesystem_list_item.dart # (可选) 单个文件/目录列表项的 Widget
|-- filesystem_detail.dart   # (可选) 用于显示文件内容或进行编辑的 Widget
|-- trae_rules.md            # (本文档) 模块规则说明
```

*   `filesystem_defines.dart`: (`FilesystemFeature` class) 实现 `AppsFeature` 接口，定义此功能模块在主菜单中的标识符、标题和图标。
*   `filesystem_home.dart`: (`FilesystemHome` StatefulWidget) 作为文件系统功能的核心 UI，展示文件和目录列表，处理导航和文件操作请求。它将监听 `AppsConnectService` 以接收文件系统相关的消息。
*   `filesystem_list_item.dart`: (`FilesystemListItem` StatelessWidget/StatefulWidget) (如果列表项复杂) 用于渲染列表中的每个文件或目录条目，可能包含操作按钮（如删除、下载）。
*   `filesystem_detail.dart`: (`FilesystemDetail` StatefulWidget) (如果需要) 用于展示大文件内容或提供文本编辑界面。

## 3. 编码规范

*   **命名规范**：遵循 Dart 和 Flutter 的标准命名约定。
*   **状态管理**：
    *   文件系统数据源自 `AppsConnectService` (全局服务)，通过 `ProtoFilesystem` 消息传递。
    *   当前路径、文件列表等状态由 `FilesystemHome` 的 `State` 管理。
    *   UI 组件内部状态（如编辑状态）通过 `StatefulWidget` 和 `setState` 管理。
*   **数据模型**：使用 `ProtoFilesystem` (在 `protocols/protocol_filesystem.dart` 中定义) 作为与设备通信的数据结构。
*   **组件化**：功能被划分为独立的 Widget。
*   **错误处理**: 对文件操作（读、写、删等）的结果进行处理，向用户显示成功或失败信息。

## 4. 引用关系

### 内部引用：

*   `filesystem_defines.dart` 引用了：
    *   `./filesystem_home.dart`
*   `filesystem_home.dart` 可能引用：
    *   `./filesystem_list_item.dart`
    *   `./filesystem_detail.dart`

### 外部引用（项目内其他模块）：

*   `filesystem_defines.dart`:
    *   `package:consoleapp/apps_feature.dart` (实现 `AppsFeature`)
*   `filesystem_home.dart` (及其他相关 UI 文件):
    *   `package:consoleapp/protocols/protocol_filesystem.dart` (使用 `ProtoFilesystem` 模型)
    *   `package:consoleapp/services/apps_connect_service.dart` (发送文件操作请求、接收数据)
    *   `package:consoleapp/protocols/protocol_defines.dart` (使用 `ProtoMessageBase`)

### 外部引用（第三方库）：

*   `package:flutter/material.dart` (所有 UI 文件)
*   `dart:convert` (用于 JSON 编解码)
*   (可能) `package:file_picker/file_picker.dart` (用于实现文件上传/下载到主机的对话框)
*   (可能) `package:path_provider/path_provider.dart` (用于获取主机下载路径)

## 5. 状态管理总结

*   **文件系统数据**：主要由 `FilesystemHome` 管理。它会向 `AppsConnectService` 发送请求（例如列出目录 `ProtoFilesystem(operation: "list", path: "/some/path")`），并监听来自服务端的响应消息来更新其显示的文件/目录列表。
*   **当前路径状态**：`FilesystemHome` 的 `State` (`_FilesystemHomeState`) 中的 `currentPath` 变量负责管理当前浏览的设备路径。
*   **选中项状态**：如果需要对选中项进行特定操作，相关状态也会在 `_FilesystemHomeState` 中管理。
*   **操作状态**：文件读/写/删等操作的进行状态（如 `isLoading`）由 `_FilesystemHomeState` 管理，以向用户提供反馈。

此模块通过 `AppsConnectService` 与设备通信，结合局部状态管理，实现设备文件系统的浏览和操作功能。