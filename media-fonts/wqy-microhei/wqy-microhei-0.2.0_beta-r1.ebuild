# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Droid derived Sans-Serif style CJK font"
HOMEPAGE="http://wenq.org/wqy2/index.cgi https://sourceforge.net/projects/wqy/"
SRC_URI="https://downloads.sourceforge.net/wqy/${P/_/-}.tar.gz
	https://dev.gentoo.org/~dlan/distfiles/${PN}.ttc.xd3"
S="${WORKDIR}/${PN}"

LICENSE="Apache-2.0 GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc ppc64 ~riscv x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

DOCS=( AUTHORS.txt ChangeLog.txt README.txt )

FONT_SUFFIX="ttc"

BDEPEND="dev-util/xdelta:3"

src_prepare() {
	xdelta3 -f -d -s wqy-microhei.ttc "${DISTDIR}"/wqy-microhei.ttc.xd3 \
		wqy-microhei.ttc || die
	default
}
