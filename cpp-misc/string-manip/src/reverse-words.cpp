#include <iostream>
#include <string>
#include <locale>


void reverse_string(char* begin, char* end) {
    if (begin == nullptr || end == nullptr) {
        return;
    }
    while (begin != end) {
        begin++;
    }
}

void reverse_string(std::string::iterator begin, std::string::iterator end) {
    while (begin != end) {
        end--;
        /* swap */
        char tmp = *begin;
        *begin = *end;
        *end = tmp;
        if(begin == end) {
            break;
        }
        begin++;
    }
}

std::string& reverse_words(std::string& str) {
    /* first pass reverses all characters, second pass the unreverses each
     * word */
    reverse_string(str.begin(), str.end());
    auto start_word = str.begin();
    std::locale loc;

    while (start_word != str.end()) {
        while (start_word != str.end() && std::isspace(*start_word)) {
            start_word++;
        }
        auto end_word = start_word;
        while (end_word != str.end() && !std::isspace(*end_word)) {
            end_word++;
        }
        reverse_string(start_word, end_word);
        start_word = end_word;
    }
    /* allow chaining */
    return str;
}

int main(int argc, char* argv[]) {
    std::string foo = "Forsooth, a mighty warrior approaches";
    std::cout << reverse_words(foo) << std::endl;
    return 0;
}
