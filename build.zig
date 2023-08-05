const std = @import("std");

const source_files = [_][]const u8{
    // "common_defs.h",
    // "libdeflate.h",
    "lib/arm/cpu_features.c",
    // "lib/arm/cpu_features.h",
    // "lib/cpu_features_common.h",
    // "lib/deflate_constants.h",
    // "lib/lib_common.h",
    "lib/utils.c",
    "lib/x86/cpu_features.c",
    // "lib/x86/cpu_features.h",

    // LIBDEFLATE_COMPRESSION_SUPPORT
    // "lib/arm/matchfinder_impl.h",
    // "lib/bt_matchfinder.h",
    "lib/deflate_compress.c",
    // "lib/deflate_compress.h",
    // "lib/hc_matchfinder.h",
    // "lib/ht_matchfinder.h",
    // "lib/matchfinder_common.h",
    // "lib/x86/matchfinder_impl.h",

    // LIBDEFLATE_DECOMPRESSION_SUPPORT
    // "lib/decompress_template.h",
    "lib/deflate_decompress.c",
    // "lib/x86/decompress_impl.h",

    // LIBDEFLATE_ZLIB_SUPPORT
    "lib/adler32.c",
    // "lib/adler32_vec_template.h",
    // "lib/arm/adler32_impl.h",
    // "lib/x86/adler32_impl.h",
    // "lib/zlib_constants.h",
    // LIBDEFLATE_COMPRESSION_SUPPORT
    "lib/zlib_compress.c",
    // LIBDEFLATE_DECOMPRESSION_SUPPORT
    "lib/zlib_decompress.c",

    // LIBDEFLATE_GZIP_SUPPORT
    // "lib/arm/crc32_impl.h",
    // "lib/arm/crc32_pmull_helpers.h",
    // "lib/arm/crc32_pmull_wide.h",
    // "lib/crc32.c",
    // "lib/crc32_multipliers.h",
    // "lib/crc32_tables.h",
    // "lib/gzip_constants.h",
    // "lib/x86/crc32_impl.h",
    // "lib/x86/crc32_pclmul_template.h",
    // LIBDEFLATE_COMPRESSION_SUPPORT
    "lib/gzip_compress.c",
    // LIBDEFLATE_DECOMPRESSION_SUPPORT
    "lib/gzip_decompress.c",
};

const flags = [_][]const u8{};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "deflate",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "." });
    lib.addCSourceFiles(&source_files, &flags);

    b.installArtifact(lib);
    lib.installHeader("libdeflate.h", "libdeflate.h");
}
