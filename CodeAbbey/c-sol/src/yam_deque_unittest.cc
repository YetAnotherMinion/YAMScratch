#include <stdint.h>
#include <stdio.h>
#include <iomanip>
#include <limits.h>
#include <errno.h>
#include <cstring>

#include "yam_deque.h"
#include "gtest/gtest.h"

/*dummy types for testing copy semantics*/
typedef struct dummy320 {
	uint64_t data[40];
} dummy320;

typedef struct dummy512 {
	uint64_t data[64];
} dummy512;

typedef struct dummy1024 {
	uint64_t data[128];
} dummy1024;

/*initialize all of the deque types*/
DEQUE_INIT(uint8_t)
DEQUE_INIT(uint16_t)
DEQUE_INIT(uint32_t)
DEQUE_INIT(uint64_t)
DEQUE_INIT(dummy320)
DEQUE_INIT(dummy512)
DEQUE_INIT(dummy1024)

TEST(DequeTest, PageSize) {
	EXPECT_EQ(512, PAGE_CELLS(uint8_t));
	EXPECT_EQ(256, PAGE_CELLS(uint16_t));
	EXPECT_EQ(128, PAGE_CELLS(uint32_t));
	EXPECT_EQ(64, PAGE_CELLS(uint64_t));
	EXPECT_EQ(2, PAGE_CELLS(dummy320));
	EXPECT_EQ(1, PAGE_CELLS(dummy512));
	EXPECT_EQ(1, PAGE_CELLS(dummy1024));
}

/*
* NOTE: because we are using macros to implement type genericity,
* we cannot use TYPED_TEST because the macro will just expand to
* error: unknown type name 'deque_TypeParam'
*/
TEST(DequeTest, NewDeque_uint8) {
	Deque(uint8_t)* d;
	d = (Deque(uint8_t)*)newDeque(uint8_t);
	EXPECT_TRUE(NULL != d);
	
}

TEST(DequeTest, NewDeque_uint16) {
	Deque(uint16_t)* d;
	d = (Deque(uint16_t)*)newDeque(uint16_t);
	EXPECT_TRUE(NULL != d);
}

TEST(DequeTest, NewDeque_uint32) {
	Deque(uint32_t)* d;
	d = (Deque(uint32_t)*)newDeque(uint32_t);
	EXPECT_TRUE(NULL != d);
}
TEST(DequeTest, NewDeque_uint64) {
	Deque(uint64_t)* d;
	d = newDeque(uint64_t);
	EXPECT_TRUE(NULL != d);
}

TEST(DequeTest, NewDeque_dummy320) {
	Deque(dummy320)* d;
	d = (Deque(dummy320)*)newDeque(dummy320);
	EXPECT_TRUE(NULL != d);
}

TEST(DequeTest, NewDeque_dummy512) {
	Deque(dummy512)* d;
	d = (Deque(dummy512)*)newDeque(dummy512);
	EXPECT_TRUE(NULL != d);
}

TEST(DequeTest, NewDeque_dummy1024) {
	Deque(dummy1024)* d;
	d = (Deque(dummy1024)*)newDeque(dummy1024);
	EXPECT_TRUE(NULL != d);
}

