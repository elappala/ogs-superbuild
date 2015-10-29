set(OGS_EIGEN_URL "http://opengeosys.s3.amazonaws.com/ogs6-lib-sources/eigen-3.2.5.tar.gz")
set(OGS_EIGEN_MD5 "8cc513ac6ec687117acadddfcacf551b")

ExternalProject_Add(eigen
	PREFIX ${CMAKE_BINARY_DIR}/external/eigen
	URL ${OGS_EIGEN_URL}
	URL_MD5 ${OGS_EIGEN_MD5}
	UPDATE_COMMAND ""
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	BUILD_IN_SOURCE 1
	INSTALL_COMMAND ""
)

ExternalProject_Get_Property( eigen source_dir )
set(eigen_SOURCE_DIR ${source_dir} CACHE PATH "" FORCE)
