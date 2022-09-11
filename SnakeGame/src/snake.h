#include <SFML/Graphics.hpp>

class Snake{
    public:
        Snake(sf::RenderWindow *, int, int, int **&);
        int moveSnake(int, int **&);
        void drawSnake();
        void setTurnSnake(int);
        int getDirection();
        void dec_snake_length(int, int, int **&);
        void resetSnake(int, int **&);

    private:
        sf::RenderWindow *window;
        int turn_direction; // направление поворота
        int direction;
        std::vector<sf::RectangleShape> snake_body;
        
        struct position {
            int x;
            int y;
        };

        std::vector<position> snake_pos;
        sf::Color colorHead;
        sf::Color colorBody;
        int snake_length;
        int fldsize;
        position last_pos_tail;
        sf::RectangleShape rectangle;

        void inc_snake_length(int, int, int, sf::Color, int **&);
        int checkIntersections(int, int, int **&);
};