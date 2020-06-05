DEPENDS_append_tomahawk = " tomahawk-yaml-config"

EXTRA_OECONF_tomahawk = " \
    SENSOR_YAML_GEN=${STAGING_DIR_HOST}${datadir}/tomahawk-yaml-config/ipmi-sensors.yaml \
    "
