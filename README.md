# Bash Shell Utilities

A collection of Bash utilities for self-use.

## Quick Start

```bash
git clone https://github.com/creator54/bash-utils.git
cd bash-utils
make install
```

Utilities install to `~/.local/share/<util-name>/` with symlinks in `~/.local/bin/`.

## Utilities

<details>
<summary><strong>logz</strong> - Advanced Logging</summary>

Multi-level logging with flexible output formats.

```bash
logz "Application started"
logz --level ERROR --output app.log "Database failed"
logz --format json --color "User login"
```

**Features:** DEBUG/INFO/WARN/ERROR/FATAL levels, JSON/text/syslog formats, file output, colors, timestamps
</details>

<details>
<summary><strong>hush</strong> - Help System</summary>

Beautiful, Typer-inspired help formatting for Bash utilities.

```bash
hush logz                    # Show help for logz
hush --no-color git          # Disable colors
hush --width 60 logz         # Custom width
```

**Features:** Color formatting, structured sections, column alignment, works with any Bash utility

**Adding Support to Your Utilities:**

1. **Create Help File** - Add `hush.txt` to your utility directory:
```
USAGE: myutil [OPTIONS] COMMAND

DESCRIPTION:
Brief description of your utility.

ARGUMENTS:
* COMMAND: TEXT [required]
  The command to execute

OPTIONS:
--verbose
  Enable verbose output
--help
  Show this message and exit

EXAMPLES:
myutil start: Start the service
myutil --verbose stop: Stop with verbose output
```

2. **Integrate Help Function:**
```bash
show_help() {
    command -v hush >/dev/null 2>&1 && \
        exec hush -f "$HOME/.local/share/$(basename "$0")/hush.txt" || \
        echo "Install hush for enhanced help." >&2
}
```

3. **Use Template** - Base your help file on `utils/hush/template.hush`
</details>
</details>

## Development

### Adding New Utilities
```
utils/<name>/
├── <name>        # Main script
├── hush.txt      # Help file
└── test.sh       # Tests
```

### Testing
```bash
make test                    # All tests
cd utils/logz && ./test.sh   # Specific utility
```

## License
MIT