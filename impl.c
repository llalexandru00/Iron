#include <stdio.h>
#include <gtk/gtk.h>

struct tuple{int x, y;};
struct window{
     struct tuple *size;
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
    argv[0] = "abc";
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

int assign(char* identifier, int value, struct environment* env, int overwrite)
{
    if (overwrite==1)
    {
        for (int i=0; i<env->nrints; i++)
            if (strcmp(identifier, env->identifiers[i])==0)
            {
                env->ints[i] = value;
                return 1;
            }
        env->identifiers[env->nrints] = identifier;
        env->ints[env->nrints++] = value;
        return 1;
    }

    if(checkFree(identifier, env))
    {
        env->identifiers[env->nrints] = identifier;
        env->ints[env->nrints++] = value;
        return 1;
    }
    else
        return 0;
}

int checkFree(char* identifier, struct environment* env)
{
    for (int i=0; i<env->nrints; i++)
        if (strcmp(identifier, env->identifiers[i])==0)
            return 0;
    return 1;
}

int getById(char* identifier, struct environment* env, struct environment* consts)
{
    for (int i=0; i<env->nrints; i++)
        if (strcmp(identifier, env->identifiers[i])==0)
            return env->ints[i];

    for (int i=0; i<consts->nrints; i++)
        if (strcmp(identifier, consts->identifiers[i])==0)
            return consts->ints[i];
    return 0;
}

void printEnv(struct environment* env)
{
    for (int i=0; i<env->nrints; i++)
        printf("%s -> %d\n", env->identifiers[i], env->ints[i]);
}

void debug()
{
    printf("ok\n");
}
