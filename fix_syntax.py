import re

with open('lib/dashboard.dart', 'r') as f:
    content = f.read()

# Fix the missing parenthesis for GestureDetector inside Expanded
# Expanded -> GestureDetector -> Container
content = re.sub(
    r'(?s)(Expanded\(\s*child:\s*GestureDetector\([\s\S]*?child:\s*Container\([\s\S]*?\n\s*\),\n\s*\),\n\s*\),\n)',
    r'\1                              ),\n',
    content
)

# Fix the missing comma for BoxShadow
content = content.replace(')BoxShadow(', '), BoxShadow(')

with open('lib/dashboard.dart', 'w') as f:
    f.write(content)
