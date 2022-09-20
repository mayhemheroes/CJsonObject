#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include "../CJsonObject.hpp"

int main(int argc, char* argv[])
{
    std::ifstream fin(argv[1]);
    if (fin.good())
    {
        neb::CJsonObject oJson;
        std::stringstream ssContent;
        ssContent << fin.rdbuf();
        if (oJson.Parse(ssContent.str()))
        {
            std::cout << oJson.ToString() << std::endl;
        }
        else
        {
            std::cerr << "parse json error" << "\n";// << ssContent.str() << std::endl;
            return 1;
        }
        fin.close();
    }
    return 0;
}
