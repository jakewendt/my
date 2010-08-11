#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.65])

#	Initializes autoconf, should be the first macro called in 
#	configure.in.  sourcefile is the name (relative to current 
#	directory) of a source file from your code.
#	AC_INIT(sourcefile)
AC_INIT([FULL-PACKAGE-NAME], [VERSION], [BUG-REPORT-ADDRESS])
#AC_INIT(source/jexpr.c)

#	You must call AM_INIT_AUTOMAKE(package,version) right after 
#	AC_INIT, use AM_CONFIG_HEADER instead of AC_CONFIG_HEADER. 
AM_INIT_AUTOMAKE(gdu,0.0.1)
AM_CONFIG_HEADER(config.h)

AC_CONFIG_SRCDIR([source/constarith.c])

#	Make AC_OUTPUT create the headers listed in the files list 
#	(space-separated). Replaces @DEFS@ in generated files with 
#	-DHAVE_CONFIG_H. The usual name for the header is config.h 
#	(created from config.h.in. The autoheader generates 
#	config.h.in files automatically for you 
#	(it is documented in the next sections). 
#	AC_CONFIG_HEADER(files)
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
#	Determines a C compiler to use, sets the CC variable. If this is 
#	GCC, set the GCC variable to 'yes', otherwise 'no'. Initializes 
#	the CFLAGS variable if it hasn't been set already (to override 
#	CFLAGS, do it in configure.in BEFORE calling this macro)
AC_PROG_CC

#	Tests the C compiler
AC_LANG_C

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([stdlib.h string.h])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_FUNC_MALLOC

#	similar to AC_CHECK_FUNC, but looks for many functions at once, 
#	setting HAVE_function for each function found (in the given set). 
#	AC_CHECK_FUNCS(a[,b[,c]])
#	a=list of functions (space-separated)
#	b=action if found
#	c=action if not found 
AC_CHECK_FUNCS([floor sqrt])

#	If make predefines the variable MAKE, define output variable SET_MAKE 
#	to be empty. Otherwise, define SET_MAKE to contain `MAKE=make'.       
AC_PROG_MAKE_SET
               
#	Checks for stdlib.h, stdarg.h , string.h and float.h, 
#	defines STDC_HEADERS on success.
AC_HEADER_STDC

#	checks if the given C function is available in the standard library 
#	(i.e., the libraries that are linked by default to any C program). 
#	AC_CHECK_FUNC(a[,b[,c]])
#	a=function
#	b=action if found
#	c=action if not found 
AC_CHECK_FUNC(atol,,AC_MSG_ERROR(oops! no atol ?!?))
                  
VERSION="0.0.1"
AC_SUBST(VERSION)



#	Create output files. Perform substitutions on files, which 
#	contains a list of files separated by spaces. (is writes, 
#	say, Makefile, from a Makefile.in file, spec from spec.in, 
#	and so on. The name given here is without the .in suffix. 
#	The other 2 parameters are seldom used, consult the autoconf 
#	docs if needed. If AC_CONFIG_HEADER, AC_LINK_FILES or 
#	AC_CONFIG_SUBDIRS were called, the files named as their 
#	arguments are created too. 
#	AC_OUTPUT(files [,a[,b]])
dnl read Makefile.in and write Makefile
AC_OUTPUT(Makefile)


#	AC_CONFIG_FILES([Makefile])
#	AC_OUTPUT


#	Notes from http://www.seul.org/docs/autotut/

