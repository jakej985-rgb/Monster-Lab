import re

with open('lib/presentation/shared/widgets/responsive_code_block.dart', 'r') as f:
    content = f.read()

content = content.replace(
'''              child: IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54, size: 18),''',
'''              child: IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54, size: 18),
                tooltip: 'Copy code','''
)

with open('lib/presentation/shared/widgets/responsive_code_block.dart', 'w') as f:
    f.write(content)
