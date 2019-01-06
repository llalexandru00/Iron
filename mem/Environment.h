#include <map>
#include <utility>
#include "../helper/Point.h"

using namespace std;

class Environment {
    map <string, Point* > env;
    public:
        Environment();
        bool has(string name); // returns true if variable already defined, false otherwise
        bool define(string name, Point* value); // returns true if succeeds, false otherwise

        
        void printAll();
};