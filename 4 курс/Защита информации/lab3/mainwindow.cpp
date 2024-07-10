#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "algorithms/cipher/cipher.h"
#include "algorithms/des/descbc.h"
#include "algorithms/sha256/sha256.h"
#include <sstream>
#include <string>
#include <QDebug>
#include <iomanip>


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->radioButton->setChecked(true);
    ui->radioButton_6->setChecked(true);
    this->selectTask(1);

    this->rsa_p = 367;
    this->rsa_q = 571;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::selectTask(int task)
{

    std::string task1text = "Напишите дешифратор для <<ШИФРА А1Я33>> и расшифруйте предоставленную строку:\n"
                    "-19-14-6-18-20-30-15-6-8-5-6-20-10-8-10-9-15-30-8-5-1-20-30-15-6-5-16-13-8-15-1";
    std::string task2text = "Алгоритм шифрования DES\n"
            "Зашифруйте строку: <<Такие люди или тяжело больны, или втайне ненавидят окружающих.>>\n"
            "Алгоритмом DES в режиме сцепления блоков.\n"
            "Ключ для шифрования: 5072200455281895043565588085962829314887838591012107554559394778";

    std::string task3text = "Алгоритм шифрования rsa.\n"
            "Сгенерируйте открытый и закрытый ключи в алгоритме шифрования RSA, выбрав простые числа p = 367 и q = 571.\n"
            "Зашифруйте сообщение: Вещи усиливают ощущение времени.";

    std::string task4text = "Функция хеширования.\n"
            "Реализовать алгоритм криптографической функции – SHA256.\n"
            "Зашифруйте сообщение: В человеке должно быть всё прекрасно: и лицо, и одежда, и душа, и мысли.";

    std::string task5text = "Электронная цифровая подпись.\n"
            "Используя хеш-образ строки: << Дорогой бриллиант дорогой оправы требует.>>\n"
            "И вычислите электронную цифровую подпись по схеме RSA.";

    ui->textEdit->clear();
    ui->textEdit_2->clear();

    ui->label_2->setText(QString("Зашифрованные данные"));

    if (task == 1) {
        ui->textBrowser->setText(QString::fromStdString(task1text));

        ui->pushButton->setText(QString("Зашифровать"));
        ui->pushButton_2->setText(QString("Расшифровать"));

        ui->labelPvalue->setVisible(false);
        ui->labelQvalue->setVisible(false);
        ui->labelKey->setVisible(false);

        ui->lineEditPval->setVisible(false);
        ui->lineEditQval->setVisible(false);
        ui->lineEditKeyN->setVisible(false);
        ui->labelNval->setVisible(false);

        ui->groupBox->setVisible(false);

        ui->textEditKey->setVisible(false);
        ui->pushButton_3->setVisible(false);

        ui->pushButton->setEnabled(true);
        ui->pushButton_2->setEnabled(true);

        ui->label_3->setVisible(false);


    } else if (task == 2){
        ui->textBrowser->setText(QString::fromStdString(task2text));
        ui->pushButton->setText(QString("Зашифровать"));
        ui->pushButton_2->setText(QString("Расшифровать"));
        ui->textEditKey->clear();
        ui->labelPvalue->setVisible(false);
        ui->labelQvalue->setVisible(false);
        ui->lineEditPval->setVisible(false);
        ui->lineEditQval->setVisible(false);
        ui->lineEditKeyN->setVisible(false);
        ui->labelNval->setVisible(false);
        ui->groupBox->setVisible(false);
        ui->pushButton_3->setVisible(false);
        ui->labelKey->setVisible(true);
        ui->textEditKey->setVisible(true);
        ui->pushButton->setEnabled(true);
        ui->pushButton_2->setEnabled(true);

        ui->label_3->setVisible(false);
    } else if (task == 4) {
        ui->textBrowser->setText(QString::fromStdString(task4text));
        ui->pushButton->setText(QString("Захешировать"));
        ui->textEditKey->clear();
        ui->labelPvalue->setVisible(false);
        ui->labelQvalue->setVisible(false);
        ui->lineEditPval->setVisible(false);
        ui->lineEditQval->setVisible(false);
        ui->lineEditKeyN->setVisible(false);
        ui->labelNval->setVisible(false);
        ui->groupBox->setVisible(false);
        ui->pushButton_3->setVisible(false);
        ui->labelKey->setVisible(false);
        ui->textEditKey->setVisible(false);
        ui->pushButton->setEnabled(true);
        ui->pushButton_2->setEnabled(false);
        ui->label_3->setVisible(false);
    } else {
//        RSA
        if (task == 3) {
            ui->textBrowser->setText(QString::fromStdString(task3text));
            ui->label_3->setVisible(false);
//        EDS-RSA (5)
        } else {
            ui->textBrowser->setText(QString::fromStdString(task5text));
            ui->pushButton->setText(QString("Подписать"));
            ui->pushButton_2->setText(QString("Проверить"));
            ui->label_2->setText(QString("Подпись"));
        }
        ui->labelPvalue->setVisible(true);
        ui->labelQvalue->setVisible(true);
        ui->lineEditPval->setVisible(true);
        ui->lineEditQval->setVisible(true);

        if (ui->radioButton_7->isChecked()) {
            ui->lineEditKeyN->setVisible(true);
            ui->labelNval->setVisible(true);
        } else {
            ui->lineEditKeyN->setVisible(false);
            ui->labelNval->setVisible(false);
        }

        ui->groupBox->setVisible(true);
        ui->pushButton_3->setVisible(true);
        ui->labelKey->setVisible(false);
        ui->textEditKey->setVisible(false);

        if (hasRSAprivateKey && hasRSAopenKey && hasRSAnVal) {
            ui->pushButton->setEnabled(true);
            ui->pushButton_2->setEnabled(true);
        } else {
            ui->pushButton->setEnabled(false);
            ui->pushButton_2->setEnabled(false);
        }
    }
}

void MainWindow::on_radioButton_clicked()
{
    this->selectTask(1);
    taskSelected = 1;
}


void MainWindow::on_radioButton_2_clicked()
{
    this->selectTask(2);
    taskSelected = 2;
}


void MainWindow::on_radioButton_3_clicked()
{
    this->selectTask(3);
    taskSelected = 3;
}


void MainWindow::on_radioButton_4_clicked()
{
    this->selectTask(4);
    taskSelected = 4;
}


void MainWindow::on_radioButton_5_clicked()
{
    this->selectTask(5);
    taskSelected = 5;
}


// расшифровать / проверить
void MainWindow::on_pushButton_2_clicked()
{
    if (taskSelected == 1) {
        std::string input = ui->textEdit_2->toPlainText().toStdString();
        ui->textEdit->setPlainText(QString::fromStdWString(Cipher::decode(input)));

//    DES
    } else if (taskSelected == 2) {
        if (ui->textEditKey->toPlainText().isEmpty() || ui->textEdit_2->toPlainText().isEmpty()) {
            return;
        }

        uint64 key = strtoull(ui->textEditKey->toPlainText().toStdString().data(), nullptr, 16);

        QByteArray byteArray = QByteArray::fromHex(ui->textEdit_2->toPlainText().toUtf8());

        std::istringstream iss(byteArray.toStdString());
        std::ostringstream oss;

        uint64 size = byteArray.toStdString().size();
        uint64 blocks = size / 8;
        blocks--;
        iss.seekg(0, std::ios_base::beg);
        uint64 buffer;

        DESCBC des(key);

        for (uint64 i = 0; i < blocks; ++i) {
            iss.read((char*) &buffer, 8);
            buffer = des.decrypt(buffer);
            oss.write((char*) &buffer, 8);
        }

        iss.read((char*) &buffer, 8);
        buffer = des.decrypt(buffer);

        uint8 p = 0;

        while(!(buffer & 0x00000000000000ff)) {
            buffer >>= 8;
            p++;
        }

        buffer >>= 8;
        p++;

        if(p != 8)
            oss.write((char*) &buffer, 8 - p);

        ui->textEdit->setPlainText(QString::fromStdString(oss.str()));
//    RSA
    } else if (taskSelected == 3) {
        std::istringstream iss(ui->textEdit_2->toPlainText().toStdString());
        std::ostringstream oss;
        std::string val;

        std::vector<ULL> input;
        while (std::getline(iss, val, ' ')) {
            if (!val.empty()){
                input.push_back(std::stoi(val, nullptr, 16));
            }
        }


        ULL size = input.size();
        ULL* output = new ULL[size];
        rsa.decrypt(input.data(), size, output, rsa_d, rsa_n);

        std::vector<unsigned char> outres;
        for (ULL i = 0; i < size; ++i) {
            outres.push_back((unsigned char) output[i]);
        }

        oss.write((char*) outres.data(), outres.size());

        ui->textEdit->setPlainText(QString::fromStdString(oss.str()));
//      EDS-RSA check
    } else if (taskSelected == 5) {
        std::string hashRes = SHA256::SHA256(ui->textEdit->toPlainText().toStdString().data());

        std::istringstream iss(ui->textEdit_2->toPlainText().toStdString());
        std::ostringstream oss;
        std::string val;

        std::vector<ULL> input;
        while (std::getline(iss, val, ' ')) {
            if (!val.empty()){
                input.push_back(std::stoi(val, nullptr, 16));
            }
        }

        ULL size = input.size();
        ULL* output = new ULL[size];
        rsa.encrypt(input.data(), size, output, rsa_e, rsa_n);

        std::vector<unsigned char> outres;
        for (ULL i = 0; i < size; ++i) {
            outres.push_back((unsigned char) output[i]);
        }

        oss.write((char*) outres.data(), outres.size());

       if(hashRes.compare(oss.str()) == 0) {
           ui->label_3->setText(QString("ЭЦП ВЕРНА"));
           ui->label_3->setStyleSheet("QLabel { color : green; }");
       } else {
           ui->label_3->setText(QString("ЭЦП НЕ ВЕРНА"));
           ui->label_3->setStyleSheet("QLabel { color : red; }");
       }


        ui->label_3->setVisible(true);
    }
}

// зашифровать / подписать
void MainWindow::on_pushButton_clicked()
{
    if (taskSelected == 1) {
        std::wstring input = ui->textEdit->toPlainText().toStdWString();
        ui->textEdit_2->setPlainText(QString::fromStdString(Cipher::encode(input)));

//    DES
    } else if (taskSelected == 2) {
        if (ui->textEditKey->toPlainText().isEmpty() || ui->textEdit->toPlainText().isEmpty()) {
            return;
        }

        uint64 key = strtoull(ui->textEditKey->toPlainText().toStdString().data(), nullptr, 16);

        std::istringstream iss(ui->textEdit->toPlainText().toStdString());
        std::ostringstream oss;

        uint64 size = ui->textEdit->toPlainText().toStdString().size();
        uint64 blocks = size / 8;
        iss.seekg(0, std::ios_base::beg);
        uint64 buffer;

        DESCBC des(key);

        for (uint64 i = 0; i < blocks; ++i) {
            iss.read((char*) &buffer, 8);
            buffer = des.encrypt(buffer);
            oss.write((char*) &buffer, 8);
        }

        uint64 p = 8 - (size % 8);

        buffer = 0;
        if (p != 0)
            iss.read((char*) &buffer, 8-p);

        uint64 shift_bites = p * 8;
        buffer <<= shift_bites;
        buffer |= (uint64) 0x0000000000000001 << (shift_bites - 1);

        buffer = des.encrypt(buffer);

        oss.write((char*) &buffer, 8);

        std::string encoded = oss.str();

        QByteArray byteArray(encoded.c_str(), static_cast<int>(encoded.length()));
        ui->textEdit_2->setPlainText(byteArray.toHex());

//    RSA
    } else if (taskSelected == 3) {
        std::istringstream iss(ui->textEdit->toPlainText().toStdString());

        ULL size = ui->textEdit->toPlainText().toStdString().size();
        unsigned char* buffer = new unsigned char[size];
        iss.read(reinterpret_cast<char*>(buffer), size);

        ULL* input = new ULL[size];
        ULL* output = new ULL[size];

        for (ULL i = 0; i < size; ++i) {
            input[i] = static_cast<ULL>(buffer[i]);
        }

        rsa.encrypt(input, size, output, rsa_e, rsa_n);

        QString hexString;
        for (ULL i = 0; i < size; ++i) {
            hexString += QString::number((ULL)output[i], 16) + " ";
        }

        if (!hexString.isEmpty())
            hexString.resize(hexString.size() - 1);

        ui->textEdit_2->setPlainText(hexString);
//    SHA256
    } else if (taskSelected == 4) {
        std::string hashRes = SHA256::SHA256(ui->textEdit->toPlainText().toStdString().data());
        ui->textEdit_2->setPlainText(hashRes.data());
//    EDS-RSA
    } else {
        std::string hashRes = SHA256::SHA256(ui->textEdit->toPlainText().toStdString().data());

        std::istringstream iss(hashRes);

        ULL size = hashRes.size();
        unsigned char* buffer = new unsigned char[size];
        iss.read(reinterpret_cast<char*>(buffer), size);

        ULL* input = new ULL[size];
        ULL* output = new ULL[size];

        for (ULL i = 0; i < size; ++i) {
            input[i] = static_cast<ULL>(buffer[i]);
        }

        rsa.encrypt(input, size, output, rsa_d, rsa_n);

        QString hexString;
        for (ULL i = 0; i < size; ++i) {
            hexString += QString::number((ULL)output[i], 16) + " ";
        }

        if (!hexString.isEmpty())
            hexString.resize(hexString.size() - 1);

        ui->textEdit_2->setPlainText(hexString);
    }
}

// P Q
void MainWindow::on_radioButton_6_clicked()
{
    rsa_mode = false;
    ui->labelPvalue->setText(QString("Значение P"));
    ui->labelQvalue->setText(QString("Значение Q"));

    ui->lineEditPval->setText(QString::number(rsa_p));
    ui->lineEditQval->setText(QString::number(rsa_q));

    ui->lineEditKeyN->setVisible(false);
    ui->labelNval->setVisible(false);
}

// Ключи RSA
void MainWindow::on_radioButton_7_clicked()
{
    rsa_mode = true;

    ui->lineEditKeyN->setVisible(true);
    ui->labelNval->setVisible(true);

    ui->labelPvalue->setText(QString("Значение e (открытый ключ)"));
    ui->labelQvalue->setText(QString("Значение d (закрытый ключ)"));

    if (hasRSAopenKey) {
        ui->lineEditPval->setText(QString::number(rsa_e));
    } else {
        ui->lineEditPval->setText("");
    }

    if (hasRSAprivateKey) {
        ui->lineEditQval->setText(QString::number(rsa_d));
    } else {
        ui->lineEditQval->setText("");
    }

    if (hasRSAnVal) {
        ui->lineEditKeyN->setText(QString::number(rsa_n));
    } else {
        ui->lineEditKeyN->setText("");
    }
}


void MainWindow::on_lineEditPval_textChanged(const QString &arg1)
{
    if (!rsa_mode) {
        bool ok;
        ULL tmp = arg1.toULongLong(&ok);
        if (ok) {
            rsa_p = tmp;
        }
    } else {
        bool ok;
        ULL tmp = arg1.toULongLong(&ok);
        if (ok) {
            rsa_e = tmp;
            hasRSAopenKey = true;
        } else {
            hasRSAopenKey = false;
        }

        if (hasRSAprivateKey && hasRSAopenKey && hasRSAnVal) {
            ui->pushButton->setEnabled(true);
            ui->pushButton_2->setEnabled(true);
        } else {
            ui->pushButton->setEnabled(false);
            ui->pushButton_2->setEnabled(false);
        }
    }
}


void MainWindow::on_lineEditQval_textChanged(const QString &arg1)
{
    if (!rsa_mode) {
        bool ok;
        ULL tmp = arg1.toULongLong(&ok);
        if (ok) {
            rsa_q = tmp;
        }
    } else {
        bool ok;
        ULL tmp = arg1.toULongLong(&ok);
        if (ok) {
            rsa_d = tmp;
            hasRSAprivateKey = true;
        } else {
            hasRSAprivateKey = false;
        }

        if (hasRSAprivateKey && hasRSAopenKey && hasRSAnVal) {
            ui->pushButton->setEnabled(true);
            ui->pushButton_2->setEnabled(true);
        } else {
            ui->pushButton->setEnabled(false);
            ui->pushButton_2->setEnabled(false);
        }
    }
}

// генерировать ключи
void MainWindow::on_pushButton_3_clicked()
{
    rsa.generate_keys(rsa_p, rsa_q);
    rsa.get_public_key(rsa_e, rsa_n);
    rsa.get_private_key(rsa_d, rsa_p, rsa_q);

    ui->radioButton_7->setChecked(true);
    rsa_mode = true;
    hasRSAopenKey = true;
    hasRSAprivateKey = true;
    hasRSAnVal = true;
    ui->labelPvalue->setText(QString("Значение e (открытый ключ)"));
    ui->labelQvalue->setText(QString("Значение d (закрытый ключ)"));
    ui->lineEditPval->setText(QString::number(rsa_e));
    ui->lineEditQval->setText(QString::number(rsa_d));
    ui->lineEditKeyN->setText(QString::number(rsa_n));
    ui->lineEditKeyN->setVisible(true);
    ui->labelNval->setVisible(true);
}


void MainWindow::on_lineEditKeyN_textChanged(const QString &arg1)
{
    if (rsa_mode) {
        bool ok;
        ULL tmp = arg1.toULongLong(&ok);
        if (ok) {
            rsa_n = tmp;
            hasRSAnVal = true;
        } else {
            hasRSAnVal = false;
        }

        if (hasRSAprivateKey && hasRSAopenKey && hasRSAnVal) {
            ui->pushButton->setEnabled(true);
            ui->pushButton_2->setEnabled(true);
        } else {
            ui->pushButton->setEnabled(false);
            ui->pushButton_2->setEnabled(false);
        }
    }
}

