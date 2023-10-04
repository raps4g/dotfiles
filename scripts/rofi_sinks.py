from subprocess import run, Popen, PIPE
import json


current_sink = run(['pactl', 'get-default-sink'],
                   capture_output=True, text=True).stdout.replace('\n', '')
pactl_info = run(['pactl', '-f', 'json', 'list', 'sinks'],
                 capture_output=True, text=True).stdout
sinks_dict = json.loads(pactl_info)

sinks = []
ports = []
options = []
for sink in sinks_dict:
    id = sink['index']
    for port in sink['ports']:
        if port['availability'] != 'not available':
            sinks.append(id)
            ports.append(port['name'])
            if sink['name'] == current_sink and \
                    sink['active_port'] == port['name']:
                options.append('•'+port['name'].replace("[Out] ", ""))
            else:
                options.append(port['name'].replace("[Out] ", ""))

echo = Popen(["echo", '|'.join(options)], stdout=PIPE)
rofi = Popen(["rofi", "-no-fixed-num-lines", "-dmenu", "-i", "-sep", "|", "-p",
              "Select output"], stdin=echo.stdout, stdout=PIPE, text=True)
echo.stdout.close()
selection = rofi.communicate()[0].replace('\n', '')
if selection == '':
    quit()
id = options.index(selection)
run(['pactl', 'set-default-sink', str(sinks[id])])
run(['pactl', 'set-sink-port', str(sinks[id]), ports[id]])
