# Preference 功能模块 (`/lib/features/preference`)

## 1. 功能与用途

`preference` 功能模块主要用于查看和管理连接设备的偏好设置（键值对存储）。它允许用户浏览、筛选、以及修改设备上的偏好设置项。

核心功能包括：

*   **偏好设置列表展示** (`PreferenceHome`):
    *   以列表形式展示从设备获取的偏好设置项。
    *   每项显示偏好设置的键 (key) 和值 (value) 的摘要。
    *   支持选中某个偏好设置项以在详情视图中查看和编辑。
    *   列表会根据 `AppsConnectService` 中的设备消息 (`ProtoPreference` 类型且 `operation == "get"`) 动态更新。
    *   对相同设备、相同key的配置项，仅显示最新的一条。
    *   列表项按键名排序。
*   **偏好设置详情与编辑** (`PreferenceDetail`):
    *   当用户从列表中选择一个偏好设置项后，此组件会显示该项的详细信息：键、类型和完整的值。
    *   对于值部分，如果类型是 `json`, `list`, 或 `map`，会尝试进行格式化显示 (JSON pretty print)。
    *   提供“编辑”功能，允许用户修改偏好设置的值。编辑时，值会显示在一个文本框中。
    *   确认修改后，会构造一个 `ProtoPreference` 消息（`operation: 'set'`）并通过 `AppsConnectService` 发送给设备。
    *   在提交修改期间，会显示一个加载指示器。
*   **过滤功能** (`PreferenceFilter`):
    *   提供一个过滤栏，允许用户根据关键词筛选偏好设置项。
    *   过滤可以针对键 (key) 和/或值 (value) 进行（当前实现中，过滤选项UI未提供，但 `PreferenceFilterController` 的 `shouldDisplay` 逻辑支持按键和值过滤，默认都为 true）。
*   **数据同步** (`PreferenceFilter`):
    *   提供一个“同步”按钮，点击后会向所有已连接的设备发送一个 `ProtoPreference` 消息（`operation: 'sync'`），请求设备回传其所有偏好设置数据。
*   **设备筛选** (`PreferenceHome`):
    *   如果 `AppsConnectService` 中选定了特定设备，则仅显示该设备的偏好设置项。
*   **响应式布局** (`PreferenceHome`):
    *   根据屏幕宽度（是否为移动设备）调整列表和详情视图的布局（移动端上下分栏，桌面端左右分栏）。

该模块旨在为开发者提供一个界面来检查和动态调整目标设备上的持久化配置。

## 2. 目录结构与文件说明

```
preference/
|-- preference_defines.dart  # 定义 PreferenceFeature 类，实现 AppsFeature 接口，用于菜单栏集成
|-- preference_detail.dart   # UI 组件，显示单个偏好设置项的详细信息及提供编辑功能
|-- preference_filter.dart   # UI 组件，实现偏好设置的过滤栏和同步按钮
|-- preference_home.dart     # Preference 功能模块的主页面，整合了 Filter, List 和 Detail 组件
`-- trae_rules.md            # (本文档) 模块规则说明
```

*   `preference_defines.dart`: (`PreferenceFeature` class) 实现 `AppsFeature` 接口，定义此功能模块在主菜单中的标识符、标题和图标。
*   `preference_detail.dart`: (`PreferenceDetail` StatefulWidget) 显示选中偏好设置的键、类型和值。提供编辑功能，允许用户修改值并通过 `AppsConnectService` 发送更新请求。
*   `preference_filter.dart`: (`PreferenceFilter` StatefulWidget 和 `PreferenceFilterController` ChangeNotifier) 提供关键词输入框和同步按钮。`PreferenceFilterController` 管理过滤状态。
*   `preference_home.dart`: (`PreferenceHome` StatefulWidget) 作为偏好设置功能的根 Widget，组织 `PreferenceFilter`、偏好设置列表 (ListView) 和 `PreferenceDetail`。管理当前选中的偏好设置项状态，并根据平台调整布局。它监听 `AppsConnectService` 和 `filterController` 的变化来更新显示的偏好设置列表。

## 3. 编码规范

*   **命名规范**：遵循 Dart 和 Flutter 的标准命名约定。
*   **状态管理**：
    *   偏好设置数据源自 `AppsConnectService` (全局服务)，通过 `ProtoPreference` 消息传递。
    *   过滤条件由 `PreferenceFilterController` (ChangeNotifier) 管理。
    *   当前选中的偏好设置项状态由 `PreferenceHome` 的 `State` 管理。
    *   UI 组件内部状态（如 `PreferenceDetail` 中的编辑状态 `isEditing`）通过 `StatefulWidget` 和 `setState` 管理。
*   **数据处理**：`PreferenceHome` 中有逻辑处理来自 `AppsConnectService` 的原始偏好设置消息，进行去重（保留最新的 `get` 操作记录）和排序。
*   **组件化**：功能被划分为独立的 Widget。
*   **响应式设计**：使用 `MediaQuery.of(context).size.width < 600` 判断平台并调整 UI。

## 4. 引用关系

### 内部引用：

*   `preference_home.dart` 引用了：
    *   `./preference_detail.dart`
    *   `./preference_filter.dart`
*   `preference_defines.dart` 引用了：
    *   `./preference_home.dart`

### 外部引用（项目内其他模块）：

*   `preference_defines.dart`:
    *   `package:consoleapp/apps_feature.dart` (实现 `AppsFeature`)
*   `preference_detail.dart`:
    *   `package:consoleapp/protocols/protocol_defines.dart` (使用 `ProtoMessageBase`)
    *   `package:consoleapp/protocols/protocol_preference.dart` (使用 `ProtoPreference` 模型)
    *   `package:consoleapp/services/apps_connect_service.dart` (发送更新后的偏好设置)
*   `preference_filter.dart`:
    *   `package:consoleapp/protocols/protocol_defines.dart` (使用 `ProtoMessageBase`)
    *   `package:consoleapp/protocols/protocol_preference.dart` (使用 `ProtoPreference`)
    *   `package:consoleapp/services/apps_connect_service.dart` (发送同步请求)
*   `preference_home.dart`:
    *   `package:consoleapp/protocols/protocol_preference.dart` (使用 `ProtoPreference`)
    *   `package:consoleapp/services/apps_connect_service.dart` (获取偏好设置数据、监听设备选择)

### 外部引用（第三方库）：

*   `preference_detail.dart`:
    *   `package:flutter/material.dart`
    *   `dart:convert` (用于 JSON 编解码)
    *   `package:re_editor/re_editor.dart` (虽然导入但在此文件未直接使用其组件，可能为早期遗留或计划使用)
    *   `package:re_highlight/languages/json.dart` (同上)
    *   `package:re_highlight/styles/atom-one-light.dart` (同上)
*   `preference_defines.dart`, `preference_filter.dart`, `preference_home.dart`:
    *   `package:flutter/material.dart`
*   `preference_home.dart`:
    *   `dart:convert` (用于显示值的摘要)

## 5. 状态管理总结

*   **偏好设置数据**：由全局的 `AppsConnectService` 管理和提供，通过 `ProtoPreference` 消息。`PreferenceHome` 监听此服务，对收到的数据进行处理（过滤 `operation == "get"` 的消息，去重保留最新，按键排序）以构建显示的列表。
*   **过滤状态**：由 `PreferenceFilterController` (一个 `ChangeNotifier`) 维护，主要是关键词文本。`PreferenceFilter` UI 组件修改此 Controller 的状态，而 `PreferenceHome` 监听此 Controller 的变化以更新其显示的列表。
*   **选中项状态**：`PreferenceHome` 的 `State` (`_PreferenceHomeState`) 中的 `selectedPreference` 变量负责管理当前在列表中选中的偏好设置项。
*   **编辑状态**：`PreferenceDetail` 的 `State` (`_PreferenceDetailState`) 中的 `isEditing` 和 `isSubmiting` 变量管理编辑界面的状态。
*   **UI 内部状态**：各个 StatefulWidget (`PreferenceDetail`, `PreferenceFilter`, `PreferenceHome`) 通过 `setState` 管理其他局部 UI 状态。

此模块通过组合服务监听、ChangeNotifier 和局部状态管理，实现了偏好设置的展示、筛选和修改功能。