#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Version 2 opens existing small saved windows maximized once. After that,
// the normal maximize/unmaximize state is preserved across launches.
constexpr gint kWindowStateVersion = 2;

static gchar* get_config_file_path() {
  const gchar* config_dir = g_get_user_config_dir();
  gchar* app_config_dir = g_build_filename(config_dir, "monster-lab", nullptr);
  g_mkdir_with_parents(app_config_dir, 0755);
  gchar* config_path = g_build_filename(app_config_dir, "window.conf", nullptr);
  g_free(app_config_dir);
  return config_path;
}

static void save_window_state(GtkWindow* window) {
  gchar* config_path = get_config_file_path();
  g_autoptr(GKeyFile) key_file = g_key_file_new();
  g_key_file_load_from_file(key_file, config_path, G_KEY_FILE_NONE, nullptr);

  gboolean is_maximized = gtk_window_is_maximized(window);
  g_key_file_set_integer(key_file, "Window", "state_version",
                         kWindowStateVersion);
  g_key_file_set_boolean(key_file, "Window", "maximized", is_maximized);

  if (!is_maximized) {
    gint width = 0, height = 0;
    gtk_window_get_size(window, &width, &height);
    if (width >= 800 && height >= 500) {
      g_key_file_set_integer(key_file, "Window", "width", width);
      g_key_file_set_integer(key_file, "Window", "height", height);
    }
  }

  g_autoptr(GError) error = nullptr;
  g_key_file_save_to_file(key_file, config_path, &error);
  g_free(config_path);
}

static void restore_window_state(GtkWindow* window) {
  gchar* config_path = get_config_file_path();
  g_autoptr(GKeyFile) key_file = g_key_file_new();
  if (g_key_file_load_from_file(key_file, config_path, G_KEY_FILE_NONE, nullptr)) {
    gint width = g_key_file_get_integer(key_file, "Window", "width", nullptr);
    gint height = g_key_file_get_integer(key_file, "Window", "height", nullptr);
    gboolean is_maximized = g_key_file_get_boolean(key_file, "Window", "maximized", nullptr);
    gint state_version = g_key_file_get_integer(
        key_file, "Window", "state_version", nullptr);

    if (width >= 800 && height >= 500) {
      gtk_window_set_default_size(window, width, height);
    } else {
      gtk_window_set_default_size(window, 1280, 720);
    }

    if (is_maximized || state_version < kWindowStateVersion) {
      gtk_window_maximize(window);
    }
  } else {
    gtk_window_set_default_size(window, 1280, 720);
    gtk_window_maximize(window);
  }
  g_free(config_path);
}

static gboolean on_window_delete_event(GtkWidget* widget, GdkEvent* event, gpointer user_data) {
  save_window_state(GTK_WINDOW(widget));
  return FALSE;
}

// Finds the bundled app icon next to the release/debug executable.
static gchar* get_app_icon_path() {
  gchar* executable_path = g_file_read_link("/proc/self/exe", nullptr);
  if (executable_path == nullptr) {
    return nullptr;
  }

  gchar* executable_dir = g_path_get_dirname(executable_path);
  gchar* icon_path = g_build_filename(
      executable_dir, "data", "flutter_assets", "assets", "images",
      "app_icon.png", nullptr);
  g_free(executable_dir);
  g_free(executable_path);
  return icon_path;
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "Monster Lab");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "Monster Lab");
  }

  g_autofree gchar* icon_path = get_app_icon_path();
  if (icon_path != nullptr) {
    gtk_window_set_icon_from_file(window, icon_path, nullptr);
  }

  restore_window_state(window);
  g_signal_connect(window, "delete-event", G_CALLBACK(on_window_delete_event), nullptr);

  GdkGeometry geometry;
  geometry.min_width = 800;
  geometry.min_height = 500;
  gtk_window_set_geometry_hints(window, nullptr, &geometry, GDK_HINT_MIN_SIZE);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}
