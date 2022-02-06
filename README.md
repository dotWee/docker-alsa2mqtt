# [docker-alsa2mqtt](https://github.com/dotWee/docker-alsa2mqtt)

- Syncs ALSA volume (same volume slider as in `alsamixer`) with MQTT
- Publishes state of device to MQTT usually from `/proc/asound/card0/pcm0p/sub0/status`

Use this to react to changes in volume or to change the ALSA volume by external events.

## Topics

```
dersimn/SoundPi/online → true

dersimn/SoundPi/status/device-in-use → {
      "val": true,
      "state": "RUNNING"
    }

dersimn/SoundPi/status/volume → 21

dersimn/SoundPi/set/volume ← 42
```

## Install

    apt install build-essential git libasound2-dev

    git clone https://github.com/dotwee/docker-alsa2mqtt
    cd docker-alsa2mqtt
    npm i


## Usage

See `node index --help`

```
alsa2mqtt 0.0.2
Control ALSA volume from MQTT

Usage: index [options]

Options:
      --prefix                                      [default: "dersimn/SoundPi"]
      --alsa-card                                           [default: "default"]
      --polling-interval  polling interval (in ms) for status updates
                                                                 [default: 3000]
      --version           Show version number                          [boolean]
  -h, --help              Show help                                    [boolean]
  -v, --verbosity         Possible values: "error", "warn", "info", "debug"
  -u, --mqtt-url          mqtt broker url. See
                          https://github.com/mqttjs/MQTT.js#connect-using-a-url
  -m, --alsa-mixer                                                    [required]
  -s, --alsa-status-file                                              [required]
```

Example:

    node index -v debug -u mqtt://10.1.1.100 -m Line -s /proc/asound/card1/pcm0p/sub0/status


### Install as systemd service

Copy [`alsa2mqtt.service`](rootfs/etc/systemd/system/alsa2mqtt.service) to `/etc/systemd/system/alsa2mqtt.service`, and edit parameters in `ExecStart`, then:

    systemctl daemon-reload
    systemctl enable alsa2mqtt.service 
    systemctl start alsa2mqtt.service

## Docker

### Get the container image

#### from [**docker hub**](https://hub.docker.com/r/dotwee/alsa2mqtt)

```bash
$ docker pull dotwee/alsa2mqtt:latest
```

#### from [**github packages**](https://github.com/dotWee/docker-alsa2mqtt/pkgs/container/alsa2mqtt)

```bash
$ docker pull ghcr.io/dotwee/alsa2mqtt:latest
```

#### or build it locally from [source](https://github.com/dotWee/docker-alsa2mqtt)

If you don't want to use the public container image from Docker Hub, build the image locally:

```bash
$ docker build --tag dotwee/aksa2mqtt:latest github.com/dotWee/docker-alsa2mqtt
```

### Run the image

Simply run `docker run --rm -v "$ALSA_STATUS_FILE:ALSA_STATUS_FILE" dotwee/aksa2mqtt:latest` and append your arguments.

Replace make sure to mount the alsa status file! Replace `$$ALSA_STATUS_FILE` to whatever value `--alsa-status-file` gets set.

Example:

```bash
$ docker run --rm -v "/proc/asound/card1/pcm0p/sub0/status:/proc/asound/card1/pcm0p/sub0/status" dotwee/aksa2mqtt:latest -v debug -u mqtt://10.1.1.100 -m Line --alsa-status-file /proc/asound/card1/pcm0p/sub0/status
```

Running the image without providing arguments will run with `--help` by default:

```bash
$ docker run --rm dotwee/aksa2mqtt:latest                                                 
alsa2mqtt 0.0.2
Control ALSA volume from MQTT

Usage: index.js [options]

Options:
      --prefix                                      [default: "dersimn/SoundPi"]
      --alsa-card                                           [default: "default"]
      --polling-interval  polling interval (in ms) for status updates
                                                                 [default: 3000]
      --version           Show version number                          [boolean]
  -h, --help              Show help                                    [boolean]
  -v, --verbosity         Possible values: "error", "warn", "info", "debug"
  -u, --mqtt-url          mqtt broker url. See
                          https://github.com/mqttjs/MQTT.js#connect-using-a-url
  -m, --alsa-mixer                                                    [required]
  -s, --alsa-status-file                                              [required]
```

## Credits

- [alsa-monitor](https://github.com/mlaurijsse/alsa-monitor-node)