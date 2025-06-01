# Network 功能模块 (`/lib/features/network`)

## 1. 功能与用途

`network` 功能模块主要用于监控和检查通过应用发出的网络请求。它允许用户查看详细的网络活动信息，包括请求和响应的元数据及内容。

核心功能包括：

*   **网络请求列表展示** (`NetworkList`)：
    *   以列表形式展示捕获到的网络请求。
    *   每项显示请求的 URI、方法 (GET, POST, etc.)、状态（Pending, Done, Error, Cancelled）和耗时。
    *   支持选中某个请求以在详情视图中查看更多信息。
    *   提供右键菜单（桌面端）或特定手势（移动端，当前实现为桌面端右键）复制请求 URI 或 CURL 命令。
*   **网络请求详情展示** (`NetworkDetail`)：
    *   当用户从列表中选择一个网络请求后，此组件会显示该请求的详细信息。
    *   使用标签页 (TabBar) 分别展示：
        *   **请求元数据**：URI, 方法, 请求头 (Headers)。
        *   **请求体**：支持纯文本、JSON（格式化高亮显示）、图片预览。
        *   **响应元数据**：状态码, 状态文本, 响应头 (Headers)。
        *   **响应体**：支持纯文本、JSON（格式化高亮显示）、图片预览。
    *   JSON 内容使用 `re_editor` 和 `re_highlight` 进行美化和语法高亮。
*   **过滤功能** (`NetworkFilter`):
    *   提供一个过滤栏，允许用户根据关键词筛选网络请求。
    *   通过 `NetworkFilterOptionsPanel` 选择过滤范围，可以针对请求 URI、请求体、响应体进行过滤。
    *   提供清空当前所有网络日志的功能。
*   **设备筛选**：
    *   如果 `AppsConnectService` 中选定了特定设备，则仅显示该设备的网络请求。
*   **响应式布局** (`NetworkHome`)：
    *   根据是否为移动设备 (`AppsUtil.isMobileMode`) 调整列表和详情视图的布局（例如，移动端上下分栏，桌面端左右分栏）。
*   **CURL 命令生成** (`NetworkExporter`)：
    *   能够根据选定的网络请求生成等效的 CURL 命令字符串。

该模块旨在帮助开发者调试网络问题，理解应用的具体网络行为。

## 2. 目录结构与文件说明

```
network/
|-- network_defines.dart              # 定义 NetworkFeature 类，实现 AppsFeature 接口，用于菜单栏集成
|-- network_detail.dart               # UI 组件，显示单个网络请求的详细信息（请求/响应元数据和内容）
|-- network_exporter.dart             # 包含生成 CURL 命令的静态方法
|-- network_filter.dart               # UI 组件，实现网络请求的过滤栏和过滤逻辑控制器
|-- network_filter_options_panel.dart # UI 组件，实现选择过滤范围的弹出面板
|-- network_home.dart                 # Network 功能模块的主页面，整合了 Filter, List 和 Detail 组件
|-- network_list.dart                 # UI 组件，以列表形式展示所有捕获的网络请求
`-- trae_rules.md                     # (本文档) 模块规则说明
```

*   `network_defines.dart`: (`NetworkFeature` class) 实现 `AppsFeature` 接口，定义此功能模块在主菜单中的标识符、标题和图标。
*   `network_detail.dart`: (`NetworkDetail` StatefulWidget) 包含多个子 Widget（如 `_RequestMetadataTab`, `_RequestBodyTab`, `_ResponseMetadataTab`, `_ResponseBodyTab`）来展示网络请求的各个方面。使用 `TabController` 管理标签页。请求体和响应体部分支持根据 `Content-Type` 自动选择或手动切换视图（纯文本、JSON、图片）。
*   `network_exporter.dart`: (`NetworkExporter` class) 提供静态方法 `generateCurlCommand`。
*   `network_filter.dart`: (`NetworkFilter` StatefulWidget 和 `NetworkFilterController` ChangeNotifier) 提供关键词输入框和过滤选项按钮。`NetworkFilterController` 管理过滤状态（关键词、过滤范围）。
*   `network_filter_options_panel.dart`: (`NetworkFilterOptionsPanel` StatefulWidget) 弹出式面板，允许用户勾选/取消勾选过滤范围（请求 URI、请求体、响应体）。
*   `network_home.dart`: (`NetworkHome` StatefulWidget) 作为网络功能的根 Widget，组织 `NetworkFilter`, `NetworkList`, 和 `NetworkDetail`。管理当前选中的网络请求状态，并根据平台调整布局。
*   `network_list.dart`: (`NetworkList` StatelessWidget) 接收网络请求列表并展示。处理列表项的选择和右键上下文菜单。

## 3. 编码规范

*   **命名规范**：遵循 Dart 和 Flutter 的标准命名约定。
*   **状态管理**：
    *   网络请求数据源自 `AppsConnectService` (全局服务)。
    *   过滤条件由 `NetworkFilterController` (ChangeNotifier) 管理。
    *   当前选中的网络请求状态由 `NetworkHome` 的 `State` 管理。
    *   UI 组件内部状态通过 `StatefulWidget` 和 `setState` 管理。
*   **组件化**：功能被清晰地划分为独立的 Widget。
*   **响应式设计**：使用 `AppsUtil.isMobileMode(context)` 判断平台并调整 UI。
*   **依赖注入/服务定位**：通过 `AppsConnectService.shared` 访问全局服务。

## 4. 引用关系

### 内部引用：

*   `network_home.dart` 引用了：
    *   `./network_detail.dart`
    *   `./network_list.dart`
    *   `./network_filter.dart`
    *   `./network_exporter.dart` (间接通过 `NetworkList`)
*   `network_list.dart` 引用了：
    *   `./network_exporter.dart`
*   `network_filter.dart` 引用了：
    *   `./network_filter_options_panel.dart`
*   `network_defines.dart` 引用了：
    *   `./network_home.dart`

### 外部引用（项目内其他模块）：

*   `network_defines.dart`:
    *   `package:consoleapp/apps_feature.dart` (实现 `AppsFeature`)
*   `network_detail.dart`:
    *   `package:consoleapp/protocols/protocol_network.dart` (使用 `ProtoNetwork` 模型)
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)
*   `network_exporter.dart`:
    *   `package:consoleapp/protocols/protocol_network.dart` (使用 `ProtoNetwork`)
*   `network_filter.dart`:
    *   `package:consoleapp/services/apps_connect_service.dart` (清空网络日志)
*   `network_filter_options_panel.dart`:
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)
    *   `./network_filter.dart` (使用 `NetworkFilterController`)
*   `network_home.dart`:
    *   `package:consoleapp/protocols/protocol_network.dart` (使用 `ProtoNetwork`)
    *   `package:consoleapp/services/apps_connect_service.dart` (获取网络日志、监听设备选择)
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)
*   `network_list.dart`:
    *   `package:consoleapp/protocols/protocol_network.dart` (使用 `ProtoNetwork`)

### 外部引用（第三方库）：

*   `network_detail.dart`:
    *   `package:flutter/material.dart`
    *   `dart:convert` (用于 JSON 解析和 Base64 解码)
    *   `package:re_editor/re_editor.dart` (用于代码编辑器展示 JSON)
    *   `package:re_highlight/languages/json.dart` (JSON 语法高亮)
    *   `package:re_highlight/styles/atom-one-light.dart` (代码编辑器主题)
*   `network_defines.dart`, `network_filter.dart`, `network_filter_options_panel.dart`, `network_home.dart`, `network_list.dart`:
    *   `package:flutter/material.dart`
*   `network_list.dart`:
    *   `package:flutter/services.dart` (用于剪贴板操作 `Clipboard`)

## 5. 状态管理总结

*   **网络日志数据**：由全局的 `AppsConnectService` 管理和提供。`NetworkHome` 监听此服务以获取最新的网络请求列表和选定设备信息。
*   **过滤状态**：由 `NetworkFilterController` (一个 `ChangeNotifier`) 维护，包括关键词文本和过滤范围（URI、请求体、响应体）。`NetworkFilter` UI 组件修改此 Controller 的状态，而 `NetworkHome` (间接通过 `filteredNetworks` 逻辑) 和 `NetworkFilter` 的部分 UI 监听此 Controller 的变化。
*   **选中项状态**：`NetworkHome` 的 `State` (`_NetworkHomeState`) 中的 `selectedNetwork` 变量负责管理当前在列表中选中的网络请求。
*   **UI 内部状态**：各个 StatefulWidget (`NetworkDetail`, `NetworkFilter`, `NetworkFilterOptionsPanel`, `NetworkHome`, `_RequestBodyTabState`, `_ResponseBodyTabState`) 可能有自己的局部 UI 状态，通过 `setState` 管理（例如，`NetworkDetail` 中的 `TabController`，`_RequestBodyTabState` 中的 `_viewType`）。

这种分层状态管理确保了数据流的清晰和组件间的解耦。