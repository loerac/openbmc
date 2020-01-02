SRC_URI_remove = "git://github.com/openbmc/phosphor-ipmi-flash"
SRC_URI_append = " git://github.com/Nuvoton-Israel/phosphor-ipmi-flash"

SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_append_nuvoton = " static-bmc reboot-update host-bios"

NUVOTON_FLASH_PCIVGA  = "0x7F400000"
NUVOTON_FLASH_PCIMBOX = "0xF0848000"
NUVOTON_FLASH_LPC     = "0xc0008000"

#PACKAGECONFIG_append_nuvoton = " nuvoton-lpc"

#EXTRA_OECONF_append = " --enable-nuvoton-p2a-mbox"
EXTRA_OECONF_append = " --enable-nuvoton-p2a-vga"

IPMI_FLASH_BMC_ADDRESS_nuvoton = "${NUVOTON_FLASH_PCIVGA}"

SRC_URI_append_nuvoton = " file://bmc-verify.sh"
SRC_URI_append_nuvoton = " file://phosphor-ipmi-flash-bmc-verify.service"
SRC_URI_append_nuvoton = " file://bios-verify.sh"
SRC_URI_append_nuvoton = " file://phosphor-ipmi-flash-bios-verify.service"
SRC_URI_append_nuvoton = " file://bios-update.sh"
SRC_URI_append_nuvoton = " file://phosphor-ipmi-flash-bios-update.service"

do_install_append_nuvoton() {
	install -d ${D}/usr/sbin
	install -m 0755 -D ${WORKDIR}/bmc-verify.sh ${D}/${sbindir}/bmc-verify.sh
	install -m 0755 -D ${WORKDIR}/bios-verify.sh ${D}/${sbindir}/bios-verify.sh
	install -m 0755 -D ${WORKDIR}/bios-update.sh ${D}/${sbindir}/bios-update.sh

	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/phosphor-ipmi-flash-bmc-verify.service ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/phosphor-ipmi-flash-bios-verify.service ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/phosphor-ipmi-flash-bios-update.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE_${PN}_append_nuvoton = " \
    phosphor-ipmi-flash-bmc-verify.service \
    phosphor-ipmi-flash-bios-verify.service \
    phosphor-ipmi-flash-bios-update.service \
    "

pkg_postinst_${PN}_nuvoton() {
	LINK_BMC="$D$systemd_system_unitdir/phosphor-ipmi-flash-bmc-verify.wants/phosphor-ipmi-flash-bmc-verify.service"
	LINK_BIOS_UPDATE="$D$systemd_system_unitdir/phosphor-ipmi-flash-bios-update.wants/phosphor-ipmi-flash-bios-update.service"
	LINK_BIOS_VERIFY="$D$systemd_system_unitdir/phosphor-ipmi-flash-bios-verify.wants/phosphor-ipmi-flash-bios-verify.service"
	TARGET_BMC="../phosphor-ipmi-flash-bmc-verify.service"
	TARGET_BIOS_UPDATE="../phosphor-ipmi-flash-bios-update.service"
	TARGET_BIOS_VERIFY="../phosphor-ipmi-flash-bios-verify.service"
	mkdir -p $D$systemd_system_unitdir/phosphor-ipmi-flash-bmc-verify.wants
	mkdir -p $D$systemd_system_unitdir/phosphor-ipmi-flash-bios-update.wants
	mkdir -p $D$systemd_system_unitdir/phosphor-ipmi-flash-bios-verify.wants
	ln -s $TARGET_BMC $LINK_BMC
	ln -s $TARGET_BIOS_UPDATE $LINK_BIOS_UPDATE
	ln -s $TARGET_BIOS_VERIFY $LINK_BIOS_VERIFY
}

pkg_prerm_${PN}_nuvoton() {
	LINK_BMC="$D$systemd_system_unitdir/phosphor-ipmi-flash-bmc-verify.wants/phosphor-ipmi-flash-bmc-verify.service"
	LINK_BIOS_UPDATE="$D$systemd_system_unitdir/phosphor-ipmi-flash-bios-update.wants/phosphor-ipmi-flash-bios-update.service"
	LINK_BIOS_VERIFY="$D$systemd_system_unitdir/phosphor-ipmi-flash-bios-verify.wants/phosphor-ipmi-flash-bios-verify.service"
	rm $LINK_BMC
	rm $LINK_BIOS_UPDATE
	rm $LINK_BIOS_VERIFY
}