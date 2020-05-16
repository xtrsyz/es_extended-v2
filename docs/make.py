import os
import glob
from pathlib         import Path
from luadoc.parser   import DocParser
from luadoc.printers import to_pretty_json

source_files = glob.glob('../**/*.lua', recursive=True)
source_files = ['../server/classes/player.lua']

colors = {
  'string' : '#46a0f0',
  'boolean': '#f0ac46',
  'number' : '#d300eb',
  'custom' : '#32a83e',
  'any'    : '#000',
  'nil'    : '#ccc',
  'or'     : '#000',
}

def create_markdown(cls, file_name):

  # print(to_pretty_json(cls))

  file = open('./generated/markdown/' + cls.name + '.md', 'w')

  file.write('## class ' + cls.name + '\n')
  file.write('*' + file_name + '*\n\n\n\n')

  methodCount = 0

  for method in cls.methods:

    if methodCount > 0:
      file.write('---\n')

    if method.returns[0].type.id != 'nil':
      file.write('<span style="color:' + colors[method.returns[0].type.id] + '">' + method.returns[0].type.id + '</span> ')

    file.write('**' + method.name + ' ( **')

    paramCount = 0

    for param in method.params:

      if paramCount > 0:
        file.write(', ')

      file.write('<span style="color:' + colors[param.type.id] + '">' + param.type.id + '</span> ' + param.name)

      paramCount = paramCount + 1

    file.write(' **)**\n')

    if method.short_desc != '':
      file.write('> \n*' + method.short_desc + '*\n')

    if method.desc != '':
      lines = method.desc.split('\n')

      for line in lines:
        file.write('>' + line + '\n')

    file.write('\n')

    methodCount = methodCount + 1

  file.close()

for raw_path in source_files:

  path       = Path(raw_path)
  lua_file   = open(raw_path, 'r')
  lua_source = lua_file.read()
  rel_path   = path.relative_to('..').as_posix()

  module = DocParser().build_module_doc_model(lua_source, rel_path)

  for cls in module.classes:
    create_markdown(cls, rel_path)

  lua_file.close()

