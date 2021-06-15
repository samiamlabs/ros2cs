# Original Copyright:
# Copyright (C) 2015-2017, Illumina, inc.
#
# Based on
# https://github.com/Illumina/interop/tree/master/cmake/Modules

list(INSERT CMAKE_MODULE_PATH 0 "${dotnet_cmake_module_DIR}/Modules/dotnet")

include(FindPackageHandleStandardArgs)

if(CSBUILD_TOOL MATCHES "Mono|DotNetCore")
    set(MONO_FOUND FALSE)
    set(DotNetCore_FOUND FALSE)
    find_package(${CSBUILD_TOOL} REQUIRED)
endif()
if(NOT DotNetCore_FOUND AND NOT MONO_FOUND)
    if(CSBUILD_TOOL)
        message(WARNING "Ignored -DCSBUILD_TOOL=${CSBUILD_TOOL} it does not match Mono|DotNetCore")
    endif()
    find_package(DotNetCore)
    if(NOT DotNetCore_FOUND)
        find_package(Mono)
    endif()

endif()

if(NOT MSBUILD_TOOLSET)
    set(MSBUILD_TOOLSET "12.0")
endif()
if(NOT CSHARP_TARGET_FRAMEWORK_VERSION)
    set(CSHARP_TARGET_FRAMEWORK_VERSION "2.0")
endif()
if(NOT CSHARP_TARGET_FRAMEWORK)
    set(CSHARP_TARGET_FRAMEWORK "netcoreapp3.1")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(DotNetCore_PLATFORM "linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(DotNetCore_PLATFORM "osx")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows" OR CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    set(DotNetCore_PLATFORM "win")
else()
    message(FATAL_ERROR "Unknown value for CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
endif()

if(MSVC)
    string(FIND ${CMAKE_GENERATOR} "ARM" IS_ARM)
    if(IS_ARM GREATER -1)
        set(DotNetCore_ARCH "arm")
    endif()
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm")
    set(DotNetCore_ARCH "arm")
endif()

if(NOT DotNetCore_ARCH)
    if(CMAKE_SIZEOF_VOID_P EQUAL "4" OR FORCE_X86)
        set(CSHARP_PLATFORM "x86" CACHE STRING "C# target platform: x86, x64, anycpu, or itanium")
        set(DotNetCore_ARCH "x86")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL "8")
        if(MONO_FOUND AND "${MONO_VERSION}" VERSION_LESS "2.10.10")
            set(CSHARP_PLATFORM "anycpu" CACHE STRING "C# target platform: x86, x64, anycpu, or itanium")
        else()
            set(CSHARP_PLATFORM "x64" CACHE STRING "C# target platform: x86, x64, anycpu, or itanium")
            set(DotNetCore_ARCH "x64")
        endif()
    else()
        message(FATAL_ERROR "Only 32-bit and 64-bit are supported: ${CMAKE_SIZEOF_VOID_P}")
    endif()
endif()

if(DotNetCore_FOUND)
    if(NOT DotNetCore_PLATFORM)
        message(FATAL_ERROR "Missing .NET Core platform")
    endif()

    if(NOT DotNetCore_ARCH)
        message(FATAL_ERROR "Missing .NET Core arch")
    endif()

    set(DotNetCore_RUNTIME "${DotNetCore_PLATFORM}-${DotNetCore_ARCH}")
endif()

if(MSVC)
    set(CSHARP_BUILDER_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>")
else()
    set(CSHARP_BUILDER_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}")
endif()

string(REPLACE "." "" _version "${CSHARP_TARGET_FRAMEWORK_VERSION}")
set(CSBUILD_FOUND TRUE)
set(CSBUILD_RESTORE_FLAGS "/version")
set(CSBUILD_BUILD_FLAGS "")
if(DotNetCore_FOUND)
    message(STATUS "Found .NET Core: ${DotNetCore_VERSION}")
    set(CSBUILD_EXECUTABLE "${DotNetCore_EXECUTABLE}")
    set(CSBUILD_CSPROJ "dotnetcore.csproj")
    set(CSBUILD_BUILD_FLAGS "build")
    set(CSBUILD_OUPUT_PREFIX "${CSHARP_TARGET_FRAMEWORK}/publish/")
    set(CSHARP_INTERPRETER "${DotNetCore_EXECUTABLE}")
    set(CSBUILD_RESTORE_FLAGS "restore")
    set(CSHARP_TYPE "${CSHARP_TARGET_FRAMEWORK}")
elseif(MONO_FOUND)
    message(STATUS "Found Mono: ${MONO_VERSION}")
    set(CSBUILD_EXECUTABLE "${XBUILD_EXECUTABLE}")
    set(CSBUILD_CSPROJ "msbuild.csproj")
    set(CSBUILD_OUPUT_PREFIX "")
    set(CSHARP_INTERPRETER "${MONO_EXECUTABLE}")
    set(CSHARP_TYPE "net${_version}")
else()
    set(CSBUILD_FOUND FALSE)
endif()

if(NOT CSHARP_PLATFORM AND NOT DotNetCore_FOUND)
    message(FATAL_ERROR "CSHARP_PLATFORM not set")
endif()

if(NOT CSHARP_TARGET_FRAMEWORK)
    message(FATAL_ERROR "CSHARP_TARGET_FRAMEWORK not set")
endif()

if(CSBUILD_FOUND)
    message(STATUS "Using Framework: ${CSHARP_TARGET_FRAMEWORK}")
    if(DotNetCore_FOUND)
        message(STATUS "Using Framework: ${CSHARP_TARGET_FRAMEWORK}")
        message(STATUS "Using Runtime: ${DotNetCore_RUNTIME}")
    else()
        find_program(NUGET_EXE nuget)
        set(RESTORE_EXE ${NUGET_EXE})
        message(STATUS "Using Framework: v${CSHARP_TARGET_FRAMEWORK_VERSION}")
        message(STATUS "Using Platform: ${CSHARP_PLATFORM}")
    endif()
    set(CSBUILD_CSPROJ_IN "${dotnet_cmake_module_DIR}/Modules/dotnet/${CSBUILD_CSPROJ}.in")
    set(CSBUILD_USE_FILE "${dotnet_cmake_module_DIR}/Modules/dotnet/UseCSharpProjectBuilder.cmake")
endif()
