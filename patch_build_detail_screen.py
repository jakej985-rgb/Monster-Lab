import re

with open('lib/presentation/features/build/build_detail_screen.dart', 'r') as f:
    content = f.read()

content = content.replace(
'''                  IconButton(
                    icon: const Icon(Icons.close_rounded),''',
'''                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close','''
)

with open('lib/presentation/features/build/build_detail_screen.dart', 'w') as f:
    f.write(content)
