SUMMARY = "Foxconn OEM IPMI commands"
DESCRIPTION = "Foxconn OEM IPMI commands"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCBRANCH = "master"

SRC_URI = "git://github.com/boyercee/foxconn-oem-ipmi;protocol=ssh;branch=${SRCBRANCH}"
SRCREV = "8ea02b62bd845b28ee3316974d27422d2512e690"

SRC_URI += "file://version.json"
SRC_URI += "file://bmc-eth0-bond \
           file://bmc-eth0-save \
           file://bmc-bond0 \
          "

S = "${WORKDIR}/git"
PV = "0.1+git${SRCPV}"

DEPENDS = "boost phosphor-ipmi-host phosphor-logging systemd"

inherit cmake obmc-phosphor-ipmiprovider-symlink

EXTRA_OECMAKE="-DENABLE_TEST=0 -DYOCTO=1"

LIBRARY_NAMES = "libzfxnoemcmds.so"

HOSTIPMI_PROVIDER_LIBRARY += "${LIBRARY_NAMES}"
NETIPMI_PROVIDER_LIBRARY += "${LIBRARY_NAMES}"

FILES_${PN}_append = " ${libdir}/ipmid-providers/lib*${SOLIBS}"
FILES_${PN}_append = " ${libdir}/host-ipmid/lib*${SOLIBS}"
FILES_${PN}_append = " ${libdir}/net-ipmid/lib*${SOLIBS}"
FILES_${PN}-dev_append = " ${libdir}/ipmid-providers/lib*${SOLIBSDEV}"

FILES_${PN} += "/etc/foxconn/"
FILES_${PN} += "/etc/systemd/network/"

do_install_append(){
   install -d ${D}${includedir}/foxconn-oem-ipmi
   install -m 0644 -D ${S}/include/*.hpp ${D}${includedir}/foxconn-oem-ipmi

   install -d ${D}/etc/foxconn/
   install -m 0644 ${WORKDIR}/version.json ${D}/etc/foxconn/

   install -d ${D}/etc/systemd/network
   install -m 0644 -D ${WORKDIR}/bmc-* ${D}/etc/systemd/network
}
