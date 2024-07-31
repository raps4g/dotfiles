ACTIVE_WINDOW=$(xdotool getactivewindow)
ACTIVE_WM_CLASS=$(xprop -id $ACTIVE_WINDOW | grep WM_CLASS)
echo $ACTIVE_WINDOW
echo $ACTIVE_WM_CLASS
if [[ $ACTIVE_WM_CLASS == *"kitty"* ]]
then
    # Get PID. If _NET_WM_PID isn't set, bail.
    PID=$(xprop -id $ACTIVE_WINDOW | grep _NET_WM_PID | grep -oP "\d+")
    echo $PID

    if [[ "$PID" == "" ]]
    then
        kitty $@ &
    fi
    # Get first child of terminal
    CHILD_PID=$(pgrep -P $PID)
    echo $CHILD_PID
    if [[ "$PID" == "" ]]
    then
        kitty $@ &
    fi
    # Get current directory of child. The first child should be the shell.
    pushd "/proc/${CHILD_PID}/cwd"
    SHELL_CWD=$(pwd -P)
    popd
    echo $SHELL_CWD
    # Start kitty with the working directory
    kitty --working-directory $SHELL_CWD $@ &
else
    kitty $@ &
fi
