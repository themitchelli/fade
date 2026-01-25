# Shell Portability Standard

Guidelines for writing shell scripts that work across BSD and GNU environments. Apply these when writing bash scripts or shell tests.

---

## The Portability Problem

Shell scripts written on macOS (BSD utilities) often fail on Linux (GNU utilities), and vice versa. The most common issues involve different command-line flags between BSD and GNU versions of core utilities.

**Why it matters:**
- Tests written on macOS may fail in CI/CD (often Linux)
- Scripts fail overnight on different developer machines
- Portability errors block automated workflows unnecessarily

---

## Common Portability Issues

### head -n -X (Remove Last X Lines)

**Problem:** GNU `head` supports negative line counts (`head -n -1` removes last line), but BSD `head` does not.

**Error:** `head: illegal line count -- -1`

**Portable solution:** Use `sed` instead.

```bash
# Bad - works on Linux, fails on macOS
cat file.txt | head -n -1

# Good - works everywhere
cat file.txt | sed '$d'           # Remove last line
cat file.txt | sed -e :a -e '$d;N;2,3ba' -e 'P;D'  # Remove last 3 lines (complex)
```

**Simple rule:** Never use `head -n -X` with negative counts. Use `sed '$d'` for removing the last line.

### sed -i (In-Place Editing)

**Problem:** BSD `sed` requires a backup extension argument, GNU `sed` makes it optional.

**Error:** `sed: 1: "file.txt": invalid command code f`

**Portable solution:** Always provide a backup extension (use empty string if you don't want backup files).

```bash
# Bad - works on Linux, fails on macOS
sed -i 's/foo/bar/' file.txt

# Good - works everywhere
sed -i.bak 's/foo/bar/' file.txt     # Creates file.txt.bak
sed -i '' 's/foo/bar/' file.txt      # macOS only, no backup (NOT portable to older GNU)

# Best - portable with cleanup
sed -i.bak 's/foo/bar/' file.txt && rm -f file.txt.bak
```

**Simple rule:** Always use `sed -i.bak`, then remove `.bak` files if unwanted.

### tail -n +X (Start from Line X)

**Status:** Already portable! Both BSD and GNU support this syntax.

```bash
# Good - works everywhere
tail -n +5 file.txt    # Skip first 4 lines, show from line 5 onward
tail -n 10 file.txt    # Show last 10 lines
```

**Note:** If you see a `tail: illegal offset` error, it's likely a different syntax issue, not the `-n +X` pattern.

---

## Portable Alternatives for Common Operations

### Remove Last N Lines

| Operation | Portable Command |
|-----------|------------------|
| Remove last line | `sed '$d'` |
| Remove last 2 lines | `sed -e '$d' -e '$d'` or `head -n -2` (GNU only) |
| Remove last N lines | Use `awk` or process line count manually |

```bash
# Portable: Remove last line
sed '$d' input.txt > output.txt

# Portable: Remove last 2 lines
sed -e '$d' -e '$d' input.txt > output.txt
```

### In-Place File Editing

| Operation | Portable Command |
|-----------|------------------|
| Simple substitution | `sed -i.bak 's/old/new/g' file.txt && rm -f file.txt.bak` |
| Multiple files | `find . -name "*.txt" -exec sed -i.bak 's/old/new/g' {} \; && find . -name "*.bak" -delete` |

```bash
# Portable: Replace text in file
sed -i.bak 's/foo/bar/g' myfile.txt
rm -f myfile.txt.bak

# Portable: Replace in multiple files
for file in *.sh; do
  sed -i.bak 's/old/new/g' "$file"
  rm -f "$file.bak"
done
```

### Line Extraction

| Operation | Portable Command |
|-----------|------------------|
| First N lines | `head -n N file.txt` |
| Last N lines | `tail -n N file.txt` |
| Lines M to N | `sed -n 'M,Np' file.txt` |
| Skip first N lines | `tail -n +$((N+1)) file.txt` |

```bash
# Portable: Extract lines 10-20
sed -n '10,20p' file.txt

# Portable: Skip first 5 lines
tail -n +6 file.txt

# Portable: Get line 42
sed -n '42p' file.txt
```

---

## Testing for Portability

### Detect Your Environment

```bash
# Check if running BSD or GNU
if head --version 2>&1 | grep -q "GNU"; then
  echo "GNU utilities (Linux)"
else
  echo "BSD utilities (macOS)"
fi
```

### Test Matrix

Test scripts on both environments:
- **macOS:** BSD coreutils (default)
- **Linux:** GNU coreutils (Ubuntu, Debian, CI/CD)

### Common Test Patterns

```bash
# Portable test assertion pattern
expected="foo"
actual=$(command_that_might_fail)

if [[ "$actual" != "$expected" ]]; then
  echo "FAIL: Expected '$expected', got '$actual'"
  exit 1
fi

# Use sed instead of head for last-line removal
output=$(cat results.txt | sed '$d')  # Remove last line portably
```

---

## Auto-Healing Whitelist

FADE's auto-healing system (FEAT-012) applies these portable fixes automatically when tests fail:

| Detected Error | Auto-Fix Applied |
|----------------|------------------|
| `head: illegal line count` | Replace `head -n -X` with `sed` alternative |
| `sed: -i needs an argument` | Add `.bak` extension: `sed -i.bak` |
| `tail: illegal offset` | Manual review (pattern already portable) |

**Note:** Auto-healing only applies to files in `fade/tests/` directory for safety.

---

## Quick Reference

| Task | Portable Command | Avoid |
|------|------------------|-------|
| Remove last line | `sed '$d'` | `head -n -1` |
| In-place edit | `sed -i.bak 's/old/new/' file` | `sed -i 's/old/new/' file` |
| Skip first N lines | `tail -n +$((N+1))` | None (already portable) |
| Extract line range | `sed -n 'M,Np'` | Complex `head | tail` chains |

---

## When to Read This Standard

Read this document when:
- Writing shell scripts or bash tests
- Fixing test failures with "illegal" or "invalid" errors
- Setting up CI/CD pipelines across different OS environments
- Contributing to FADE test suite (`fade/tests/`)
- Reviewing shell portability auto-healing logs

---

## References

- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- [FreeBSD Manual Pages](https://www.freebsd.org/cgi/man.cgi)
- [Shellcheck](https://www.shellcheck.net/) - Detects some portability issues
