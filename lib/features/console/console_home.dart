import 'package:flutter/material.dart';

class ConsoleHome extends StatelessWidget {
  const ConsoleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderFilterBar(context),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        Expanded(
          child: _renderContents(),
        )
      ],
    );
  }

  ListView _renderContents() {
    return ListView(
      children: [],
    );
  }

  Widget _renderFilterBar(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Container(
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
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: "选择日志等级",
            child: MaterialButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "Debug + Info + Warn + Error",
                    style: TextStyle(fontSize: 12),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                  )
                ],
              ),
            ),
          ),
          Tooltip(
            message: "导出",
            child: MaterialButton(
              onPressed: () {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minWidth: 0,
              child: Icon(
                Icons.save_alt,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
