cmake_minimum_required(VERSION 2.8)

project(OGS-6-Superbuild NONE)
# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()
enable_language(C)
enable_language(CXX)

# Use a static runtime with MSVC
if(MSVC)
  foreach(flag
    CMAKE_CXX_FLAGS
    CMAKE_CXX_FLAGS_RELEASE
    CMAKE_C_FLAGS
    CMAKE_C_FLAGS_RELEASE
    )
    if(${flag} MATCHES "/MD")
      string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
    endif()
  endforeach()
endif()

if(APPLE)
  set(osx_args
    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.9
    -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64
    )
endif()

find_program(NINJA_EXECUTABLE ninja)
if(NINJA_EXECUTABLE)
  set(CMAKE_GENERATOR "Ninja")
  # Make Ninja verbose so CircleCI does not think the build has halted.
  set(verbose_command BUILD_COMMAND ${NINJA_EXECUTABLE} -v)
endif()

include(ExternalProject)
include(modules/boost.cmake)
include(modules/catalyst.cmake)
include(modules/eigen.cmake)

# Use a static C++ library on GCC/Linux
if(CMAKE_COMPILER_IS_GNUCXX AND CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(extra_flags "-static-libstdc++")
endif()
set(ogs_GIT_TAG master CACHE STRING "OGS Git revision.")
ExternalProject_Add(ogs
  DEPENDS boost vtk eigen
  GIT_REPOSITORY https://github.com/ufz/ogs.git
  GIT_TAG ${ogs_GIT_TAG}
  CMAKE_ARGS -Wno-dev
  CMAKE_CACHE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DOGS_SYSTEM_VTK_ONLY:BOOL=ON
    -DParaView_DIR:PATH=${vtk_BINARY_DIR}
    -DBOOST_ROOT:PATH=${boost_BINARY_DIR}
    -DEIGEN3_INCLUDE_DIR:PATH=${eigen_SOURCE_DIR}
    -DEIGEN3_FOUND:BOOL=ON
    ${osx_args}
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  #${verbose_command}
)
