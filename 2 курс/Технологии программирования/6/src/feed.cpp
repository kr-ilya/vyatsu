#include "feed.h"
#include <iostream>

Feed::Feed(sf::RenderWindow *w, int field_size){
    window = w;
    fldsize = field_size;
    scope = 50;
    
    if(!txtr.loadFromFile("./img/apple.png")){
        std::cout << "img apple.png load error" << std::endl;
    }
    sprt.setTexture(txtr);
}

void Feed::set_feed(int **&field, int cell_size, int field_size, int type_feed){
    struct position
    {
        int x;
        int y;
    };

    position rand_coords;
    std::vector<position> coords;

    for(int i = 0; i < field_size; i++){
        for(int j = 0; j < field_size; j++){
            if(field[i][j] == 0){
                coords.push_back({i, j});
            }
        }
    }

    rand_coords = coords[std::rand() % (coords.size()-1)];
    field[rand_coords.x][rand_coords.y] = type_feed;
    sprt.setPosition(rand_coords.x*cell_size, rand_coords.y*cell_size);
}

void Feed::drawFeed(){
    window->draw(sprt);
}

void Feed::set_scope(int sc){
    scope = sc;
}

int Feed::get_scope(){
    return scope;
}

Accelerator::Accelerator(sf::RenderWindow *w, int field_size){
    window = w;
    fldsize = field_size;
    bonusScope = 200;

    if(!txtr.loadFromFile("./img/accelerator.png")){
        std::cout << "img accelerator.png load error" << std::endl;
    }
    sprt.setTexture(txtr);
}

void Accelerator::set_scope(int sc){
    bonusScope = sc;
}

int Accelerator::get_scope(){
    return bonusScope;
}

void Accelerator::setBoost(){
    int b[3] = { 100, 150, 200 };
    boost = b[std::rand() % 3];
}

int Accelerator::getBoost(){
    return boost;
}

Grib::Grib(sf::RenderWindow *w, int field_size){
    window = w;
    fldsize = field_size;
    fineScope = -200;

    if(!txtr.loadFromFile("./img/grib.png")){
        std::cout << "img grib.png load error" << std::endl;
    }
    sprt.setTexture(txtr);
}

void Grib::set_scope(int sc){
    fineScope = sc;
}

int Grib::get_scope(){
    return fineScope;
}

void Grib::setDamage(){
    int d[3] = { 1, 3, 5 };
    damage = d[std::rand() % 3];
}

int Grib::getDamage(){
    return damage;
}