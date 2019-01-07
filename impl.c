#include <stdio.h>
#include <gtk/gtk.h>
#include <utility>
#include "helper/Point.h"

struct window{
     struct Point *size;
     char* caption;
};
struct component{
     char* name;
     void* value;
};
struct environment{
     char *identifiers[256];
     int ints[256];
     int nrints;
};

static void activate(GtkApplication* app, struct window *win)
{
    GtkWidget *window;
    window = gtk_application_window_new (app);
    gtk_window_set_title (GTK_WINDOW (window), win->caption);
    gtk_window_set_default_size (GTK_WINDOW (window), win->size->x, win->size->y);
    gtk_widget_show_all (window);
}

int createWindow(struct window *win)
{
    GtkApplication *app;
    int status;
    char *argv[20];
    argv[0]="Iron";
    app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
    g_signal_connect (app, "activate", G_CALLBACK (activate), win);
    status = g_application_run (G_APPLICATION (app), 1, argv);
    g_object_unref (app);
    return status;
}

void applyProperty(char* p, struct component* last, char* value)
{
    if (strcmp(last->name,"win")==0)
        if (strcmp(p, "caption")==0)
        {
            struct window *win = (struct window *)last->value;
            win->caption=value;
        }
}
