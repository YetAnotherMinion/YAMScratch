#ifdef __cplusplus
extern "C" {
#endif

#ifndef YAM_DEQUE
#define YAM_DEQUE 1

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define MIN_PAGE_SIZE 512
#define PAGE_CELLS(TYPE)														\
	(((sizeof (TYPE)) < MIN_PAGE_SIZE) ? ( (MIN_PAGE_SIZE % (sizeof (TYPE))) ? (MIN_PAGE_SIZE / (sizeof (TYPE)))+1 : MIN_PAGE_SIZE / (sizeof (TYPE)) ) : 1)

#define DEQUE_INIT(TYPE)													\
	struct deque_node_##TYPE;												\
	typedef struct deque_node_##TYPE {										\
		struct deque_node_##TYPE * next;									\
		struct deque_node_##TYPE * prev;									\
		TYPE* page;															\
	} deque_node_##TYPE;													\
	/*head node*/															\
	typedef struct {														\
		deque_node_##TYPE* begin;											\
		deque_node_##TYPE* end;												\
		unsigned _begin_offset;												\
		unsigned _end_offset;												\
		unsigned _size;														\
	} deque_##TYPE;															\
	static deque_##TYPE * init_deque_##TYPE() {								\
		deque_##TYPE* head;													\
		head = (deque_##TYPE *)malloc(sizeof (*head));						\
		if(head == NULL) return NULL;										\
		/*create at least one page*/										\
		deque_node_##TYPE* first_page;										\
		first_page = (deque_node_##TYPE *)malloc(sizeof (*first_page));		\
		if(first_page == NULL) return NULL;									\
		first_page->page = (TYPE *)malloc( PAGE_CELLS(TYPE) * sizeof (TYPE));\
		if(first_page->page == NULL) {										\
			free(first_page);												\
			free(head);														\
			return NULL;													\
		}																	\
		first_page->prev = NULL;											\
		first_page->next = NULL;											\
		head->begin = first_page;											\
		head->end = first_page;												\
		head->_begin_offset = 0;											\
		head->_end_offset = 0;												\
		head->_size = 0;													\
		return head;														\
	}
	/*
	static void destroy_deque_##TYPE(deque_##TYPE * head) {

	}
	static void clear_deque_##TYPE(deque_##TYPE * head) {

	}
	static void push_back_deque_##TYPE(deque_##TYPE * head, TYPE val) {

	}
	static void push_front_deque_##TYPE(deque_##TYPE * head, TYPE val) {

	}
	static TYPE pop_back_dequeu_##TYPE(deque_##TYPE * head) {
		if(head->_begin_offset) {

		}
		TYPE tmp;
		return tmp;

	}
	static TYPE pop_front_deque_##TYPE(deque_##TYPE * head) {
		TYPE tmp;
		return tmp;
	}
	*/
	static TYPE* at_deque_##TYPE(deque_##TYPE* head, unsigned long index) {
		/*returns a pointer to element at index, if the index is out of
		* bounds, returns NULL, and sets errno to EINVAL*/
		if(index < head->_size) {
			unsigned long tmp_offset, page_offset, ii;
			/*index is in first half of deque*/
			if(index <= (head->_size / 2)) {
				tmp_offset = PAGE_CELLS(TYPE) - head->_end_offset;
				if(index < tmp_offset) {
					/*element we seek is in beginning page*/
					return head->begin->page + (head->_end_offset + index);
				}
				/*find the new offset from one page past the beginning page*/
				tmp_offset = index - tmp_offset;
				page_offset = tmp_offset / PAGE_CELLS(TYPE);
				/*now tmp offset is the correct offset for one page*/
				tmp_offset = tmp_offset % PAGE_CELLS(TYPE);
				/*move to that page*/
				deque_node_##TYPE * cursor;
				cursor = head->begin;
				/*walk cursor up linked list of pages*/
				for(ii = 0; ii < page_offset; ++ii){
					cursor = cursor->next;
				}
				return cursor->page + tmp_offset;
			} else {
				/*check that element is not on last page*/
				tmp_offset = head->_size - head->_end_offset;
			}
		} else {
			return NULL;
		}
	}

#endif

#define Deque(TYPE) deque_##TYPE
#define newDeque(TYPE) init_deque_##TYPE()
#define deque_destroy(TYPE, ptr) destroy_deque_##TYPE(ptr)
#define deque_push_back(TYPE, ptr, val) push_back_deque_##TYPE(ptr, val)
#define deque_push_front(TYPE, ptr, val) push_front_deque_##TYPE(ptr, val)
#define deque_pop_back(TYPE, ptr) pop_back_dequeu_##TYPE(ptr)
#define deque_pop_front(TYPE, ptr) pop_front_deque_##TYPE(ptr)
#define deque_clear(TYPE, ptr) clear_deque_##TYPE(ptr)
#define deque_at(TYPE, ptr, index) at_deque_##TYPE(ptr, index)

#ifdef __cplusplus
}
#endif
