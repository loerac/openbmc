FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://00-bmc-eth0.network"

do_install_append () {
	install -d ${D}/etc/systemd/network
	install -m 0644 -D ${WORKDIR}/00-bmc-eth0.network ${D}/etc/systemd/network
}
