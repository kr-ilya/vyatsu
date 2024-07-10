#include "snake.h"
#include <iostream>
#include <algorithm>

Snake::Snake(sf::RenderWindow *w, int cell_size, int field_size, int **&field){
    int x_pos, y_pos, x_pos_window, y_pos_window;
    fldsize = field_size;
    window = w;
    snake_length = 0;

    // направление движения при повороте
    // (0-nothing; 1-U; 2-R; 3-D; 4-L)
    turn_direction = 0;
    direction = 2; // текущее направление движения
    colorHead = sf::Color::Yellow;
    colorBody = sf::Color::Green;

    rectangle = sf::RectangleShape { sf::Vector2f(cell_size, cell_size) };

    // голова
    x_pos = fldsize/2;
    y_pos = fldsize/2;
    inc_snake_length(x_pos, y_pos, cell_size, colorHead, field);
    
    //ячейка тела
    x_pos = fldsize/2 - 1;
    y_pos = fldsize/2;
    inc_snake_length(x_pos, y_pos, cell_size, colorBody, field);
    last_pos_tail = {x_pos-1, y_pos};

}

void Snake::drawSnake(){
    for(int i = 0; i < snake_length; i++){
        window->draw(snake_body[i]);
    }
}

void Snake::inc_snake_length(int x_pos, int y_pos, int cell_size, sf::Color color, int **&field){
    int x_pos_window, y_pos_window;
    x_pos_window = x_pos * cell_size;
    y_pos_window = y_pos * cell_size;
    rectangle.setPosition(x_pos_window, y_pos_window);
    rectangle.setFillColor(color);
    snake_body.push_back(rectangle);
    snake_pos.push_back({x_pos, y_pos});
    field[x_pos][y_pos] = 1;
    snake_length++;
}

void Snake::dec_snake_length(int damage, int cell_size, int **&field){
    int del_num, x_pos, y_pos, i_del_num;

    i_del_num = snake_length - 2;
    del_num = std::min(i_del_num, damage);
    
    for(int i = 0; i < del_num; i++){
        snake_body.pop_back();
        x_pos = snake_pos.back().x;
        y_pos = snake_pos.back().y;
        field[x_pos][y_pos] = 0;
        snake_pos.pop_back();
        snake_length--;
    }    
}

int Snake::checkIntersections(int dx, int dy, int **&field){
    int spx, spy;
    // пересечения с границами поля
    spx = snake_pos[0].x + dx;
    spy = snake_pos[0].y + dy;

    if(spx >= fldsize || spx < 0){
        return 1;
    }else if(spy >= fldsize || spy < 0){
        return 1;
    }

    if(field[spx][spy] != 0){
        // пересечение с телом змеи
        if(field[spx][spy] == 1){
            return 1;
        // пересечение с яблоком
        }else if(field[spx][spy] == 2){
            field[spx][spy] = 0;
            return 2;
        // пересечение с молнией
        }else if(field[spx][spy] == 3){
            field[spx][spy] = 0;
            return 3;
        // пересечение с грибом
        }else{
            field[spx][spy] = 0;
            return 4;
        }
    }

    return 0;
}

int Snake::moveSnake(int cell_size, int **&field){
    int x_pos, y_pos, x_pos_window, y_pos_window;
    int dx, dy, tmp_x, tmp_y;
    int current_direction, intersected;
    int return_val = 0;

    direction = (turn_direction != 0) ? turn_direction : direction;
    turn_direction = 0;
    switch (direction) {
    case 1: //up
        dx = 0;
        dy = -1;
        break;
    case 2: //right
        dx = 1;
        dy = 0;
        break;
    case 3: // down
        dx = 0;
        dy = 1;
        break;
    case 4: //left
        dx = -1;
        dy = 0;
        break;
    }
    
    intersected = checkIntersections(dx, dy, field); 
    
    //проверка на пересечение
    if(intersected != 0){
        // со стеной
        if (intersected == 1){
            return 1;

        // с грибом
        }else if(intersected == 4){
            return 4;

        // с молнией или яблоком
        }else{
            // увеличение змеи
            x_pos = last_pos_tail.x;
            y_pos = last_pos_tail.y;
            inc_snake_length(x_pos, y_pos, cell_size, colorBody, field);
            return_val = intersected;
        }
    }
    
    // перемещение хвоста
    tmp_x = snake_pos[snake_length-1].x;
    tmp_y = snake_pos[snake_length-1].y;
    field[tmp_x][tmp_y] = 0;
    last_pos_tail = {tmp_x, tmp_y};

    //перемещение тела
    for(int i = snake_length-1; i > 0; i--){
        x_pos_window = snake_body[i-1].getPosition().x;
        y_pos_window = snake_body[i-1].getPosition().y;
        snake_body[i].setPosition(x_pos_window, y_pos_window);
        snake_pos[i] = snake_pos[i-1];
    }

    // перемещение головы
    x_pos_window = snake_body[0].getPosition().x + dx*cell_size;
    y_pos_window = snake_body[0].getPosition().y + dy*cell_size;
    snake_body[0].setPosition(x_pos_window, y_pos_window);
    snake_pos[0].x += dx;
    snake_pos[0].y += dy;
    field[snake_pos[0].x][snake_pos[0].y] = 1;

    return return_val;
}

void Snake::setTurnSnake(int turn){
    turn_direction = turn;
}

int Snake::getDirection(){
    return direction;
}

void Snake::resetSnake(int cell_size, int**& field){
    int x_pos, y_pos;
    direction = 2;
    turn_direction = 0;
    snake_body.clear();
    snake_pos.clear();
    snake_length = 0;

    // голова
    x_pos = fldsize/2;
    y_pos = fldsize/2;
    inc_snake_length(x_pos, y_pos, cell_size, colorHead, field);
    
    //ячейка тела
    x_pos = fldsize/2 - 1;
    y_pos = fldsize/2;
    inc_snake_length(x_pos, y_pos, cell_size, colorBody, field);
    last_pos_tail = {x_pos-1, y_pos};
}