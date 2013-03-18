HOSTS = AIX-RS AIX-RT AIX-RT43 APOLLO AUX DEC2100 DEC3100 GOULD HPSPECT \
	HPUX MACH MIPS NEXT SGI SUN3 SUN4 VAX CONVEX

help:
	@cat README
	@echo "Normal usage: \"make MCHTYPE\""
	@echo "Valid types: " $(HOSTS)

AIX-RS_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir AIX-RS; cd AIX-RS; tar -xf -)
	@cp FILES/AIX-RS.README AIX-RS/README
	@cp FILES/AIX-RS.MAKEFILE AIX-RS/makefile
	@date > AIX-RS_DIR_MADE
AIX-RT_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir AIX-RT; cd AIX-RT; tar -xf -)
	@cp FILES/AIX-RT.README AIX-RT/README
	@cp FILES/AIX-RT.MAKEFILE AIX-RT/makefile
	@cp FILES/remake-links AIX-RT
	@date > AIX-RT_DIR_MADE
AIX-RT43_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir AIX-RT43; cd AIX-RT43; tar -xf -)
	@cp FILES/AIX-RT43.README AIX-RT43/README
	@cp FILES/AIX-RT43.MAKEFILE AIX-RT43/makefile
	@date > AIX-RT43_DIR_MADE
APOLLO_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir APOLLO; cd APOLLO; tar -xf -)
	@cp FILES/APOLLO.README APOLLO/README
	@cp FILES/APOLLO.MAKEFILE APOLLO/makefile
	@date > APOLLO_DIR_MADE
AUX_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir AUX; cd AUX; tar -xf -)
	@cp FILES/AUX.README AUX/README
	@cp FILES/AUX.MAKEFILE AUX/makefile
	@date > AUX_DIR_MADE
DEC2100_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir DEC2100; cd DEC2100; tar -xf -)
	@cp FILES/DEC2100.README DEC2100/README
	@cp FILES/DEC2100.MAKEFILE DEC2100/makefile
	@date > DEC2100_DIR_MADE
DEC3100_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir DEC3100; cd DEC3100; tar -xf -)
	@cp FILES/DEC3100.README DEC3100/README
	@cp FILES/DEC3100.MAKEFILE DEC3100/makefile
	@date > DEC3100_DIR_MADE
GOULD_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir GOULD; cd GOULD; tar -xf -)
	@cp FILES/GOULD.README GOULD/README
	@cp FILES/GOULD.MAKEFILE GOULD/makefile
	@date > GOULD_DIR_MADE
HPSPECT_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir HPSPECT; cd HPSPECT; tar -xf -)
	@cp FILES/HPSPECT.README HPSPECT/README
	@cp FILES/HPSPECT.MAKEFILE HPSPECT/makefile
	@date > HPSPECT_DIR_MADE
HPUX_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir HPUX; cd HPUX; tar -xf -)
	@cp FILES/HPUX.README HPUX/README
	@cp FILES/HPUX.MAKEFILE HPUX/makefile
	@date > HPUX_DIR_MADE
MACH_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir MACH; cd MACH; tar -xf -)
	@cp FILES/MACH.README MACH/README
	@cp FILES/MACH.MAKEFILE MACH/makefile
	@date > MACH_DIR_MADE
MIPS_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir MIPS; cd MIPS; tar -xf -)
	@cp FILES/MIPS.README MIPS/README
	@cp FILES/MIPS.MAKEFILE MIPS/makefile
	@date > MIPS_DIR_MADE
NEXT_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir NEXT; cd NEXT; tar -xf -)
	@cp FILES/NEXT.README NEXT/README
	@cp FILES/NEXT.MAKEFILE NEXT/makefile
	@date > NEXT_DIR_MADE
SGI_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir SGI; cd SGI; tar -xf -)
	@cp FILES/SGI.README SGI/README
	@cp FILES/SGI.MAKEFILE SGI/makefile
	@date > SGI_DIR_MADE
SUN3_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir SUN3; cd SUN3; tar -xf -)
	@cp FILES/SUN3.README SUN3/README
	@cp FILES/SUN3.MAKEFILE SUN3/makefile
	@csh FILES/make-lisp-dirs SUN3
	@date > SUN3_DIR_MADE
	@ln -s SUN3 mach-mc68020
SUN4_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir SUN4; cd SUN4; tar -xf -)
	@cp FILES/SUN4.README SUN4/README
	@cp FILES/SUN4.MAKEFILE SUN4/makefile
	@csh FILES/make-lisp-dirs SUN4
	@ln -s SUN4 mach-sparc
	@date > SUN4_DIR_MADE
VAX_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir VAX; cd VAX; tar -xf -)
	@cp FILES/VAX.README VAX/README
	@cp FILES/VAX.MAKEFILE VAX/makefile
	@date > VAX_DIR_MADE
CONVEX_DIR_MADE:
	@echo "Creating binary area..."
	@(cd BINARY-TEMPLATE; tar -cf - .) | (mkdir CONVEX; cd CONVEX; tar -xf -)
	@cp FILES/CONVEX.README CONVEX/README
	@cp FILES/CONVEX.MAKEFILE CONVEX/makefile
	@date > CONVEX_DIR_MADE

AIX-RS:		AIX-RS_DIR_MADE AIX-RS_LAST_MAKE
	cd AIX-RS; make; make install; date > AIX-RS_LAST_MAKE
AIX-RT:		AIX-RT_DIR_MADE AIX-RT_LAST_MAKE
	cd AIX-RT; make; make install; date > AIX-RT_LAST_MAKE
AIX-RT43:	AIX-RT43_DIR_MADE AIX-RT43_LAST_MAKE
	cd AIX-RT43; make; make install; date > AIX-RT43_LAST_MAKE
APOLLO:		APOLLO_DIR_MADE APOLLO_LAST_MAKE
	cd APOLLO; make; make install; date > APOLLO_LAST_MAKE
AUX:		AUX_DIR_MADE AUX_LAST_MAKE
	cd AUX; make; make install; date > AUX_LAST_MAKE
DEC2100:	DEC2100_DIR_MADE DEC2100_LAST_MAKE
	cd DEC2100; make; make install; date > DEC2100_LAST_MAKE
DEC3100:	DEC3100_DIR_MADE DEC3100_LAST_MAKE
	cd DEC3100; make; make install; date > DEC3100_LAST_MAKE
GOULD:		GOULD_DIR_MADE GOULD_LAST_MAKE
	cd GOULD; make; make install; date > GOULD_LAST_MAKE
HPSPECT:	HPSPECT_DIR_MADE HPSPECT_LAST_MAKE
	cd HPSPECT; make; make install; date > HPSPECT_LAST_MAKE
HPUX:		HPUX_DIR_MADE HPUX_LAST_MAKE
	cd HPUX; make; make install; date > HPUX_LAST_MAKE
MACH:		MACH_DIR_MADE MACH_LAST_MAKE
	cd MACH; make; make install; date > MACH_LAST_MAKE
MIPS:		MIPS_DIR_MADE MIPS_LAST_MAKE
	cd MIPS; make; make install; date > MIPS_LAST_MAKE
NEXT:		NEXT_DIR_MADE NEXT_LAST_MAKE
	cd NEXT; make; make install; date > NEXT_LAST_MAKE
SGI:		SGI_DIR_MADE SGI_LAST_MAKE
	cd SGI; make; date > SGI_LAST_MAKE
SUN3:		SUN3_DIR_MADE SUN3_LAST_MAKE
	cd SUN3; make; make install; date > SUN3_LAST_MAKE
SUN4:		SUN4_DIR_MADE SUN4_LAST_MAKE
	cd SUN4; make; make install; date > SUN4_LAST_MAKE
VAX:		VAX_DIR_MADE VAX_LAST_MAKE
	cd VAX; make; make install; date > VAX_LAST_MAKE

AIX-RS_LAST_MAKE:
AIX-RT_LAST_MAKE:
AIX-RT43_LAST_MAKE:
APOLLO_LAST_MAKE:
AUX_LAST_MAKE:
DEC2100_LAST_MAKE:
DEC3100_LAST_MAKE:
GOULD_LAST_MAKE:
HPSPECT_LAST_MAKE:
HPUX_LAST_MAKE:
MACH_LAST_MAKE:
MIPS_LAST_MAKE:
NEXT_LAST_MAKE:
SGI_LAST_MAKE:
SUN3_LAST_MAKE:
SUN4_LAST_MAKE:
VAX_LAST_MAKE:
CONVEX_LAST_MAKE:
