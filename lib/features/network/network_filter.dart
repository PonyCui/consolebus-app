import 'package:flutter/material.dart';

import 'network_filter_options_panel.dart';

class NetworkFilterController extends ChangeNotifier {
  String? filterText;
  bool filterRequestUri = true;
  bool filterRequestBody = true;
  bool filterResponseUri = true;
  bool filterResponseBody = true;

  bool shouldDisplay(
      String requestUri, String? requestBody, String? responseBody) {
    if (filterText == null || filterText!.isEmpty) return true;

    final keyword = filterText!.toLowerCase();
    if (filterRequestUri && requestUri.toLowerCase().contains(keyword))
      return true;
    if (filterRequestBody &&
        requestBody != null &&
        requestBody.toLowerCase().contains(keyword)) return true;
    if (filterResponseBody &&
        responseBody != null &&
        responseBody.toLowerCase().contains(keyword)) return true;

    return false;
  }
}

class NetworkFilter extends StatefulWidget {
  final NetworkFilterController controller;

  const NetworkFilter({
    super.key,
    required this.controller,
  });

  @override
  State<NetworkFilter> createState() => _NetworkFilterState();
}

class _NetworkFilterState extends State<NetworkFilter> {
  final filterTextController = TextEditingController();

  @override
  void dispose() {
    filterTextController.removeListener(onFilterTextChanged);
    widget.controller.removeListener(onFilterChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filterTextController.text = widget.controller.filterText ?? "";
    filterTextController.addListener(onFilterTextChanged);
    widget.controller.addListener(onFilterChanged);
  }

  void onFilterTextChanged() {
    widget.controller.filterText = filterTextController.text;
    widget.controller.notifyListeners();
  }

  void onFilterChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: _renderFilterText(context),
          ),
          const SizedBox(width: 12),
          _renderFilterOptions(),
        ],
      ),
    );
  }

  Container _renderFilterText(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Icon(
            Icons.filter_alt,
            size: 12,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: filterTextController,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
                hintText: "按关键词过滤",
                contentPadding: const EdgeInsets.only(bottom: 18),
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Tooltip _renderFilterOptions() {
    String filterStr = [
      widget.controller.filterRequestUri ? "URI" : "",
      widget.controller.filterRequestBody ? "请求体" : "",
      widget.controller.filterResponseBody ? "响应体" : "",
    ].where((it) => it.isNotEmpty).join(" + ");
    if (filterStr.isEmpty) {
      filterStr = "None";
    }
    return Tooltip(
      message: "选择过滤范围",
      child: MaterialButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NetworkFilterOptionsPanel(controller: widget.controller);
            },
            barrierColor: Colors.transparent,
          );
        },
        child: Row(
          children: [
            Text(
              filterStr,
              style: const TextStyle(fontSize: 12),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
