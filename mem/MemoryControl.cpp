#include "MemoryControl.h"
#include <utility>
#include <iostream>

using namespace std;

MemoryControl::MemoryControl ()
{
    Global = new Environment();
}

bool MemoryControl::defineConstant (string name, Point* value)
{
    if (Global->has(name))
        return false;
    Global->define(name, new Point(value->x, value->y));
    return true;
}

bool MemoryControl::assign (string name, Point* value)
{
    if (Stack.empty())
        return false;
    Environment* topEnv = Stack.back(); 
    topEnv->define(name, new Point(value->x, value->y));
    return true;
}

Point* MemoryControl::get(string name)
{
    if (!Stack.empty())
    {
        Environment* topEnv = Stack.back();
        if (topEnv->has(name))
            return topEnv->get(name);
    }
    if (Global->has(name))
        return Global->get(name);
    return new Point(0, 0);
}

void MemoryControl::enterEnv()
{
    Environment* env = new Environment();
    Stack.push_back(env);
}

bool MemoryControl::exitEnv()
{
    if (Stack.empty())
        return false;
    Environment* topEnv = Stack.back(); 
    Stack.pop_back();
    delete(topEnv);
    return true;
}

void MemoryControl::printConstants ()
{
    Global->printAll();
}

void MemoryControl::printAll()
{
    cout<<"Globale:\n";
    Global->printAll();
    cout<<"Locale:\n";
    Environment* topEnv = Stack.back(); 
    topEnv->printAll();
    cout<<"\n";
}