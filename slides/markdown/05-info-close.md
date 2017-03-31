### `info/1` and `close/1`
- Be sure to close ports when you're done with them with `Port.close/1`
- If the external progam exits, the port closes. If a port is closed, the function `Port.info/1` will return `nil`