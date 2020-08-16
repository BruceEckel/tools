[ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') -gt 5 ] && \
    echo "WSL2" || echo "WSL1"
