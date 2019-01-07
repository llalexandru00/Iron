#include "Environment.h"
#include <utility>
#include <iostream>

using namespace std;

Environment::Environment ()
{

}
Environment::~Environment ()
{
    for (auto i : env)
        delete(i.second);
    env.clear();
}

bool Environment::has(string name)
{
    return env.find(name)!=env.end();
}

Point* Environment::get(string name)
{
    if (!has(name))
        return new Point(0, 0);
    return env[name];
}

void Environment::define(string name, Point* value)
{
    env[name] = value;
}

void Environment::printAll()
{
    for (auto i : env)
        cout<<i.first<<" -> "<<i.second->toInt()<<'\n';
}