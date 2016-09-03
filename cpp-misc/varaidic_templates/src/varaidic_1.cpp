#include <iostream>
#include <cassert>

template< bool A>
int reversed_binary_value() {
    return A ? 1 : 0;
}

template<bool A, bool B, bool... digits>
int reversed_binary_value() {
    return reversed_binary_value<A>() \
            + (reversed_binary_value<B, digits...>()<<1);
}

int main() {
    assert((1 == reversed_binary_value<1>()));
    assert((0 == reversed_binary_value<0>()));
    assert((2 == reversed_binary_value<0, 1>()));
    assert((1 == reversed_binary_value<1, 0>()));
    assert((0 == reversed_binary_value<0, 0>()));
    assert((20 == reversed_binary_value<0, 0, 1, 0, 1>()));
    return 0;
}
