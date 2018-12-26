#include "DoxyWizard.hpp"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    DoxyWizard w;
    w.show();

    return a.exec();
}
