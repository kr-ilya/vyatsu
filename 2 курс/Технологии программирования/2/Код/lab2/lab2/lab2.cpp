#include <iostream>
#include <limits>

using namespace std;

struct QueueElement {
    int* masInt;
    char symbol;
	QueueElement* next;
	int arrSize;
};


int get_int( int min, int max) {
	int v;
	while (true) {
		if ((cin >> v).good()) {
			if (v >= min and v <= max) {
				std::cin.clear();
				cin.ignore(numeric_limits<streamsize>::max(), '\n');
				return v;
			}
			else {
				cout << "Invalid value" << endl;
				cin.clear();
				cin.ignore(numeric_limits<streamsize>::max(), '\n');
				continue;
			}
		}
		else {
			cout << "Invalid value" << endl;
			cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
			continue;
		}
	}
}


char get_symbol() {
	char t;
	while (true) {
		if ((cin >> t).good()) {
			std::cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
			return t;
		}
		else {
			cout << "Invalid value" << endl;
			cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
			continue;
		}
	}
}

void pause() {
	if (cin.rdbuf()->in_avail() > 0) {
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
	}
	cin.get();
}

void change_links(QueueElement* q, int c) {
	for (int i = 0; i < c; i++) {
		if (i == c - 1) {
			(q + i)->next = q;
		}
		else {
			(q + i)->next = (q + i + 1);
		}
	}
}

int main()
{
    
    int n = 0; // номер команды
	int count = 0; // кол-во элементов в очереди
	QueueElement* quenue = NULL;
	QueueElement* quenue_tmp;
	QueueElement* quenue_z;


	do {
		if (cin.rdbuf()->in_avail() > 0) {
			cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
		}
		system("cls");
		cout << "Commands:" << endl
			<< "1 - add element" << endl
			<< "2 - display elements" << endl
			<< "3 - delete element" << endl
			<< "4 - clear quenue" << endl
			<< "5 - exit" << endl;

		n = get_int(1, 5);

		switch (n)
		{
			case 1: {
				if (count == 0) {
					quenue = (QueueElement*)realloc(NULL, sizeof(QueueElement));
					cout << "Number of array elements:" << endl;
					quenue->arrSize = get_int(1, 10);
					quenue->masInt = (int*)realloc(NULL, sizeof(int)* quenue->arrSize);

					for (int i = 0; i < quenue->arrSize; i++) {
						cout << "M[" << i << "] = ";
						quenue->masInt[i] = get_int(-2147483648, 2147483647);
					}

					cout << "Enter char: " << endl;
					quenue->symbol = get_symbol();	
					quenue->next = (quenue + 1);
					count++;
				}
				else {
					quenue_tmp = (QueueElement*)realloc(NULL, sizeof(*quenue)+sizeof(QueueElement) * count);
					memcpy(quenue_tmp, quenue, sizeof(*quenue) + sizeof(QueueElement) * (count-1));

					change_links(quenue_tmp, count);
					realloc(quenue, 0);

					cout << "Number of array elements:" << endl;
					(quenue_tmp + count)->arrSize = get_int(1, 10);
					(quenue_tmp + count)->masInt = (int*)realloc(NULL, sizeof(int) * (quenue_tmp + count)->arrSize);

					for (int i = 0; i < (quenue_tmp + count)->arrSize; i++) {
						cout << "M[" << i << "] = ";
						(quenue_tmp + count)->masInt[i] = get_int(-2147483648, 2147483647);
					}
					
					cout << "Enter char: " << endl;
					(quenue_tmp + count)->symbol = get_symbol();

					(quenue_tmp + count - 1)->next = (quenue_tmp + count);
					(quenue_tmp + count)->next = quenue_tmp;
					cout << sizeof(*quenue) << endl;
					cout << sizeof(*quenue_tmp) << endl;
					quenue = quenue_tmp;
					count++;
				}

				break;
			}
			case 2: {
				if (count != 0) {
					quenue_z = quenue;
					for (int i = 0; i < count; i++) {
						cout << "#" << i << ":" << endl;
						cout << "Array: ";
						for (int j = 0; j < quenue_z->arrSize; j++) {
							cout << quenue_z->masInt[j] << " ";
						}
						cout << endl;

						cout << "Char: " << quenue_z->symbol << endl;

						quenue_z = quenue_z->next;
					}
				}
				else {
					cout << "Empty" << endl;
				}
				pause();
				break;
			}
			case 3: {
				if (count != 0) {
					quenue_tmp = (QueueElement*)realloc(NULL, sizeof(QueueElement) * (count-1));
					memcpy(quenue_tmp, quenue->next, sizeof(QueueElement) * (count - 1));
					change_links(quenue_tmp, count-1);
					realloc(quenue->masInt, 0);
					realloc(quenue, 0);

					quenue = quenue_tmp;
					count--;
					cout << "Deleted" << endl;
				}
				else {
					cout << "Empty" << endl;
				}
				pause();
				break;
			}
			case 4: {
				if (count != 0) {
					quenue_z = quenue;
					for (int i = 0; i < count; i++) {
						realloc(quenue_z->masInt, 0);
						quenue_z = quenue_z->next;
					}

					realloc(quenue, 0);
					quenue = NULL;
					count = 0;
					
					cout << "Deleted" << endl;
				}
				else {
					cout << "Empty" << endl;
				}
				pause();
				break;
			}
			default:
				break;
		}

	} while (n != 5);

    return 0;
}
