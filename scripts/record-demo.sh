#!/bin/bash
# Record Snapshot Comparison demo
source "$(dirname "$0")/lib/demo-framework.sh"

TOOL_NAME="snapshot-comparison"
SHORT_NAME="snapcmp"
LANGUAGE="rust"

# GIF parameters
GIF_COLS=100
GIF_ROWS=30
GIF_SPEED=1.0
GIF_FONT_SIZE=14

demo_setup() {
  # Create temp directory for snapshots
  mkdir -p /tmp/demo-snapshots
}

demo_cleanup() {
  # Clean up snapshots
  rm -rf /tmp/demo-snapshots
}

demo_commands() {
  # ═══════════════════════════════════════════
  # Snapshot Comparison / snapcmp - Tuulbelt
  # ═══════════════════════════════════════════

  # Step 1: Installation
  echo "# Step 1: Install globally"
  sleep 0.5
  echo "$ cargo install --path ."
  sleep 1

  # Step 2: View help
  echo ""
  echo "# Step 2: View available commands"
  sleep 0.5
  echo "$ snapcmp --help"
  sleep 0.5
  "$BIN" --help | head -30
  sleep 3

  # Step 3: Create a snapshot
  echo ""
  echo "# Step 3: Create a snapshot"
  sleep 0.5
  echo "$ echo \"Expected output v1.0\" | snapcmp create test-output --dir /tmp/demo-snapshots"
  sleep 0.5
  echo "Expected output v1.0" | "$BIN" create test-output --dir /tmp/demo-snapshots
  sleep 2

  # Step 4: Check against snapshot (match)
  echo ""
  echo "# Step 4: Check against snapshot (should match)"
  sleep 0.5
  echo "$ echo \"Expected output v1.0\" | snapcmp check test-output --dir /tmp/demo-snapshots"
  sleep 0.5
  echo "Expected output v1.0" | "$BIN" check test-output --dir /tmp/demo-snapshots
  echo "✓ Snapshot matches (exit code: $?)"
  sleep 2

  # Step 5: Check with different output (mismatch)
  echo ""
  echo "# Step 5: Check with different output (mismatch)"
  sleep 0.5
  echo "$ echo \"Expected output v2.0\" | snapcmp check test-output --dir /tmp/demo-snapshots"
  sleep 0.5
  echo "Expected output v2.0" | "$BIN" check test-output --dir /tmp/demo-snapshots --color || echo "✗ Mismatch detected (shows diff)"
  sleep 3

  # Step 6: Update snapshot
  echo ""
  echo "# Step 6: Update snapshot with new expected output"
  sleep 0.5
  echo "$ echo \"Expected output v2.0\" | snapcmp update test-output --dir /tmp/demo-snapshots"
  sleep 0.5
  echo "Expected output v2.0" | "$BIN" update test-output --dir /tmp/demo-snapshots
  echo "✓ Snapshot updated"
  sleep 2

  # Step 7: List snapshots
  echo ""
  echo "# Step 7: List all snapshots"
  sleep 0.5
  echo "$ snapcmp list --dir /tmp/demo-snapshots"
  sleep 0.5
  "$BIN" list --dir /tmp/demo-snapshots
  sleep 2

  # Step 8: Clean up
  echo ""
  echo "# Step 8: Delete snapshot"
  sleep 0.5
  echo "$ snapcmp delete test-output --dir /tmp/demo-snapshots"
  "$BIN" delete test-output --dir /tmp/demo-snapshots
  echo "✓ Snapshot deleted"
  sleep 1

  echo ""
  echo "# Done! Test snapshots with: echo <output> | snapcmp create <name>"
  sleep 1
}

run_demo
