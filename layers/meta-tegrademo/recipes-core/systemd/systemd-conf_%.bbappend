# Prepend (not append) our dir so our files (e.g. wired.network) take priority
# over the upstream systemd-conf recipe's same-named files.  Yocto's FILESPATH
# uses first-match-wins, so the prepended path is searched before the
# upstream recipe directory.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/:"

SRC_URI:append = " file://logind.conf"

# Use the upstream default PACKAGECONFIG (dhcp-ethernet).  The upstream
# systemd-conf recipe installs a wired.network (Type=ether, DHCP=yes) which
# brings up the ethernet interface via DHCP automatically.  mDNS advertises
# the device as orin.local, so no static IP address is required.

do_install:append() {
    install -D -m0644 ${WORKDIR}/sources/logind.conf ${D}${systemd_unitdir}/logind.conf.d/00-${PN}.conf

    # Don't write to a nonexistant syslog.
    sed -i 's/ForwardToSyslog=yes/ForwardToSyslog=no/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
}

FILES:${PN}:append = "\
    ${base_prefix}/etc/systemd/logind.conf \
"
