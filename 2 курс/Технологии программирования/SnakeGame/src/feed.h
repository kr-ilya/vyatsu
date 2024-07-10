#include <SFML/Graphics.hpp>

class Feed {
    public:
        Feed(sf::RenderWindow *, int);
        Feed() = default;
        void set_feed(int **&, int, int, int);
        virtual void set_scope(int);
        virtual int get_scope();
        void drawFeed();
        sf::RenderWindow *window;
        int fldsize;
        sf::Texture txtr;
        sf::Sprite sprt;
    private:
        int scope;
};

class Accelerator : public Feed {
    public:
        Accelerator(sf::RenderWindow *, int);
        Accelerator() = default;
        
        // перекрытые
        void set_scope(int);
        int get_scope();

        //унаследованные
        // void drawFeed();
        // void set_feed(int **&, int, int, int);

        // собственные
        int getBoost();
        void setBoost();
    private:
        int boost;
        int bonusScope;
};

class Grib : public Feed {
    public:
        Grib(sf::RenderWindow *, int);
        Grib() = default;
        
        // перекрытые
        void set_scope(int);
        int get_scope();

        // унаследованные
        // void drawFeed();
        // void set_feed(int **&, int, int, int);
        
        // собственные
        void setDamage();
        int getDamage();

    private:
        int damage;
        int fineScope;
};