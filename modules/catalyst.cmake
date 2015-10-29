set(vtk_GIT_TAG master CACHE STRING "VTK Git revision.")
ExternalProject_Add(vtk
  GIT_REPOSITORY https://github.com/ufz/catalyst-io.git
  GIT_TAG ${vtk_GIT_TAG}
  CONFIGURE_COMMAND ../vtk/cmake.sh ../vtk
    ${osx_args}
    -G ${CMAKE_GENERATOR}
    -DBUILD_SHARED_LIBS:BOOL=OFF
  INSTALL_COMMAND ""
)
ExternalProject_Get_Property(vtk binary_dir)
set(vtk_BINARY_DIR ${binary_dir} CACHE PATH "" FORCE)
