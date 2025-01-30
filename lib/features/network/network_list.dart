import 'package:consoleapp/protocols/protocol_network.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: networks.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Theme.of(context).dividerColor,
      ),
      itemBuilder: (context, index) {
        final network = networks[index];
        return ListTile(
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
                      ? 'Pending'
                      : '${((network.responseTime.millisecondsSinceEpoch - network.requestTime.millisecondsSinceEpoch) / 1000).toStringAsFixed(2)}s',
                  style: TextStyle(
                    color: network.responseStatusCode <= 0
                        ? Colors.orange
                        : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => onSelectNetwork(network),
        );
      },
    );
  }
}
