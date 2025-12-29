# Snapshot Comparison - Development Guide

**Part of Tuulbelt** | [Meta Repository](https://github.com/tuulbelt/tuulbelt)

## Tool Overview

Snapshot Comparison (`snapcmp`) is a Rust-based snapshot testing utility that helps detect regressions by comparing expected output snapshots against actual output. Unlike traditional assertion-based tests, snapshot tests capture the full output and detect any changes.

**Key Features:**
- **Automatic snapshot creation** on first run
- **Integrated diff output** using output-diffing-utility for rich diffs
- **Multiple file format support** (text, JSON, binary)
- **Flexible update modes** for accepting changes
- **Zero external dependencies** (uses only Rust std + Tuulbelt tools)

## Quick Start

```bash
# Development
cargo test          # Run all tests
cargo clippy        # Lint
cargo fmt           # Format
cargo build         # Debug build
cargo build --release  # Optimized build

# Usage
snapcmp update snapshots/expected.json actual-output.json
snapcmp verify snapshots/expected.json actual-output.json
```

## Architecture

**Core Components:**
- `src/lib.rs` - Library API for snapshot operations
- `src/main.rs` - CLI interface (`snapcmp` and `snapshot-comparison`)
- `tests/` - Integration tests
- `examples/` - Usage examples

**Dependency:**
- `output-diffing-utility` (git URL) - Provides rich diff output for mismatches

## Development Standards

### Code Quality
- **Clippy**: Zero warnings (`cargo clippy -- -D warnings`)
- **Rustfmt**: Auto-formatted (`cargo fmt`)
- **Tests**: 96 tests (library + integration + examples)
- **Coverage**: >90% for snapshot logic

### Testing Strategy
```bash
# Unit tests (src/lib.rs)
cargo test --lib

# Integration tests
cargo test --test integration

# Example verification
cargo test --example snapshot_workflow

# Dogfooding (validate with other Tuulbelt tools)
./scripts/dogfood-flaky.sh    # Test determinism
./scripts/dogfood-diff.sh     # Output consistency
```

### Security Considerations
- **Path validation**: All snapshot paths validated for traversal attacks
- **File size limits**: Maximum snapshot size enforced
- **Binary safety**: Binary snapshots validated before processing

## Composition with Other Tuulbelt Tools

**Required Dependency:**
- **output-diffing-utility** - Rich diff output for snapshot mismatches
  - Git URL: `https://github.com/tuulbelt/output-diffing-utility`
  - Provides semantic diffs (text, JSON, binary)
  - Zero external dependencies guarantee maintained

**Optional Dogfooding:**
- **test-flakiness-detector** - Validates test determinism
- **output-diffing-utility** - Self-validates diff output consistency

## Common Development Tasks

### Adding New Snapshot Format
1. Add format detection in `src/lib.rs::detect_format()`
2. Implement comparison logic in `compare_snapshots()`
3. Add integration test in `tests/format_support.rs`
4. Update README examples

### Updating Dependencies
```bash
# Update output-diffing-utility
cargo update
cargo test  # Verify compatibility
```

### Release Process
```bash
# 1. Update version in Cargo.toml
# 2. Update CHANGELOG.md
# 3. Run full test suite
cargo test
cargo clippy -- -D warnings
cargo build --release

# 4. Commit and tag
git commit -m "chore: release v0.2.0"
git tag v0.2.0
git push origin main --tags
```

## Troubleshooting

### Dependency Resolution Issues
If `output-diffing-utility` fails to fetch:
```bash
cargo clean
rm -rf ~/.cargo/git/checkouts/output-diffing-utility-*
cargo build
```

### Test Failures
```bash
# Run specific test with output
cargo test test_name -- --nocapture

# Run with backtrace
RUST_BACKTRACE=1 cargo test
```

### Binary Snapshot Issues
Binary snapshots are base64-encoded for storage. If corruption occurs:
```bash
# Regenerate snapshot
snapcmp update snapshots/binary-expected.bin actual.bin
```

## Key Files Reference

- `SPEC.md` - Snapshot format specification
- `DOGFOODING_STRATEGY.md` - Tool composition patterns
- `RESEARCH.md` - Design decisions and alternatives
- `CLI_DESIGN.md` - CLI interface design
- `STATUS.md` - Current development status

## CI/CD

**GitHub Actions** (`.github/workflows/test.yml`):
- Runs on every push to main
- Tests: format check, clippy, tests, release build
- No zero-dep verification (has Tuulbelt dependency)

## Support

**Issues**: Report to [tuulbelt/tuulbelt](https://github.com/tuulbelt/tuulbelt/issues) (centralized)
**Label**: `snapshot-comparison`

---

**Version**: v0.1.0
**Language**: Rust (Edition 2021)
**License**: MIT
