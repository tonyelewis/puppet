# == Class: boost
#
# Description of class boost here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# Prerequisites - ensure the use of this depends on the packages for the compiler and standard library:
#  * 'clang'
#  * 'libc++1'
#  * 'libc++-dev'
#  * 'g++'
#
# The sort of command that can be used to clean out a Boost build dir without triggering a rebuild on the next puppet run:
# ~~~sh
# find /opt/boost_1_68_0_normal_c++14-build-clang-7.0 -type f | grep -P '\b(user-config.jam|lib.*wave.*\.a|cast.hpp|b2)$' -v | perl -pe 's/\n/\0/g' | xargs -P 8 -0 -I VAR rm -f VAR
# ~~~

define boost ( $boost_version, $cpp_standard ) {
	$user            = 'lewis'
	$group           = 'lewis'
	$home_dir        = "/home/${user}"
	$user_src_dir    = "${home_dir}/source"
	$msan_libcxx_dir = "${user_src_dir}/msan-libcxx"

	if $boost_version !~ /^1_\d{2}_\d(_b\d)?$/ {
		fail(
			"The Boost module does yet handle versions not in list: "
			+ join( $known_boost_vns, ',' )
			+ " - please make it do so, so it can then handle your version \"${boost_version}\""
		)
	}

	File {
		owner => 'root',
		group => 'root',
	}

	Exec {
		environment => [
			'EXPAT_INCLUDE=/usr/include',
			'EXPAT_LIBPATH=/usr/lib'
		],
	}

	# Set a sensible path so that binaries' paths don't have to be fully qualified
	Exec {
		path => [
			'/usr/bin',
			'/usr/sbin',
			'/bin',
			'/sbin'
		]
	}

	$boost_version_underscores       = $boost_version
	$boost_version_underscores_short = $boost_version[0,-3]
	$boost_version_periods_raw       = regsubst( $boost_version_underscores, '_',  '.',      'G' )
	$boost_version_periods           = regsubst( $boost_version_periods_raw, '_b', '.beta.', 'G' )
	$root_dir                        = '/opt'
	$archive_file                    = "${root_dir}/boost_${boost_version_underscores}.tar.gz"

	$build_type_tag_sets = [
		[ 'dbgstd' ],
		[ 'memsan' ],
		[ 'normal' ],
		[ 'thrsan' ],
		[ 'ubasan' ],
	]

	$build_type_tag_sets.each | Array $build_type_tag_set | {
		[ $build_type_tag ] = $build_type_tag_set

		$build_name  = "boost_${boost_version_underscores}_${build_type_tag}_${cpp_standard}"
		$install_dir = "${root_dir}/${build_name}"
		# Ensure the build directory exists
		file { "Ensure build directory exists ${build_name}" :
			ensure => 'directory',
			path   => $install_dir,
		}
	}

	$tag_compiler_and_cmake_flags_sets = [
		[ '7.0', 'normal', 'clang', '/usr/bin/clang++',                    "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.0', 'dbgstd', 'clang', "${home_dir}/source/llvm/bin/clang++", " define=_LIBCPP_DEBUG=0  cxxflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.0', 'ubasan', 'clang', "${home_dir}/source/llvm/bin/clang++", "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.0', 'thrsan', 'clang', "${home_dir}/source/llvm/bin/clang++", "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=thread                                                                                                                                                                                     -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=thread                                                                                                                                                                                     -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.0', 'memsan', 'clang', "${home_dir}/source/llvm/bin/clang++", "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -pie -fno-omit-frame-pointer -nostdinc++ -I${msan_libcxx_dir}/include/c++/v1 -L${msan_libcxx_dir}/lib -Wl,-rpath,${msan_libcxx_dir}/lib -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -pie -fno-omit-frame-pointer -nostdinc++ -I${msan_libcxx_dir}/include/c++/v1 -L${msan_libcxx_dir}/lib -Wl,-rpath,${msan_libcxx_dir}/lib -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.1', 'normal', 'gcc',   "${home_dir}/source/gcc/bin/g++",      "                         cxxflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.1', 'dbgstd', 'gcc',   "${home_dir}/source/gcc/bin/g++",      " define=_GLIBCXX_DEBUG=1 cxxflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
		[ '9.1', 'ubasan', 'gcc',   "${home_dir}/source/gcc/bin/g++",      "                         cxxflags=\"-std=${cpp_standard}                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	]

   # # TEMPORARILY RESTRICT CLANG TO 7.0 FOR BOOST 1.68 #
	# $tag_compiler_and_cmake_flags_sets = [
	# 	# [ '7.0', 'normal', 'clang', '/usr/bin/clang++',                    "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '7.0', 'dbgstd', 'clang', '/usr/bin/clang++',                    " define=_LIBCPP_DEBUG=0  cxxflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++                                                                                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	[ '7.0', 'ubasan', 'clang', '/usr/bin/clang++',                    "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                         -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '7.0', 'thrsan', 'clang', '/usr/bin/clang++',                    "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=thread                                                                                                                                                                                     -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=thread                                                                                                                                                                                     -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '7.0', 'memsan', 'clang', '/usr/bin/clang++',                    "                         cxxflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -pie -fno-omit-frame-pointer -nostdinc++ -I${msan_libcxx_dir}/include/c++/v1 -L${msan_libcxx_dir}/lib -Wl,-rpath,${msan_libcxx_dir}/lib -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard} -stdlib=libc++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -pie -fno-omit-frame-pointer -nostdinc++ -I${msan_libcxx_dir}/include/c++/v1 -L${msan_libcxx_dir}/lib -Wl,-rpath,${msan_libcxx_dir}/lib -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '9.1', 'normal', 'gcc',   "${home_dir}/source/gcc/bin/g++",      "                         cxxflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '9.1', 'dbgstd', 'gcc',   "${home_dir}/source/gcc/bin/g++",      " define=_GLIBCXX_DEBUG=1 cxxflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                                                                                                                                                                                                                      -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# 	# [ '9.1', 'ubasan', 'gcc',   "${home_dir}/source/gcc/bin/g++",      "                         cxxflags=\"-std=${cpp_standard}                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" linkflags=\"-std=${cpp_standard}                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer                                                                                                                                       -DBOOST_ASIO_HAS_STD_STRING_VIEW \" " ],
	# ]

	$tag_compiler_and_cmake_flags_sets.each | Array $tag_compiler_and_cmake_flags_set | {
		[ $compiler_version, $build_type_tag, $b2_toolset, $compiler_exe, $b2_flags ] = $tag_compiler_and_cmake_flags_set

		$unique_string             = "UID:${b2_toolset}${compiler_version}-${build_type_tag};${boost_version};${cpp_standard}"
		$build_name                = "boost_${boost_version_underscores}_${build_type_tag}_${cpp_standard}"
		$working_dir               = "${root_dir}/${build_name}-build-${b2_toolset}-${compiler_version}"
		$install_dir               = "${root_dir}/${build_name}"
		$config_jam_file           = "${working_dir}/user-config.jam"

		$boost_major_version_underscores = $boost_version_underscores[ 0, 4 ]
		$compiler_major_version          = $compiler_version[ 0 ]

		include boost::packages

		# Download the source archive (.tar.gz) file
		boost::download_file { "Download Boost archive ${unique_string}" :
			require       => Exec[ 'gcc_is_ready' ],
			#uri           => "http://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
			uri           => "https://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
			#uri           => "https://dl.bintray.com/boostorg/release/${boost_version_periods}/source/boost_${boost_version_underscores}.tar.gz",
			target        => $archive_file,
			unique_suffix => " ${unique_string}",
		}

		# Ensure the working directory exists
		->file { "Make Boost working directory ${unique_string}" :
			ensure => 'directory',
			path   => $working_dir,
			owner  => 'root',
		}

		# Untar the Boost archive file into the working directory
		->exec { "Untar Boost archive ${unique_string}" :
			command => "tar -zxvf ${archive_file} --directory ${working_dir} --strip-components=1",
			#creates => "${working_dir}/tools/regression/xsl_reports/xsl/v2/summary_page.xsl",
			creates => "${working_dir}/boost/cast.hpp",
		}

		# # Chmod the Boost directory to make everything readable and directories excecutable for all
		# #
		# # This should be uncommented but Puppet doesn't like it because it has the same
		# # path as above. Not sure how to resolve.
		# #                                                                [December 2016]
		# ->file { "Make Boost working directory readable & directory-executable by all ${unique_string}" :
		# 	path    => $working_dir,
		# 	ensure  => 'directory',
		# 	owner   => 'root',
		# 	mode    => 'a+rX',
		# 	recurse => 'true',
		# }

		# Run Boost's bootstrap
		->exec { "bootstrap boost ${unique_string}" :
			command     =>   "bootstrap.sh --prefix=${install_dir}",
			#command     =>   "bootstrap.sh --prefix=${install_dir} --without-libraries=fiber",
			cwd         =>   $working_dir,
			path        => [
				$working_dir,
				'/usr/bin',
				'/bin',
			],
			creates     => "${working_dir}/b2",
			environment => [
				'EXPAT_INCLUDE=/usr/include',
				'EXPAT_LIBPATH=/usr/lib'
			],
			require     => Class[ boost::packages ],
		}
		->file{ "write user config to specify compiler ${unique_string}" :
			content => "using ${b2_toolset} : ${compiler_version} : ${compiler_exe} ;",
			ensure  => file,
			mode    => '0644',
			owner   => 'root',
			path    => $config_jam_file
		}

		# dll-path is important to put the location to find dependent libraries in each library, which is more
		# important as `RPATH` is becoming more widely deprecated
		#
		# On an ELF platform (ie Linux), the loader finds the library by looking through a series of paths in this order:
		# * The `RPATH` built into the ELF executable / shared-library
		# * the `LD_LIBRARY_PATH`
		# * The `RUNPATH` built into the ELF executable / shared-library
		#
		# `RUNPATH` was added a replacement for `RPATH` because it was thought to be a mistake to not have `LD_LIBRARY_PATH` overriding `RPATH`.
		#
		# However `RUNPATH` also behaves slightly differently in that the loader only uses it to find *direct* dependencies,
		# not *transitive* dependencies (as happens with `RPATH`).
		#
		# As link commands are becoming more likely to use RUNPATH, it's becoming more important that shared (`.so`) libraries
		# have a suitable `RPATH` / `RUNPATH` to locate their own dependent libraries.
		#
		#
		# Some useful notes...
		#
		# To tell the linker to write `RPATH`, not `RUNPATH`, use `-Wl,--disable-new-dtags`
		#
		# To post-hoc fix a bunch of Boost shared libraries, use a command like
		# ~~~
		# find . -type f -name '*.so*' | xargs -I VAR patchelf --set-rpath /opt/boost_1_68_0_gcc_c++14_build/lib VAR
		# ~~~
		#
		# There's a helpful explanation (particularly comment #5) [here](https://bugs.launchpad.net/ubuntu/+source/eglibc/+bug/1253638)
		#
		# Commands that can help to diagnose these issues:
		# * `LD_DEBUG=libs ldd the_binary`
		# * `readelf -d the_binary`
		->boost::boost_b2 { "build debug boost ${unique_string}" :
			command     => "b2 -j2         --user-config=${config_jam_file} toolset=${b2_toolset}-${compiler_version} ${b2_flags} --layout=versioned variant=debug   dll-path=${install_dir}/lib ",
			working_dir => $working_dir,
			creates     => [
				"${working_dir}/stage/lib/libboost_wave-${b2_toolset}${compiler_major_version}-mt-x64-${boost_major_version_underscores}.a",
			],
		}

		->boost::boost_b2 { "build release boost ${unique_string}" :
			command     => "b2 -j2         --user-config=${config_jam_file} toolset=${b2_toolset}-${compiler_version} ${b2_flags} --layout=versioned variant=release dll-path=${install_dir}/lib ",
			working_dir => $working_dir,
			creates     => [
				"${working_dir}/stage/lib/libboost_wave-${b2_toolset}${compiler_major_version}-mt-x64-${boost_major_version_underscores}.a",
			],
		}

		->boost::boost_b2 { "install debug boost ${unique_string}" :
			command     => "b2 -j2 install --user-config=${config_jam_file} toolset=${b2_toolset}-${compiler_version} ${b2_flags} --layout=versioned variant=debug   dll-path=${install_dir}/lib ",
			working_dir => $working_dir,
			creates     => [
				"${install_dir}/lib/libboost_wave-${b2_toolset}${compiler_major_version}-mt-x64-${boost_major_version_underscores}.a",
			],
		}
		->boost::boost_b2 { "install release boost ${unique_string}" :
			command     => "b2 -j2 install --user-config=${config_jam_file} toolset=${b2_toolset}-${compiler_version} ${b2_flags} --layout=versioned variant=release dll-path=${install_dir}/lib ",
			working_dir => $working_dir,
			creates     => [
				"${install_dir}/lib/libboost_wave-${b2_toolset}${compiler_major_version}-mt-x64-${boost_major_version_underscores}.a",
			],
		}

		if $b2_toolset == 'clang' and $build_type_tag == 'normal' {
			file { "/opt/include ${unique_string}" :
				ensure => 'link',
				path   => '/opt/include',
				target => "${build_name}/include/boost-${boost_version_underscores_short}",
				owner  => 'root',
				group  => 'root',
			}
		}
	}
}



######################################################################

# 'java-1.7.0-openjdk',     # For Jenkins
# 'jenkins',

# service{ 'jenkins' :
# 	ensure  => 'running',
# 	enable  => 'true',
# 	require => Package[ 'jenkins', 'java-1.7.0-openjdk' ],
# }->
# exec{ 'open-port-8080-for-jenkins' :
# 	command     => 'firewall-cmd --zone=public --add-port=8080/tcp --permanent',
# 	refreshonly => 'true',
# }->
# exec{ 'open-http-for-jenkins' :
# 	command     => 'firewall-cmd --zone=public --add-service=http --permanent',
# 	refreshonly => 'true',
# }->
# exec{ 'reload-firewall-for-jenkins' :
# 	command     => 'firewall-cmd --reload',
# 	refreshonly => 'true',
  # }
