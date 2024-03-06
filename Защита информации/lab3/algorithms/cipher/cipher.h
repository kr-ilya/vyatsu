// Шифр А1Я33

#ifndef CIPHER_H
#define CIPHER_H

#include <string>
#include <sstream>
#include <unordered_map>

class Cipher {
public:
    static std::wstring decode(std::string input) {
        std::istringstream iss(input);
        std::string val;
        std::wstring result;

        while(std::getline(iss, val, '-')){
            if (!val.empty()) {
                int number = std::stoi(val);
                if (number > 0 && number < 33) {
                    result += letters[number-1];
                }
            }
        }
        return result;
    }

    static std::string encode(std::wstring input) {
        std::string result;
        for (wchar_t ch : input) {
            if ((ch >= 0x0430 && ch <= 0x044F) || ch == L'ё') {
                result += std::to_string(letter_indexs[ch]) + "-";
            }
        }

        if (!result.empty())
            result.pop_back();
        return result;
    };

private:
    static inline wchar_t letters[33] = { L'а', L'б', L'в', L'г', L'д', L'е', L'ё', L'ж', L'з', L'и', L'й', L'к', L'л', L'м', L'н', L'о', L'п', L'р', L'с', L'т', L'у', L'ф', L'х', L'ц', L'ч', L'ш', L'щ', L'ъ', L'ы', L'ь', L'э', L'ю', L'я' };
    static inline std::unordered_map<wchar_t, unsigned int> letter_indexs = {
        {L'а', 1}, {L'б', 2}, {L'в', 3}, {L'г', 4}, {L'д', 5}, {L'е', 6}, {L'ё', 7}, {L'ж', 8}, {L'з', 9}, {L'и', 10},
        {L'й', 11}, {L'к', 12}, {L'л', 13}, {L'м', 14}, {L'н', 15}, {L'о',16}, {L'п', 17}, {L'р', 18}, {L'с', 19}, {L'т', 20},
        {L'у', 21}, {L'ф', 22}, {L'х', 23}, {L'ц', 24}, {L'ч', 25}, {L'ш', 26}, {L'щ', 27}, {L'ъ', 28}, {L'ы', 29}, {L'ь', 30},
        {L'э', 31}, {L'ю', 32}, {L'я', 33}
    };
};


#endif // CIPHER_H
