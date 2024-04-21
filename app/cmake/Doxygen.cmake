find_package(Doxygen REQUIRED)

include(FetchContent)
FetchContent_Declare(doxygen-awesome-css
  GIT_REPOSITORY
    https://github.com/jothepro/doxygen-awesome-css.git
  GIT_TAG
    v2.3.2
)
FetchContent_MakeAvailable(doxygen-awesome-css)

function(Doxygen target input)
  set(NAME docs)
  set(DOXYGEN_HTML_OUTPUT     ${CMAKE_BINARY_DIR}/${NAME})
  set(DOXYGEN_GENERATE_HTML         YES)
  set(DOXYGEN_GENERATE_TREEVIEW     YES)
  set(DOXYGEN_HAVE_DOT              YES)
  set(DOXYGEN_DOT_IMAGE_FORMAT      svg)
  set(DOXYGEN_DOT_TRANSPARENT       YES)
  set(DOXYGEN_HTML_EXTRA_STYLESHEET
      ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome.css)


  # Recursively find all header and source files in the specified directory
  file(GLOB_RECURSE ALL_SOURCE_FILES ${input}/*.cpp ${input}/*.c ${input}/*.h)
  # # Generate a list of directories containing the source files
  # set(FILES_LIST "")
  # foreach(SOURCE_FILE ${ALL_SOURCE_FILES})
  #   #cmake_path(GET ${SOURCE_FILE} ROOT_PATH ${FILE_PATH})
  #   list(APPEND FILES_LIST ${SOURCE_FILE})
  # endforeach()

  # # Remove duplicate directories
  # list(REMOVE_DUPLICATES ${ALL_SOURCE_FILES})#${FILES_LIST})

  doxygen_add_docs(
    ${NAME}
    ${ALL_SOURCE_FILES}
    COMMENT "Generate docygen documentation for ${target} project"
  )
endfunction()
