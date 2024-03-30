#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationDomain("org.tal.timline-test");
    QCoreApplication::setOrganizationName("tal.org");
    QCoreApplication::setApplicationName("TimelineTest");
    QCoreApplication::setApplicationVersion("0.1");

    QQuickStyle::setStyle("Universal");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("timelinetest", "Main");

    return app.exec();
}
