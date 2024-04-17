* DragResizableDivider
```dart
    LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            _maxWidth = constraints.maxWidth;
            final spaceWidth = constraints.maxWidth / 3;
            return Row(
                children: [
                DragResizableDividerRow(
                    defaultWidth: constraints.maxWidth / 5,
                    widthRange: [
                    constraints.maxWidth / 10,
                    constraints.maxWidth / 5
                    ],
                    child: const Settings(),
                ),
                DragResizableDividerRow(
                    defaultWidth: constraints.maxWidth / 3,
                    widthRange: [
                    constraints.maxWidth / 6,
                    constraints.maxWidth / 2
                    ],
                    child: const TasksWidget(),
                ),
                Expanded(
                    child: Column(
                    children: [
                        DragResizableDividerColumn(
                        defaultHeight: constraints.maxHeight / 2,
                        heightRange: [
                            constraints.maxHeight / 4,
                            constraints.maxHeight / 2
                        ],
                        color: Colors.red,
                        child: FakeExecuteAiCard(),
                        ),
                        Expanded(child: AiCard()),
                    ],
                    ),
                ),
                ],
            );
            },
        ),

```