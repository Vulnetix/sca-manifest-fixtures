project('meson-test', 'cpp',
  version : '0.1.0',
  default_options : ['cpp_std=c++20']
)

boost_dep = dependency('boost', modules : ['asio', 'filesystem'], required : true)
fmt_dep = dependency('fmt', version : '>=10.0')
openssl_dep = dependency('openssl', version : '>=3.0')
gtest_dep = dependency('gtest', version : '>=1.14')
zlib_dep = dependency('zlib', version : '>=1.3')

executable('meson-test',
  'src/main.cpp',
  dependencies : [boost_dep, fmt_dep, openssl_dep, gtest_dep, zlib_dep],
  install : true
)
