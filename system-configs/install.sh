#!/bin/bash
# Install system configs (requires sudo)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing system configs..."

# SDDM theme
sudo cp "$SCRIPT_DIR/etc/sddm.conf.d/theme.conf" /etc/sddm.conf.d/theme.conf
echo "  ✓ SDDM theme config"

# Plymouth theme
sudo cp "$SCRIPT_DIR/etc/plymouth/plymouthd.conf" /etc/plymouth/plymouthd.conf
sudo plymouth-set-default-theme -R pedro-raccoon 2>/dev/null || echo "  ⚠ Plymouth theme rebuild skipped (run manually if needed)"
echo "  ✓ Plymouth config"

echo "Done!"
