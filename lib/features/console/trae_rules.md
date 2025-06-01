# Console 功能模块 (`/lib/features/console`)

## 1. 功能与用途

`console` 功能模块是应用的核心功能之一，主要用于展示、过滤和管理来自连接设备的日志信息。其核心功能包括：

*   **日志展示**：
    *   实时显示通过 `AppsConnectService` 接收到的控制台日志 (`ProtoConsole` 类型)。
    *   每条日志包含时间戳、日志级别、可选的标签 (tag) 和日志内容。
    *   支持不同日志级别（Debug, Info, Warn, Error）的颜色高亮显示。
    *   支持图片类型日志的预览（点击查看大图）。
    *   支持长按或在桌面端通过特定手势复制文本日志内容到剪贴板。
*   **日志过滤**：
    *   提供一个过滤栏 (`ConsoleFilter`)，允许用户根据关键词和日志级别进行筛选。
    *   关键词过滤：实时根据输入文本过滤日志内容。
    *   日志级别过滤：通过一个弹出面板 (`ConsoleFilterLogLevelPanel`) 选择要显示的日志级别 (Debug, Info, Warn, Error)。
*   **日志管理**：
    *   清空当前显示的日志。
    *   导出当前经过滤的日志到文本文件 (`.txt`)。
*   **设备筛选**：
    *   如果 `AppsConnectService` 中选定了特定设备，则仅显示该设备的日志。
*   **响应式布局**：
    *   日志列表和过滤栏会根据是否为移动设备 (`AppsUtil.isMobileMode`) 调整布局。

该模块的目的是为开发者提供一个强大的工具来监控和调试连接设备产生的日志信息。

## 2. 目录结构与文件说明

```
console/
|-- console_content.dart                 # UI 组件，负责渲染和展示过滤后的日志列表
|-- console_defines.dart                 # 定义 ConsoleFeature 类，实现 AppsFeature 接口，用于菜单栏集成
|-- console_exporter.dart                # 包含导出日志到文件的静态方法
|-- console_filter.dart                  # UI 组件，实现日志过滤栏（关键词、级别、导出、清空）
|-- console_filter_log_level_panel.dart  # UI 组件，实现选择日志级别的弹出面板
|-- console_home.dart                    # Console 功能模块的主页面，整合了 Filter 和 Content 组件
`-- trae_rules.md                        # (本文档) 模块规则说明
```

*   `console_content.dart`: (`ConsoleContent` StatefulWidget) 监听 `AppsConnectService` 和 `ConsoleFilterController` 的变化，动态展示符合过滤条件的日志。实现了日志项的渲染、图片预览、内容复制等交互。
*   `console_defines.dart`: (`ConsoleFeature` class) 实现了 `AppsFeature` 接口，定义了此功能模块在主菜单中的标识符、标题和图标。
*   `console_exporter.dart`: (`ConsoleExporter` class) 提供静态方法 `exportWithFilter`，用于将当前筛选后的日志导出为文本文件。
*   `console_filter.dart`: (`ConsoleFilter` StatefulWidget 和 `ConsoleFilterController` ChangeNotifier) 提供了关键词输入框、日志级别选择按钮、导出按钮和清空按钮。`ConsoleFilterController` 用于管理过滤状态并在状态变化时通知监听者。
*   `console_filter_log_level_panel.dart`: (`ConsoleFilterLogLevelPanel` StatefulWidget) 当用户点击日志级别选择按钮时，以对话框或特定定位方式显示，允许用户勾选/取消勾选不同的日志级别。
*   `console_home.dart`: (`ConsoleHome` StatefulWidget) 作为控制台功能的根 Widget，将 `ConsoleFilter` 和 `ConsoleContent` 组织在一起。它实例化并持有一个静态的 `ConsoleFilterController`。

## 3. 编码规范

*   **命名规范**：遵循 Dart 和 Flutter 的标准命名约定（类名大驼峰，文件名蛇形，变量/方法小驼峰）。
*   **状态管理**：
    *   日志数据源自 `AppsConnectService` (全局服务)。
    *   日志过滤条件由 `ConsoleFilterController` (ChangeNotifier) 管理，UI 组件通过监听此 Controller 更新。
    *   UI 组件 (`ConsoleContent`, `ConsoleFilter`, `ConsoleFilterLogLevelPanel`) 自身的状态通过 `StatefulWidget` 和 `setState` 管理。
*   **组件化**：功能被拆分为独立的、可复用的 Widget。
*   **响应式设计**：使用 `AppsUtil.isMobileMode(context)` 判断平台，并据此调整 UI 布局。
*   **依赖注入/服务定位**：通过 `AppsConnectService.shared` 访问全局服务，`ConsoleFilterController` 在 `ConsoleHome` 中静态实例化并传递给子组件。

## 4. 引用关系

### 内部引用：

*   `console_home.dart` 引用了：
    *   `./console_content.dart`
    *   `./console_filter.dart`
*   `console_filter.dart` 引用了：
    *   `./console_exporter.dart`
    *   `./console_filter_log_level_panel.dart`
*   `console_content.dart` 引用了：
    *   `./console_filter.dart` (仅类型 `ConsoleFilterController`)
*   `console_defines.dart` 引用了：
    *   `./console_home.dart`

### 外部引用（项目内其他模块）：

*   `console_content.dart`:
    *   `package:consoleapp/protocols/protocol_console.dart` (使用 `ProtoConsole` 数据模型)
    *   `package:consoleapp/services/apps_connect_service.dart` (获取日志、监听设备选择)
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)
*   `console_defines.dart`:
    *   `package:consoleapp/apps_feature.dart` (实现 `AppsFeature` 接口)
*   `console_exporter.dart`:
    *   `package:consoleapp/features/console/console_filter.dart` (使用 `ConsoleFilterController`)
    *   `package:consoleapp/protocols/protocol_console.dart` (使用 `ProtoConsole`)
    *   `package:consoleapp/services/apps_connect_service.dart` (获取日志)
*   `console_filter.dart`:
    *   `package:consoleapp/services/apps_connect_service.dart` (清空日志)
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)
*   `console_filter_log_level_panel.dart`:
    *   `package:consoleapp/features/console/console_filter.dart` (使用 `ConsoleFilterController`)
    *   `package:consoleapp/utils/apps_util.dart` (判断移动模式)

### 外部引用（第三方库）：

*   `console_content.dart`:
    *   `package:flutter/material.dart`
    *   `package:flutter/services.dart` (用于剪贴板操作 `Clipboard`)
    *   `package:intl/intl.dart` (用于日期格式化 `DateFormat`)
    *   `dart:convert` (用于 Base64 解码图片)
*   `console_defines.dart`:
    *   `package:flutter/material.dart`
*   `console_exporter.dart`:
    *   `package:file_saver/file_saver.dart` (用于保存文件)
    *   `package:intl/intl.dart` (用于日期格式化)
    *   `dart:convert` (用于 UTF-8 编码)
*   `console_filter.dart`:
    *   `package:flutter/material.dart`
*   `console_filter_log_level_panel.dart`:
    *   `package:flutter/material.dart`
*   `console_home.dart`:
    *   `package:flutter/material.dart`

## 5. 状态管理总结

*   **日志数据**：由全局的 `AppsConnectService` 管理和提供。`ConsoleContent` 监听此服务以获取最新的日志列表和选定设备信息。
*   **过滤状态**：由 `ConsoleFilterController` (一个 `ChangeNotifier`) 维护，包括关键词文本和各日志级别的启用状态。`ConsoleFilter` UI 组件修改此 Controller 的状态，而 `ConsoleContent` 和 `ConsoleFilter` 的部分 UI 监听此 Controller 的变化以更新自身显示。
*   **UI 内部状态**：各个 StatefulWidget (`ConsoleContent`, `ConsoleFilter`, `ConsoleFilterLogLevelPanel`, `ConsoleHome`) 可能有自己的局部 UI 状态，通过 `setState` 管理（例如，滚动位置、文本框内容同步等）。
*   **导航/功能选择**：`ConsoleFeature` 在 `console_defines.dart` 中定义，其集成到应用整体导航的逻辑由外部（如 `AppsMenuBar` 和 `AppsHome`）处理。

这种分层状态管理方式，将全局应用状态（日志数据）、特性级别状态（过滤条件）和局部 UI 状态分离开，有助于代码的组织和维护。