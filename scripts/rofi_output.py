from subprocess import run, Popen, PIPE
import json

current_sink = run(['pactl', 'get-default-sink'],
                   capture_output=True, text=True).stdout.replace('\n', '')

pactl_info = run(['pactl', '-f', 'json', 'list'],
                 capture_output=True, text=True).stdout
pactl_dict = json.loads(pactl_info)

for sink in pactl_dict['sinks']:
    if (sink['name'] == current_sink):
        current_port = sink['active_port']

outputs = []

for card in pactl_dict['cards']:
    for port_key in card['ports'].keys():
        port = card['ports'][port_key]
        if (port['availability'] != "not available" \
                and port['type'] in ("Microphone", "HDMI", "Speaker", "Headphones", "Line")):
            output = {}
            if (port_key == current_port):
                output['name'] = '•' + port['description']
            else:
                output['name'] = ' ' + port['description']
            output['card'] = card['index']
            output['port'] = port_key
            profiles = [profile for profile in port['profiles'] \
                                    if 'output' in profile and 'input' in profile]                    
            if len(profiles) > 0:
                output['profile'] = profiles[0]
            else:
                output['profile'] = port['profiles'][0]
            outputs.append(output)
print(outputs)

options = [output['name'] for output in outputs]
names = '|'.join(options)

echo = Popen(["echo", names], stdout=PIPE)
rofi = Popen(["rofi", "-no-fixed-num-lines", "-dmenu", "-i", "-sep", "|", "-p",
              "Select output"], stdin=echo.stdout, stdout=PIPE, text=True)
echo.stdout.close()
selection = rofi.communicate()[0].replace('\n', '')
id = options.index(selection)
run(['pactl', 'set-card-profile', str(outputs[id]['card']), outputs[id]['profile'] ])

pactl_sink_info = run(['pactl', '-f', 'json', 'list', 'sinks'],
                 capture_output=True, text=True).stdout
pactl_sink_dict = json.loads(pactl_sink_info)

for sink in pactl_sink_dict:
    sink['index']
    for port in sink['ports']:
        if port['name'] == outputs[id]['port']:
            run(['pactl', 'set-default-sink', str(sink['index'])])
            run(['pactl', 'set-sink-port', str(sink['index']), port['name']])
