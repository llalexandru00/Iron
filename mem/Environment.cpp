#include "Environment.h"
#include <utility>
#include <iostream>

using namespace std;

Environment::Environment ()
{

}

bool Environment::has(string name)
{
    return env.find(name)!=env.end();
}

bool Environment::define(string name, Point* value)
{
    if (has(name))
        return false;
    env[name] = value;
    return true;
}

void Environment::printAll()
{
    for (auto i : env)
        cout<<i.first<<" -> "<<i.second->toInt()<<'\n';
}