#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  FlMethodChannel* window_channel;
  FlMethodChannel* menu_channel;
  GtkWidget* menu_bar;
  GtkWidget* root_box;
  GtkWindow* window;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

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
  g_key_file_set_boolean(key_file, "Window", "maximized", is_maximized);

  if (!is_maximized) {
    gint width = 0, height = 0;
    gtk_window_get_size(window, &width, &height);
    if (width >= 800 && height >= 500) {
      g_key_file_set_integer(key_file, "Window", "width", width);
      g_key_file_set_integer(key_file, "Window", "height", height);
    }

    gint x = 0, y = 0;
    gtk_window_get_position(window, &x, &y);
    g_key_file_set_integer(key_file, "Window", "x", x);
    g_key_file_set_integer(key_file, "Window", "y", y);
  }

  g_autoptr(GError) error = nullptr;
  g_key_file_save_to_file(key_file, config_path, &error);
  g_free(config_path);
}

// Reject saved positions that no longer land on a connected monitor.
static gboolean window_position_is_visible(GtkWindow* window, gint x, gint y) {
  GdkDisplay* display = gtk_widget_get_display(GTK_WIDGET(window));
  if (display == nullptr) {
    return FALSE;
  }

  GdkMonitor* monitor = gdk_display_get_monitor_at_point(display, x, y);
  if (monitor == nullptr) {
    return FALSE;
  }

  GdkRectangle geometry;
  gdk_monitor_get_geometry(monitor, &geometry);
  return x >= geometry.x && y >= geometry.y &&
         x + 200 <= geometry.x + geometry.width &&
         y + 100 <= geometry.y + geometry.height;
}

static void restore_window_state(GtkWindow* window) {
  gchar* config_path = get_config_file_path();
  g_autoptr(GKeyFile) key_file = g_key_file_new();
  if (g_key_file_load_from_file(key_file, config_path, G_KEY_FILE_NONE, nullptr)) {
    gint width = g_key_file_get_integer(key_file, "Window", "width", nullptr);
    gint height = g_key_file_get_integer(key_file, "Window", "height", nullptr);
    gboolean is_maximized =
        g_key_file_get_boolean(key_file, "Window", "maximized", nullptr);

    if (width >= 800 && height >= 500) {
      gtk_window_set_default_size(window, width, height);
    } else {
      gtk_window_set_default_size(window, 1280, 720);
    }

    if (!is_maximized && g_key_file_has_key(key_file, "Window", "x", nullptr) &&
        g_key_file_has_key(key_file, "Window", "y", nullptr)) {
      gint x = g_key_file_get_integer(key_file, "Window", "x", nullptr);
      gint y = g_key_file_get_integer(key_file, "Window", "y", nullptr);
      if (window_position_is_visible(window, x, y)) {
        gtk_window_move(window, x, y);
      }
    }

    if (is_maximized) {
      gtk_window_maximize(window);
    }
  } else {
    gtk_window_set_default_size(window, 1280, 720);
  }
  g_free(config_path);
}

static gboolean on_window_delete_event(GtkWidget* widget, GdkEvent* event,
                                       gpointer user_data) {
  save_window_state(GTK_WINDOW(widget));
  return FALSE;
}

static void on_window_destroyed(GtkWidget* widget, gpointer user_data) {
  MyApplication* self = MY_APPLICATION(user_data);
  if (self->window == GTK_WINDOW(widget)) {
    self->window = nullptr;
    self->root_box = nullptr;
    g_clear_object(&self->menu_bar);
  }
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

// Handles the Dart-side request to close the window so GTK can save geometry.
static void window_method_call_cb(FlMethodChannel* channel,
                                  FlMethodCall* method_call,
                                  gpointer user_data) {
  (void)channel;

  if (g_strcmp0(fl_method_call_get_name(method_call), "closeWindow") == 0) {
    GtkWindow* window = GTK_WINDOW(user_data);
    fl_method_call_respond_success(method_call, fl_value_new_null(), nullptr);
    gtk_window_close(window);
    return;
  }

  fl_method_call_respond_not_implemented(method_call, nullptr);
}

static void send_menu_command(MyApplication* self, const gchar* command) {
  if (self->menu_channel == nullptr) {
    return;
  }
  g_autoptr(FlValue) args = fl_value_new_string(command);
  fl_method_channel_invoke_method(self->menu_channel, "menuCommand", args,
                                  nullptr, nullptr, nullptr);
}

static void menu_item_activated_cb(GtkMenuItem* item, gpointer user_data) {
  MyApplication* self = MY_APPLICATION(user_data);
  const gchar* command = static_cast<const gchar*>(
      g_object_get_data(G_OBJECT(item), "menu-command"));
  if (command == nullptr) {
    return;
  }
  if (g_strcmp0(command, "quit") == 0) {
    if (self->window != nullptr) {
      gtk_window_close(self->window);
    }
    return;
  }
  send_menu_command(self, command);
}

static GtkWidget* create_menu_item(const gchar* label,
                                   const gchar* command,
                                   MyApplication* self) {
  GtkWidget* item = gtk_menu_item_new_with_label(label);
  g_object_set_data_full(G_OBJECT(item), "menu-command", g_strdup(command),
                         g_free);
  g_signal_connect(item, "activate", G_CALLBACK(menu_item_activated_cb), self);
  return item;
}

// Builds a native GTK menu bar so Linux assistive technologies see real
// menu-bar and menu-item roles. Flutter's Linux embedder does not map
// SemanticsRole to ATK roles, so an in-app MenuBar cannot provide this.
static GtkWidget* create_menu_bar(MyApplication* self) {
  GtkWidget* menu_bar = gtk_menu_bar_new();

  GtkWidget* file_item = gtk_menu_item_new_with_label("File");
  GtkWidget* file_menu = gtk_menu_new();
  gtk_menu_shell_append(GTK_MENU_SHELL(file_menu),
                        create_menu_item("Preferences...", "preferences", self));
  gtk_menu_shell_append(GTK_MENU_SHELL(file_menu),
                        gtk_separator_menu_item_new());
  gtk_menu_shell_append(GTK_MENU_SHELL(file_menu),
                        create_menu_item("Quit Monster Lab", "quit", self));
  gtk_menu_item_set_submenu(GTK_MENU_ITEM(file_item), file_menu);
  gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), file_item);

  GtkWidget* navigate_item = gtk_menu_item_new_with_label("Navigate");
  GtkWidget* navigate_menu = gtk_menu_new();
  const gchar* navigate_labels[] = {"Home", "Learn", "Parts Lab",
                                    "Build Studio", "Progress & Badges"};
  for (int i = 0; i < 5; i++) {
    gchar* command = g_strdup_printf("navigate-%d", i);
    gtk_menu_shell_append(GTK_MENU_SHELL(navigate_menu),
                          create_menu_item(navigate_labels[i], command, self));
    g_free(command);
  }
  gtk_menu_item_set_submenu(GTK_MENU_ITEM(navigate_item), navigate_menu);
  gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), navigate_item);

  GtkWidget* view_item = gtk_menu_item_new_with_label("View");
  GtkWidget* view_menu = gtk_menu_new();
  gtk_menu_shell_append(GTK_MENU_SHELL(view_menu),
                        create_menu_item("Zoom In", "zoom-in", self));
  gtk_menu_shell_append(GTK_MENU_SHELL(view_menu),
                        create_menu_item("Zoom Out", "zoom-out", self));
  gtk_menu_shell_append(GTK_MENU_SHELL(view_menu),
                        gtk_separator_menu_item_new());
  gtk_menu_shell_append(GTK_MENU_SHELL(view_menu),
                        create_menu_item("Normal Size (Reset)", "zoom-reset", self));
  gtk_menu_item_set_submenu(GTK_MENU_ITEM(view_item), view_menu);
  gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), view_item);

  GtkWidget* help_item = gtk_menu_item_new_with_label("Help");
  GtkWidget* help_menu = gtk_menu_new();
  gtk_menu_shell_append(GTK_MENU_SHELL(help_menu),
                        create_menu_item("About Monster Lab", "about", self));
  gtk_menu_item_set_submenu(GTK_MENU_ITEM(help_item), help_menu);
  gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), help_item);

  atk_object_set_name(gtk_widget_get_accessible(menu_bar), "Main menu");
  gtk_widget_show_all(menu_bar);
  return menu_bar;
}

static void set_menu_bar_visible(MyApplication* self, gboolean visible) {
  if (self->menu_bar == nullptr || self->root_box == nullptr) {
    return;
  }

  GtkWidget* parent = gtk_widget_get_parent(self->menu_bar);
  if (visible) {
    if (parent == nullptr) {
      gtk_box_pack_start(GTK_BOX(self->root_box), self->menu_bar, FALSE, TRUE,
                         0);
    }
    // Realize the submenus again after reparenting so their accessible
    // actions and popup windows are live, not just visible metadata.
    gtk_widget_show_all(self->menu_bar);
    return;
  }

  // Remove the bar from the GTK hierarchy while the shell cannot handle its
  // actions. Hiding alone would leave it in the AT-SPI tree on onboarding
  // and other screens that have no menu.
  if (parent != nullptr) {
    gtk_container_remove(GTK_CONTAINER(parent), self->menu_bar);
  }
}

static void menu_method_call_cb(FlMethodChannel* channel,
                                FlMethodCall* method_call,
                                gpointer user_data) {
  (void)channel;
  MyApplication* self = MY_APPLICATION(user_data);
  if (g_strcmp0(fl_method_call_get_name(method_call), "setVisible") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    if (fl_value_get_type(args) == FL_VALUE_TYPE_BOOL) {
      set_menu_bar_visible(self, fl_value_get_bool(args));
      fl_method_call_respond_success(method_call, fl_value_new_null(), nullptr);
      return;
    }
  }
  fl_method_call_respond_not_implemented(method_call, nullptr);
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  if (self->window != nullptr) {
    gtk_window_present(self->window);
    return;
  }

  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
  self->window = window;
  g_signal_connect(window, "destroy", G_CALLBACK(on_window_destroyed), self);

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
  g_signal_connect(window, "delete-event", G_CALLBACK(on_window_delete_event),
                   nullptr);

  GdkGeometry geometry;
  geometry.min_width = 800;
  geometry.min_height = 500;
  gtk_window_set_geometry_hints(window, nullptr, &geometry, GDK_HINT_MIN_SIZE);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Avoid a black flash before the first frame; the GTK window background
  // shows through instead.
  gdk_rgba_parse(&background_color, "#00000000");
  fl_view_set_background_color(view, &background_color);
  GtkWidget* root_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
  GtkWidget* menu_bar = create_menu_bar(self);
  self->root_box = root_box;
  self->menu_bar = menu_bar;
  // Keep ownership of the bar so it can be parented only while the Dart shell
  // is active. A hidden, parentless widget is absent from the AT-SPI tree.
  g_object_ref_sink(menu_bar);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_box_pack_start(GTK_BOX(root_box), GTK_WIDGET(view), TRUE, TRUE, 0);
  gtk_container_add(GTK_CONTAINER(window), root_box);
  gtk_widget_show(root_box);

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  g_clear_object(&self->window_channel);
  g_autoptr(FlStandardMethodCodec) window_codec =
      fl_standard_method_codec_new();
  self->window_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "monster_lab/window", FL_METHOD_CODEC(window_codec));
  fl_method_channel_set_method_call_handler(
      self->window_channel, window_method_call_cb, window, nullptr);

  g_clear_object(&self->menu_channel);
  self->menu_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "monster_lab/menu", FL_METHOD_CODEC(window_codec));
  fl_method_channel_set_method_call_handler(
      self->menu_channel, menu_method_call_cb, self, nullptr);

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
  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_object(&self->window_channel);
  g_clear_object(&self->menu_channel);
  g_clear_object(&self->menu_bar);
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
  // corresponding .desktop file. The unique application instance lets a
  // second launch present the existing window instead of opening a duplicate.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     nullptr));
}
