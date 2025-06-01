# Menu Bar 组件 (`/lib/components/menu_bar`)

## 1. 功能与用途

`menu_bar` 组件主要用于在应用界面左侧显示一个垂直的菜单栏。这个菜单栏的核心功能是：

*   **功能模块切换**：
    *   展示一系列代表不同应用功能模块的图标按钮。
    *   当用户点击某个按钮时，会触发回调函数，通知父组件切换到对应的功能模块。
    *   高亮显示当前选中的功能模块按钮。
    *   鼠标悬停在按钮上时，会显示该功能模块的标题作为提示信息 (Tooltip)。

该组件的目的是为用户提供一个清晰、直观的方式来导航和切换应用内的主要功能区域。

## 2. 目录结构与文件说明

```
menu_bar/
|-- menu_bar.dart        # 主 UI 组件，实现菜单栏的整体布局和交互逻辑
`-- trae_rules.md        # (本文档) 组件规则说明
```

*   `menu_bar.dart`: 包含两个主要的 StatelessWidget：
    *   `AppsMenuBar`: 负责构建整个菜单栏。它从 `AppsFeatureManager.shared.allFeatures()` 获取所有可用的功能模块，并为每个模块创建一个 `AppsMenuButton`。
    *   `AppsMenuButton`: 代表菜单栏中的单个按钮。它接收一个 `AppsFeature` 对象来展示对应的图标和标题，并根据 `selected` 状态改变其外观（例如，显示一个指示条）。点击时调用 `onSelect` 回调。

## 3. 编码规范

*   **命名规范**：
    *   类名使用大驼峰命名法 (e.g., `AppsMenuBar`, `AppsMenuButton`)。
    *   文件名使用蛇形命名法 (e.g., `menu_bar.dart`)。
    *   变量和方法名使用小驼峰命名法 (e.g., `selectedFeature`, `onSelectFeature`)。
*   **代码风格**：
    *   遵循 Flutter 和 Dart 的官方编码风格指南。
    *   使用 `const` 关键字优化性能，特别是在 Widget 构造函数中。
    *   UI 组件设计为 `StatelessWidget`，因为它们的状态（如当前选中的功能）由父组件通过构造函数参数传入并管理。
*   **依赖管理**：
    *   明确导入所需的包。
    *   功能模块的列表通过 `AppsFeatureManager` 获取，这是一种服务定位或单例模式的应用。

## 4. 引用关系

### 内部引用：

*   `menu_bar.dart` 中的 `AppsMenuBar` 引用了 `AppsMenuButton`。

### 外部引用（项目内其他模块）：

*   `menu_bar.dart` 引用了：
    *   `package:consoleapp/apps_feature.dart` (使用了 `AppsFeature` 接口/基类以及 `AppsFeatureManager` 来获取功能列表)。

### 外部引用（第三方库）：

*   `menu_bar.dart` 引用了：
    *   `package:flutter/material.dart` (用于构建 UI 元素，如 `Container`, `Column`, `MaterialButton`, `Tooltip`, `Icon` 等)。

## 5. 状态管理

`menu_bar` 组件本身是无状态的 (`StatelessWidget`)。它接收以下参数来控制其行为和显示：

*   `selectedFeature` (String): 当前选中的功能模块的标识符，用于高亮对应的 `AppsMenuButton`。
*   `onSelectFeature` (Function(String)): 当用户点击某个菜单按钮时调用的回调函数，将所选功能的标识符传递给父组件。

选中状态的管理和功能切换的逻辑由使用 `AppsMenuBar` 的父组件负责。`AppsMenuBar` 仅负责展示和响应用户交互，并将交互事件通知给父组件。