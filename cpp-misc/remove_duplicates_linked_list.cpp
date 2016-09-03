struct Node {
    int data;
    struct Node* next;
}

Node* remove_dups(Node* head) {
    if (nullptr == head || nullptr == head->next) {
        return head;
    }
    
    auto parent = head;
    auto cursor = head->next;
    auto last_data = head->data;
    do {
        if (last_data == cursor->data) {
            // duplicate value, delete what cursor is pointing too
            parent->next = cursor->next;
            // do not advance the parent
        } else {
            last_data = cursor->data;
            // advance the parent
            parent = cursor;
        }
        cursor = cursor->next;
    } while(nullptr != cursor);
    return head;
}
