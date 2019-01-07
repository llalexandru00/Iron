#include <vector>
#include <map>
#include "Environment.h"
#include <utility>

using namespace std;

class MemoryControl {
    Environment* Global;
    vector<Environment*> Stack;

    public:
        MemoryControl();
        bool defineConstant(string name, Point* value);
        bool assign(string name, Point* value);
        Point* get(string name);

        void enterEnv();
        bool exitEnv();


        void printConstants();
        void printAll();
};