#!/bin/bash

# -s project にしたいけどうまく動かない気がする

claude mcp add serena -s local -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd) --enable-web-dashboard false
