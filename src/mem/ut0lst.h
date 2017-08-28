#ifndef __UT0LST_H__
#define __UT0LST_H__

template <typename Type>
struct ut_list_node {
	Type *prev;
	Type *next;
	void reverse() {
		Type *tmp = prev;
		prev = next;
		next = tmp;
	}
};
#define UT_LIST_NODE_T(t) ut_list_node<t>

#endif
