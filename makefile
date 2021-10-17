
define INIT_CONTENT
#!/bin/busybox sh

/bin/busybox --install -s /bin
/bin/busybox --install -s /sbin

/sbin/mount -t devtmpfs  devtmpfs  /dev
/sbin/mount -t proc      proc      /proc
/sbin/mount -t sysfs     sysfs     /sys
/sbin/mount -t tmpfs     tmpfs     /tmp

/bin/sh
endef

export INIT_CONTENT
all:
	mkdir root; \
	cd root; \
	mkdir -p bin dev etc lib mnt proc sbin sys tmp var; \
	cd -; \
	curl -L 'https://www.busybox.net/downloads/binaries/1.26.2-defconfig-multiarch/busybox-x86_64' >root/bin/busybox; \
	chmod +x root/bin/busybox; \
	echo "$$INIT_CONTENT" > root/init; \
	chmod +x root/init; \
	cd root; \
	find . | cpio -ov --format=newc | gzip -9 >../initramfs; \
	cd -;
clean:
	rm -r root initramfs
