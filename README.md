Doonan helps you generate CSS presentation code.

Inputs:

  * 1 or more output templates
    *.scss.erb
  * settings.json
  * image files
  
Outputs:

  * *.css
  
Approach:

  * In Ruby, create a binding context for the template rendering
    * parse settings.json
    * merge info about the local image files
  * Use tilt to render the templates