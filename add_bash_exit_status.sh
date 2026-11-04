#!/bin/bash
# Adds exit status above prompt on command failure

if ! grep -q "^PROMPT_COMMAND=prompt_command$" ~/.bashrc; then
cat >> ~/.bashrc <<'EOF'

# Show exit status on command failure
ORIGINAL_PS1="$PS1"

prompt_command() {
    local ret=$?

    if [ $ret -ne 0 ]; then
        PS1="\[\e[1;31m\][$ret]\[\e[0m\]\n${ORIGINAL_PS1}"
    else
        PS1="${ORIGINAL_PS1}"
    fi
}

PROMPT_COMMAND=prompt_command

EOF

    echo "Exit Status installed. Please run 'source .bashrc' without the single quotes."
else
    echo "Exit Status already installed."
fi
