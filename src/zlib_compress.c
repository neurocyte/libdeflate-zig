/*
 * zlib_compress.c
 *
 * Generate DEFLATE-compressed data in the zlib wrapper format.
 *
 * This file has no copyright assigned and is placed in the Public Domain.
 */

#include "libdeflate.h"

#include "adler32.h"
#include "deflate_compress.h"
#include "unaligned.h"
#include "zlib_constants.h"

LIBEXPORT size_t
zlib_compress(struct deflate_compressor *c, const void *in, size_t in_size,
	      void *out, size_t out_nbytes_avail)
{
	u8 *out_next = out;
	u16 hdr;
	unsigned compression_level;
	unsigned level_hint;
	size_t deflate_size;

	if (out_nbytes_avail <= ZLIB_MIN_OVERHEAD)
		return 0;

	/* 2 byte header: CMF and FLG  */
	hdr = (ZLIB_CM_DEFLATE << 8) | (ZLIB_CINFO_32K_WINDOW << 12);
	compression_level = deflate_get_compression_level(c);
	if (compression_level < 2)
		level_hint = ZLIB_FASTEST_COMPRESSION;
	else if (compression_level < 6)
		level_hint = ZLIB_FAST_COMPRESSION;
	else if (compression_level < 8)
		level_hint = ZLIB_DEFAULT_COMPRESSION;
	else
		level_hint = ZLIB_SLOWEST_COMPRESSION;
	hdr |= level_hint << 6;
	hdr |= 31 - (hdr % 31);

	put_unaligned_u16_be(hdr, out_next);
	out_next += 2;

	/* Compressed data  */
	deflate_size = deflate_compress(c, in, in_size, out_next,
					out_nbytes_avail - ZLIB_MIN_OVERHEAD);
	if (deflate_size == 0)
		return 0;
	out_next += deflate_size;

	/* ADLER32  */
	put_unaligned_u32_be(adler32(in, in_size), out_next);
	out_next += 4;

	return out_next - (u8 *)out;
}
