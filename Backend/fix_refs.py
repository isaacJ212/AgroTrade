import os
import re

directory = 'src/Agro_Trade.Application'
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.cs'):
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
            except UnicodeDecodeError:
                with open(filepath, 'r', encoding='latin-1') as f:
                    content = f.read()
            
            original_content = content
            
            # Match an object path followed by .NombreCompleto
            # Example: user.NombreCompleto -> $"{user.Nombre} {user.PrimerApellido} {user.SegundoApellido}".Trim()
            content = re.sub(r'([a-zA-Z0-9_\.]+)\.NombreCompleto', r'$"{\1.Nombre} {\1.PrimerApellido} {\1.SegundoApellido}".Trim()', content)
            
            # Match DireccionBase similarly
            content = re.sub(r'([a-zA-Z0-9_\.]+)\.DireccionBase', r'$"{\1.Departamento}, {\1.Municipio}, {\1.DireccionExacta}".Trim(new char[] { \',\', \' \' })', content)
            
            if content != original_content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Fixed {filepath}")
