#include <stack>
#include <map>
#include "Environment.h"
#include <utility>

using namespace std;

class MemoryControl {
    Environment* Global;
    stack<Environment*> Stack;

    public:
        MemoryControl();
        bool defineConstant(string name, Point* value);
        void printConstants();
};