#!/usr/bin/env bash

###############################################################################
# Shell Completion
###############################################################################

# completion_install() {

#     local INSTALLED=false


#     ###########################################################################
#     # Bash completion
#     ###########################################################################

#     if [[ -f "$LABCTL_HOME/completions/bash/labctl" ]]; then

#         install \
#             -Dm644 \
#             "$LABCTL_HOME/completions/bash/labctl" \
#             "/etc/bash_completion.d/labctl" || {

#                 log_error "Failed to install Bash completion."

#                 return "$EXIT_FAILURE"
#             }

#         INSTALLED=true

#     fi


#     ###########################################################################
#     # Zsh completion
#     ###########################################################################

#     if [[ -f "$LABCTL_HOME/completions/zsh/_labctl" ]]; then

#         install \
#             -Dm644 \
#             "$LABCTL_HOME/completions/zsh/_labctl" \
#             "/usr/share/zsh/site-functions/_labctl" || {

#                 log_error "Failed to install Zsh completion."

#                 return "$EXIT_FAILURE"
#             }

#         INSTALLED=true

#     fi


#     ###########################################################################
#     # Nothing found
#     ###########################################################################

#     if [[ "$INSTALLED" == false ]]; then

#         log_error "No completion files found."

#         return "$EXIT_CONFIGURATION_ERROR; "

#     fi


#     return "$EXIT_SUCCESS"

# }

completion_install() {

    local INSTALLED=false

    if [[ -f "$LABCTL_HOME/completions/bash/labctl" ]]; then

        install \
            -Dm644 \
            "$LABCTL_HOME/completions/bash/labctl" \
            "/etc/bash_completion.d/labctl" || {

                log_error "Failed to install Bash completion."

                return "$EXIT_FAILURE"
            }

        INSTALLED=true

    fi

    if [[ -f "$LABCTL_HOME/completions/zsh/_labctl" ]]; then

        install \
            -Dm644 \
            "$LABCTL_HOME/completions/zsh/_labctl" \
            "/usr/share/zsh/site-functions/_labctl" || {

                log_error "Failed to install Zsh completion."

                return "$EXIT_FAILURE"
            }

        INSTALLED=true

    fi

    if [[ "$INSTALLED" == false ]]; then

        log_info "No completion files found; skipping."

        return "$EXIT_SUCCESS"

    fi

    return "$EXIT_SUCCESS"
}

completion_remove() {

    rm -f /etc/bash_completion.d/labctl

    rm -f /usr/share/zsh/site-functions/_labctl

}