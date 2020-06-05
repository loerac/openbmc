FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

CHIPS = "bus@1e78a000/i2c-bus@340/emc1413@4c"
CHIPS += "bus@1e78a000/i2c-bus@340/emc1413@7c"
CHIPS += " pwm-tacho-controller@1e786000"

ITEMSFMT = "ahb/apb/{0}.conf"
ITEMS = "${@compose_list(d, 'ITEMSFMT', 'CHIPS')}"

ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN}_append_tomahawk = " ${@compose_list(d, 'ENVS', 'ITEMS')}"
