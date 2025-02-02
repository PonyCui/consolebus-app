import 'package:consoleapp/protocols/protocol_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'network_exporter.dart';

class NetworkList extends StatelessWidget {
  final List<ProtoNetwork> networks;
  final ProtoNetwork? selectedNetwork;
  final Function(ProtoNetwork) onSelectNetwork;

  const NetworkList({
    super.key,
    required this.networks,
    required this.selectedNetwork,
    required this.onSelectNetwork,
  });

  void _showContextMenu(
      BuildContext context, ProtoNetwork network, Offset globalPosition) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        globalPosition,
        globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: const Text('复制网址'),
          onTap: () {
            Clipboard.setData(ClipboardData(text: network.requestUri));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('网址已复制到剪贴板')),
            );
          },
        ),
        PopupMenuItem(
          child: const Text('以 CURL 格式复制'),
          onTap: () {
            final curlCommand = NetworkExporter.generateCurlCommand(network);
            Clipboard.setData(ClipboardData(text: curlCommand));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CURL 命令已复制到剪贴板')),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: networks.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Theme.of(context).dividerColor,
      ),
      itemBuilder: _buildListItem,
    );
  }

  Widget? _buildListItem(context, index) {
    final network = networks[index];
    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, network, details.globalPosition);
      },
      child: ListTile(
        selected: network == selectedNetwork,
        title: Text(
          network.requestUri,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: network.requestMethod,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: ' • ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: network.responseStatusCode <= 0
                    ? (network.responseStatusCode == -1
                        ? 'Error'
                        : network.responseStatusCode == -2
                            ? 'Cancelled'
                            : 'Pending')
                    : '${((network.responseTime.millisecondsSinceEpoch - network.requestTime.millisecondsSinceEpoch) / 1000).toStringAsFixed(2)}s',
                style: TextStyle(
                  color: network.responseStatusCode == -1
                      ? Colors.red
                      : network.responseStatusCode == -2
                          ? Colors.orange
                          : network.responseStatusCode <= 0
                              ? Colors.blue
                              : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        onTap: () => onSelectNetwork(network),
      ),
    );
  }
}
