
all: init
	$(MAKE) -C ./tcejdb

clean:
	- $(MAKE) -C ./tcejdb clean
	- rm -f *.upload
	- rm -f libtcejdb*.tar.gz libtcejdb*.deb libtcejdb*.changes libtcejdb*.build libtcejdb*.dsc
	- rm -f *.tgz

deb-packages: deb-packages-tcejdb;

deb-packages-tcejdb: init
	$(MAKE) -C ./tcejdb deb-packages

deb-source-packages:
	$(MAKE) -C ./ deb-packages DEBUILD_OPTS="-S"

deb-source-packages-tcejdb:
	$(MAKE) -C ./ deb-packages-tcejdb DEBUILD_OPTS="-S"

init:
	cd ./tcejdb && ./configure
	$(MAKE) -C ./tcejdb version
	- cp ./tcejdb/debian/changelog ./Changelog 
	- cp ./tcejdb/debian/changelog ./tcejdb/Changelog

node_webkit: i386 x86_64
	mkdir -p ./tcejdb/static/
	lipo -create ./libstcejdbx86.a ./libstcejdbx86_64.a -output ./tcejdb/static/libstcejdb.a
	rm ./libstcejdbx86.a ./libstcejdbx86_64.a
	ranlib ./tcejdb/static/libstcejdb.a

i386:
	cd ./tcejdb && ./configure --enable-i386
	$(MAKE) -C ./tcejdb version
	$(MAKE) -C ./tcejdb libtcejdb.a
	cp ./tcejdb/static/libstcejdbx86.a ./libstcejdbx86.a
	$(MAKE) -C ./tcejdb clean

x86_64:
	cd ./tcejdb && ./configure --enable-x64
	$(MAKE) -C ./tcejdb version
	$(MAKE) -C ./tcejdb libtcejdb.a
	cp ./tcejdb/static/libstcejdbx86_64.a ./libstcejdbx86_64.a
	$(MAKE) -C ./tcejdb clean


.PHONY: all clean deb-packages deb-source-packages init initdeb
