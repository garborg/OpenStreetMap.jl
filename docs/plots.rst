Displaying Maps
===============

OpenStreetMap.jl includes a single plotting function. This function has numerous options, allowing a great deal of flexibility when displaying maps:

.. code-block:: python

    function plotMap( nodes;
                      highways=nothing,
                      buildings=nothing,
                      features=nothing,
                      bounds=nothing,
                      intersections=nothing,
                      roadways=nothing,
                      cycleways=nothing,
                      walkways=nothing,
                      feature_classes=nothing,
                      building_classes=nothing,
                      route=nothing,
                      highway_style::Style = Style(0x007CFF,1.5,"-"),
                      building_style::Style = Style(0x000000,1,"-"),
                      feature_style = Style(0xCC0000,2.5,"."),
                      route_style = Style(0xFF0000, 3, "-"),
                      intersection_style::Style = Style(0x000000,3,"."),
                      width::Integer=500,
                      realtime::Bool=false )

The function, ``plotMap()``, has a single required input: ``nodes``. However, providing ``plotMap()`` with only the list of nodes will result in an empty plot. The user then has the choice between a variety of plotting options. It is important to note that this function is designed for convenience rather than speed. It is highly recommended that a Bounds object is input, as this is used to provided plot scaling.

The following subsecions step through some of the plotting options. Essentially, the user builds up a series of "layers" through providing multiple inputs.

Data Inputs
-----------

These parameters provided the actual data to be plotted.

* ``nodes`` [``Dict{Int,LLA}`` or ``Dict{Int,ENU}``]: List of all point locations
* ``features`` [``Dict{Int,Feature}``]: List of features to display
* ``buildings`` [``Dict{Int,Building}``]: List of buildings to display
* ``highways`` [``Dict{Int,Highway}``]: List of highways to display
* ``intersections`` [``Dict{Int,Intersection}``]: List of highway intersections
* ``route`` [``Array{Int,1}`` or ``Array{Array{Int,1},1}``]: List of nodes comprising a highway route OR a list of lists of routes (if multiple routes are to be displayed).

Data Classifiers
----------------

These parameters classify the map elements according to a layer specification. When these parameters are passed to ``plotMap()``, only the classified map elements are plotted (all map elements not in these dictionaries are ignored).

* ``roadways``: Dictionary of highway types suitable for driving
* ``cycleways``: Dictionary of highway types suitable for cycling
* ``walkways``: Dictionary of highway types suitable for walking
* ``building_classes``: Dictionary of building classifications
* ``feature_classes``: Dictionary of feature classifications

**Note 1:** These layers use their own ``Layer`` dictionaries, containing one ``Style`` type for each element classification level, to define plotting styles. Therefore, any additional style inputs related to these classifiers will be ignored without any explicit warnings to the user.

**Note 2:** Using multiple highway classifiers on one plot may cause them to overlap and occlude one another. The ordering, from bottom to top, is ``roadways``, ``cycleways``, ``walkways``.

Plot Display Options
--------------------

* ``bounds`` [``Bounds``]: X and Y axes limits of plot, also used to compute appropriate plot aspect ratio
* ``width`` [``Int``]: Width of the plot, in pixels
* ``realtime`` [``Bool``]: When true, elements are added to the map individually (this drastically slows down plotting, but is fun to watch)

Plot Customization
------------------

The following optional inputs allow the user to customize the map display.

* ``highway_style`` [``Style`` or ``Dict{Int,Style}``]: See note 3 below.
* ``building_style`` [``Style``]: See note 3 below.
* ``feature_style`` [``Style`` or ``Dict{Int,Style}``]: See note 3 below.
* ``route_style`` [``Style`` or ``Array{Style,1}``]: Use an array of ``Style`` types to plot multiple routes with different appearances.
* ``intersection_style`` [``Style``]

These inputs all take a ``Style`` type, which is constructed as follows:

.. code-block:: python
    
    style = OpenStreetMap.Style( color, width, spec )

For example:

.. code-block:: python

    highway_style = OpenStreetMap.Style( "b", 1.5, "-")
    feature_style = OpenStreetMap.Style( 0xf57900, 2, ".")
    
**Note 1:** ``color`` must be a hex color code.

**Note 2:** ``spec`` is a line specification code used by Winston.jl. Common examples are the following:

* ``"-"``: Solid line
* ``"."``: Filled, square points
* ``"o"``: Open, round points

**Note 3:** For highways, buildings, and features, if an additional classifier is input (e.g., ``roadways``), the respective style input must be a dictionary of styles, with type ``Dict{Int,Style}``, with a style given for each classification. This dictionary is called a "layer" in OpenStreetMap terminology, and defines how a specific map layer is displayed. The default layers are defined as constants in ``layers.jl``.
