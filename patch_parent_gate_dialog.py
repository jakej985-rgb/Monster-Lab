import re

with open('lib/presentation/features/parent/parent_gate_dialog.dart', 'r') as f:
    content = f.read()

content = content.replace(
'''        leading: IconButton(
          icon: const Icon(Icons.arrow_back),''',
'''        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back','''
)

with open('lib/presentation/features/parent/parent_gate_dialog.dart', 'w') as f:
    f.write(content)
