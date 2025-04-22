if ! playerctl status 2>/dev/null | grep -q Playing; then
    betterlockscreen -l dim
fi
