#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLoggingCategory>

int main(int argc, char *argv[])
{
    QLoggingCategory::setFilterRules("qml=true\njs=true");
    QGuiApplication app(argc, argv);

    app.setOrganizationName("FraysDev");
    app.setOrganizationDomain("frays.dev");
    app.setApplicationName("Pratinjau");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("pratinjau", "Main");

    return QGuiApplication::exec();
}
