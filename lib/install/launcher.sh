#!/usr/bin/env bash

###############################################################################
# Launcher
###############################################################################

# launcher_install() {

#     filesystem_link \
#         "$INSTALL_DIR/bin/labctl" \
#         "$BIN_LINK"

# }

launcher_install() {

cat > "$BIN_DIR/labctl" <<'EOF'
#!/usr/bin/env bash

exec /opt/labctl/bin/labctl "$@"
EOF

    chmod 755 "$BIN_DIR/labctl"

}

launcher_remove() {

    rm -f "$BIN_LINK"

}

launcher_verify() {

    filesystem_symlink "$BIN_LINK"

}