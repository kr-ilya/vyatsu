#include <SFML/Graphics.hpp>
#include <iostream>
#include "snake.h"
#include "feed.h"
#include <ctime>

const int def_speed = 300; //ms
const int field_size = 20;
const int cell_size = 30;
bool game_started = false;
int speed = def_speed; 
int speed_times = 5;
int **field;
int scope = 0;
int wnd_width = 600;
int wnd_height = 600;
bool game_over = false;
bool start_menu = true;

sf::Font font;
sf::Text text_score;
sf::Text text_gameover;
sf::Text text_start;

void draw_scope(sf::RenderWindow &window, int sc){
    text_score.setString("Score: " + std::to_string(sc));
    text_score.setPosition(wnd_width - text_score.getLocalBounds().width - 20, 10);
    
    window.draw(text_score);
}

int main()
{     
    std::srand(time(0));

    sf::RenderWindow window(sf::VideoMode(wnd_width, wnd_height), "SnakeGame", sf::Style::Close | sf::Style::Titlebar);
    window.setVerticalSyncEnabled(true);
    window.setFramerateLimit(60);  

    font.loadFromFile("font/Ampero-Regular.ttf");

    text_score.setFont(font);
    text_score.setCharacterSize(18);
    text_score.setFillColor(sf::Color::White);

    text_gameover.setFont(font);
    text_gameover.setCharacterSize(32);
    text_gameover.setFillColor(sf::Color::White);
    text_gameover.setString("Game Over (r - restart)");
    text_gameover.setPosition((wnd_width - text_gameover.getLocalBounds().width) / 2, (wnd_height - text_gameover.getLocalBounds().height) / 2);

    text_start.setFont(font);
    text_start.setCharacterSize(32);
    text_start.setFillColor(sf::Color::White);
    text_start.setString("Press <Space> to start");
    text_start.setPosition((wnd_width - text_start.getLocalBounds().width) / 2, (wnd_height - text_start.getLocalBounds().height) / 2);

    field = new int* [field_size];
    for(int i = 0; i < field_size; i++){
        field[i] = new int [field_size];
        for(int j = 0; j < field_size; j++){
            field[i][j] = 0;
        }      
    }
    
    Snake* snake = new Snake(&window, cell_size, field_size, field);
    Accelerator* accelerator = new Accelerator(&window, field_size);
    Grib* grib = new Grib(&window, field_size);

    Feed* feed = new Feed(&window, field_size);

    Feed** mas = new Feed* [3];

    mas[0] = feed;
    mas[1] = accelerator;
    mas[2] = grib;

    std::vector<int> snake_direction_queue;
    int last_snake_direction, move_snake_result;
    int dmg;
    int r = 0;

    feed->set_feed(field, cell_size, field_size, 2);

    while (window.isOpen())
    {   
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();

            if (event.type == sf::Event::KeyPressed){
                last_snake_direction = !snake_direction_queue.empty() ? snake_direction_queue[0] : snake->getDirection();
                switch (event.key.code) {
                    case sf::Keyboard::Up:
                        if(last_snake_direction != 3 && last_snake_direction != 1){
                            if (snake_direction_queue.size() < 2){
                                snake_direction_queue.insert(snake_direction_queue.begin(), 1);
                            }
                        }
                    break;
                    case sf::Keyboard::Right:
                        if(last_snake_direction != 4 && last_snake_direction != 2){
                            if (snake_direction_queue.size() < 2){
                                snake_direction_queue.insert(snake_direction_queue.begin(), 2);
                            }
                        }
                    break;
                    case sf::Keyboard::Down:
                        if(last_snake_direction != 1 && last_snake_direction != 3){
                            if (snake_direction_queue.size() < 2){
                                snake_direction_queue.insert(snake_direction_queue.begin(), 3);
                            }
                        }
                    break;
                    case sf::Keyboard::Left:
                        if(last_snake_direction != 2 && last_snake_direction != 4){
                            if (snake_direction_queue.size() < 2){
                                snake_direction_queue.insert(snake_direction_queue.begin(), 4);
                            }
                        }
                    break;
                    case sf::Keyboard::R:
                        if(game_over){
                            scope = 0;
                            speed = def_speed;

                            for(int i = 0; i < field_size; i++){
                                for(int j = 0; j < field_size; j++){
                                    field[i][j] = 0;
                                }      
                            }

                            snake->resetSnake(cell_size, field);
                            feed->set_feed(field, cell_size, field_size, 2);

                            r = 0;
                            game_started = true;
                            game_over = false;
                        }
                    break;
                    case sf::Keyboard::Space:
                        if(!game_started){
                            game_started = true;
                        }
                    break;
                }
            }
        }

        if(!snake_direction_queue.empty()){
            snake->setTurnSnake(snake_direction_queue.back());
            snake_direction_queue.pop_back();
        }

        if(start_menu){
            window.clear();
            window.draw(text_start);
            start_menu = false;
        }
        

        if (game_started){
            window.clear();
            draw_scope(window, scope);

            move_snake_result = snake->moveSnake(cell_size, field);
            if(move_snake_result != 0){
                // столкновение
                if(move_snake_result == 1){
                    game_started = false;
                    game_over = true;
                    window.draw(text_gameover);
                // еда
                }else{
                    // ускорение
                    if(move_snake_result == 3){
                        scope += mas[1]->get_scope();
                        
                        Accelerator* rrr = (Accelerator*)mas[1];

                        speed = rrr->getBoost();
                        speed_times = 3;
                    // гриб
                    }else if (move_snake_result == 4){
                        scope = std::max(scope+grib->get_scope(), 0);
                        dmg = grib->getDamage();
                        snake->dec_snake_length(dmg, cell_size, field);
                    // яблоко
                    }else{
                        scope += feed->get_scope();
                        speed_times--;
                        if(speed_times == 0){
                            speed = def_speed;
                        }
                    }

                    r = std::rand() % 3;
                    Accelerator* rrr = (Accelerator*)mas[1];
                    Grib* ttt = (Grib*)mas[2];
                    switch (r)
                    {
                    case 0:
                        feed->set_feed(field, cell_size, field_size, 2);
                        break;
                    case 1:
                        mas[1]->set_feed(field, cell_size, field_size, 3);
                        rrr->setBoost();
                        break;
                    
                    case 2:
                        mas[2]->set_feed(field, cell_size, field_size, 4);
                        ttt->setDamage();
                        break;
                    }
                }
            }
            
            snake->drawSnake();
            
            switch (r)
            {
            case 0:
                feed->drawFeed();
                break;
            case 1:
                mas[1]->drawFeed();
                break;
            case 2:
                mas[2]->drawFeed();
                break;
            }
        }

        window.display();
        sf::sleep(sf::milliseconds(speed));
    }

    return 0;
}