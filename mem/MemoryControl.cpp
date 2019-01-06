#include "MemoryControl.h"
#include <utility>

using namespace std;

MemoryControl::MemoryControl ()
{
    Global = new Environment();
}

bool MemoryControl::defineConstant (string name, Point* value)
{
    return Global->define(name, value);
}

void MemoryControl::printConstants ()
{
    Global->printAll();
}