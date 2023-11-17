# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="
	https://github.com/fonttools/fonttools/
	https://pypi.org/project/fonttools/
"
SRC_URI="
	https://github.com/fonttools/fonttools/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="+native-extensions"

RDEPEND="
	>=dev-python/fs-2.4.9[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		app-arch/zopfli
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	# When dev-python/pytest-shutil is installed, we get weird import errors.
	# This is due to incomplete nesting in the Tests/ tree:
	#
	#   Tests/feaLib/__init__.py
	#   Tests/ufoLib/__init__.py
	#   Tests/svgLib/path/__init__.py
	#   Tests/otlLib/__init__.py
	#   Tests/varLib/__init__.py
	#
	# This tree requires an __init__.py in Tests/svgLib/ too, bug #701148.
	touch Tests/svgLib/__init__.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local -x FONTTOOLS_WITH_CYTHON=$(usex native-extensions)
	distutils-r1_python_compile
}

src_test() {
	# virtualx used when matplotlib is installed causing plot module tests to run
	virtx distutils-r1_src_test
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest Tests fontTools \
		-p rerunfailures --reruns=5 ||
		die "Tests failed with ${EPYTHON}"
}
