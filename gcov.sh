#!/bin/bash

gcov_init() {
	USER=`whoami`
	firejail --help
	firemon --help
	/usr/lib/firejail/fnet --help
	/usr/lib/firejail/fseccomp --help
	/usr/lib/firejail/ftee --help
	/usr/lib/firejail/fcopy --help
	firecfg --help
	sudo chown $USER:$USER `find .`
}

generate() {
	lcov -q --capture -d src/firejail -d src/firemon -d  src/fcopy -d src/fseccomp -d src/fnet -d src/ftee -d src/lib -d src/firecfg --output-file gcov-file-new
	lcov --add-tracefile gcov-file-old --add-tracefile gcov-file-new  --output-file gcov-file
	rm -fr gcov-dir
	genhtml -q gcov-file --output-directory gcov-dir
	sudo rm `find . -name *.gcda`
	cp gcov-file gcov-file-old
	gcov_init
}


gcov_init

# running tests
make test-root
generate
sleep 2

make test-chroot
generate
sleep 2

make test-network
generate
sleep 2

make test-appimage
generate
sleep 2

make test-overlay
generate
sleep 2

make test-fcopy
generate
sleep 2

make test-profiles
generate
sleep 2

make test-fs
generate
sleep 2

make test-utils
generate
sleep 2

make test-environment
generate
sleep 2

make test-apps
generate
sleep 2

make test-apps-x11
generate
sleep 2

make test-apps-x11-xorg 
generate
sleep 2

make test-filters 
generate
sleep 2

make test-arguments
generate
sleep 2
