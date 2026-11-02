import re

with open('lib/presentation/shared/widgets/full_screen_image_viewer.dart', 'r') as f:
    content = f.read()

content = content.replace(
'''              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),''',
'''              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Close','''
)

with open('lib/presentation/shared/widgets/full_screen_image_viewer.dart', 'w') as f:
    f.write(content)
