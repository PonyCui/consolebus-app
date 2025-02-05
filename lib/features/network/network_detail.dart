import 'package:consoleapp/protocols/protocol_network.dart';
import 'package:consoleapp/utils/apps_util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

class NetworkDetail extends StatefulWidget {
  final ProtoNetwork? network;

  const NetworkDetail({super.key, this.network});

  @override
  State<NetworkDetail> createState() => _NetworkDetailState();
}

class _NetworkDetailState extends State<NetworkDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      animationDuration: const Duration(milliseconds: 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.network == null) {
      return const Center(
        child: Text('请选择一个网络请求'),
      );
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '请求元数据'),
            Tab(text: '请求体'),
            Tab(text: '响应元数据'),
            Tab(text: '响应体'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _RequestMetadataTab(network: widget.network!),
              _RequestBodyTab(network: widget.network!),
              _ResponseMetadataTab(network: widget.network!),
              _ResponseBodyTab(network: widget.network!),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestMetadataTab extends StatelessWidget {
  final ProtoNetwork network;

  const _RequestMetadataTab({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionArea(
            child: _buildMetadataTable(context, [
              {'URI': network.requestUri},
              {'Method': network.requestMethod},
              {'Headers': network.requestHeaders},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataTable(
      BuildContext context, List<Map<String, dynamic>> data) {
    final isMobile = AppsUtil.isMobileMode(context);
    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(isMobile ? 100 : 150),
        1: const FlexColumnWidth(),
      },
      children: data.map((item) {
        final entry = item.entries.first;
        if (entry.value is Map) {
          final entryValue = entry.value as Map;
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: entryValue.entries.map((header) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            header.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(header.value),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${entry.value}'),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _RequestBodyTab extends StatefulWidget {
  final ProtoNetwork network;

  const _RequestBodyTab({super.key, required this.network});

  @override
  State<_RequestBodyTab> createState() => _RequestBodyTabState();
}

class _RequestBodyTabState extends State<_RequestBodyTab> {
  String _viewType = 'plain';

  @override
  void initState() {
    super.initState();
    _initViewType();
  }

  void _initViewType() {
    final headers = widget.network.requestHeaders as Map<String, dynamic>?;
    if (_hasJsonContentType(headers)) {
      setState(() => _viewType = 'json');
    } else if (_hasImageContentType(headers)) {
      setState(() => _viewType = 'image');
    }
  }

  bool _hasJsonContentType(Map<String, dynamic>? headers) {
    if (headers == null) return false;

    try {
      final contentType = headers.entries
          .firstWhere(
            (entry) => entry.key.toLowerCase() == 'content-type',
          )
          .value
          .toString()
          .toLowerCase();

      return contentType.contains('application/json');
    } catch (e) {
      return false;
    }
  }

  bool _hasImageContentType(Map<String, dynamic>? headers) {
    if (headers == null) return false;

    try {
      final contentType = headers.entries
          .firstWhere(
            (entry) => entry.key.toLowerCase() == 'content-type',
          )
          .value
          .toString()
          .toLowerCase();

      return contentType.contains('image/');
    } catch (e) {
      return false;
    }
  }

  Widget _buildBodyContent(String? content) {
    if (content == null) return const Text('无内容');

    switch (_viewType) {
      case 'json':
        return _JSONCodeEditor(content: content);
      case 'plain':
        return SelectableText(content);
      case 'image':
        try {
          return Image.memory(base64Decode(content));
        } catch (e) {
          return const Text('不是有效的图片格式');
        }
      default:
        return SelectableText(content);
    }
  }

  Widget _buildViewTypeSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'plain', label: Text('纯文本')),
        ButtonSegment(value: 'json', label: Text('JSON')),
        ButtonSegment(value: 'image', label: Text('图片')),
      ],
      selected: {_viewType},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() => _viewType = newSelection.first);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildViewTypeSelector(),
          const SizedBox(height: 16),
          Expanded(child: _buildBodyContent(widget.network.requestBody)),
        ],
      ),
    );
  }
}

class _JSONCodeEditor extends StatelessWidget {
  const _JSONCodeEditor({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    String prettyJson = content;
    try {
      final jsonData = json.decode(content);
      prettyJson = const JsonEncoder.withIndent('   ').convert(jsonData);
    } catch (e) {}

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CodeEditor(
            controller: CodeLineEditingController.fromText(prettyJson),
            readOnly: true,
            indicatorBuilder:
                (context, editingController, chunkController, notifier) {
              return Row(
                children: [
                  DefaultCodeLineNumber(
                    controller: editingController,
                    notifier: notifier,
                  ),
                  DefaultCodeChunkIndicator(
                      width: 20,
                      controller: chunkController,
                      notifier: notifier)
                ],
              );
            },
            style: CodeEditorStyle(
              codeTheme: CodeHighlightTheme(
                languages: {'json': CodeHighlightThemeMode(mode: langJson)},
                theme: atomOneLightTheme,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ResponseMetadataTab extends StatelessWidget {
  final ProtoNetwork network;

  const _ResponseMetadataTab({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionArea(
            child: _buildMetadataTable(context, [
              {'Status Code': network.responseStatusCode.toString()},
              {
                'Status': network.responseStatusCode == -1
                    ? 'Error'
                    : network.responseStatusCode == -2
                        ? 'Cancelled'
                        : network.responseStatusCode <= 0
                            ? 'Pending'
                            : 'Done'
              },
              {'Headers': network.responseHeaders},
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataTable(
      BuildContext context, List<Map<String, dynamic>> data) {
    final isMobile = AppsUtil.isMobileMode(context);
    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(isMobile ? 100 : 150),
        1: const FlexColumnWidth(),
      },
      children: data.map((item) {
        final entry = item.entries.first;
        if (entry.value is Map) {
          final entryValue = entry.value as Map;
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: entryValue.entries.map((header) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            header.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(header.value),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${entry.value}'),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _ResponseBodyTab extends StatefulWidget {
  final ProtoNetwork network;

  const _ResponseBodyTab({super.key, required this.network});

  @override
  State<_ResponseBodyTab> createState() => _ResponseBodyTabState();
}

class _ResponseBodyTabState extends State<_ResponseBodyTab> {
  String _viewType = 'plain';

  @override
  void initState() {
    super.initState();
    _initViewType();
  }

  void _initViewType() {
    final headers = widget.network.responseHeaders as Map<String, dynamic>?;
    if (_hasJsonContentType(headers)) {
      setState(() => _viewType = 'json');
    } else if (_hasImageContentType(headers)) {
      setState(() => _viewType = 'image');
    }
  }

  bool _hasJsonContentType(Map<String, dynamic>? headers) {
    if (headers == null) return false;

    try {
      final contentType = headers.entries
          .firstWhere(
            (entry) => entry.key.toLowerCase() == 'content-type',
          )
          .value
          .toString()
          .toLowerCase();

      return contentType.contains('application/json');
    } catch (e) {
      return false;
    }
  }

  bool _hasImageContentType(Map<String, dynamic>? headers) {
    if (headers == null) return false;

    try {
      final contentType = headers.entries
          .firstWhere(
            (entry) => entry.key.toLowerCase() == 'content-type',
          )
          .value
          .toString()
          .toLowerCase();

      return contentType.contains('image/');
    } catch (e) {
      return false;
    }
  }

  Widget _buildBodyContent(String? content) {
    if (content == null) return const Text('无内容');

    switch (_viewType) {
      case 'json':
        return _JSONCodeEditor(content: content);
      case 'plain':
        return SelectableText(content);
      case 'image':
        try {
          return Image.memory(base64Decode(content));
        } catch (e) {
          return const Text('不是有效的图片格式');
        }
      default:
        return SelectableText(content);
    }
  }

  Widget _buildViewTypeSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'plain', label: Text('纯文本')),
        ButtonSegment(value: 'json', label: Text('JSON')),
        ButtonSegment(value: 'image', label: Text('图片')),
      ],
      selected: {_viewType},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() => _viewType = newSelection.first);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildViewTypeSelector(),
          const SizedBox(height: 16),
          Expanded(child: _buildBodyContent(widget.network.responseBody)),
        ],
      ),
    );
  }
}
