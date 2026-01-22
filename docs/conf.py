project = "DBHose-Airflow"
copyright = "2025-%Y, 0xMihalich"
author = "0xMihalich"
release = "0.1.0.3"
master_doc = "index"
language = "ru"
html_theme = "alabaster"
html_static_path = ["_static"]
html_show_sphinx = False
html_show_source = False
html_show_sourcelink = False
html_logo = "_static/logo.png"
html_favicon = "_static/favicon.ico"
extensions = [
    "sphinx.ext.autodoc",
    "sphinx_copybutton",
]
autodoc_type_aliases = {
}
autodoc_typehints = "description"
templates_path = ["_templates"]
exclude_patterns = []
html_theme = "furo"
html_static_path = ["_static"]
html_theme_options = {
    "dark_mode": True,
    "show_source": False,
    "show_furo_footer": False,
    'sidebar_width': '350px',
    'navigation_with_keys': True,
}
