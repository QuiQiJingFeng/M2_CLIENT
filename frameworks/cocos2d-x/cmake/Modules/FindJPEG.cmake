#.rst:
# FindJPEG
# --------
#
# Find JPEG
#
# Find the native JPEG includes and library This module defines
#
# ::
#
#   JPEG_INCLUDE_DIRS, where to find jpeglib.h, etc.
#   JPEG_LIBRARIES, the libraries needed to use JPEG.
#   JPEG_FOUND, If false, do not try to use JPEG.
#
# also defined, but not for general use are
#
# ::
#
#   JPEG_LIBRARY, where to find the JPEG library.

#=============================================================================
# Copyright 2001-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

find_path(JPEG_INCLUDE_DIR jpeglib.h)

set(JPEG_NAMES ${JPEG_NAMES} jpeg)
find_library(JPEG_LIBRARY NAMES ${JPEG_NAMES} )

# handle the QUIETLY and REQUIRED arguments and set JPEG_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(JPEG DEFAULT_MSG JPEG_LIBRARY JPEG_INCLUDE_DIR)

if(JPEG_FOUND)
  set(JPEG_INCLUDE_DIRS ${JPEG_INCLUDE_DIR})
  set(JPEG_LIBRARIES ${JPEG_LIBRARY})
endif()

mark_as_advanced(JPEG_LIBRARY JPEG_INCLUDE_DIRS )
