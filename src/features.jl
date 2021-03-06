### Julia OpenStreetMap Package ###
### MIT License                 ###
### Copyright 2014              ###

### Create list of all features in OSM file ###
function getFeatures( street_map::LightXML.XMLDocument )

    xroot = LightXML.root(street_map)
    nodes = LightXML.get_elements_by_tagname(xroot, "node")
    features = Dict{Int,Feature}()

    for n = 1:length(nodes)
        node = nodes[n]
        
        if LightXML.has_attribute(node, "visible")
            if LightXML.attribute(node, "visible") == "false"
                # Visible=false indicates historic data, which we will ignore
                continue
            end
        end
        
        # Search for tag giving feature information
        for tag in LightXML.child_elements(node)
            if LightXML.name(tag) == "tag"
                if LightXML.has_attribute(tag, "k")
                    k = LightXML.attribute(tag, "k")
                    if k == "amenity" || k == "shop" || k == "building" || k == "craft" || k == "historic" || k == "sport" || k == "tourism"
                        id = int(LightXML.attribute(node, "id"))
                        features[id] = getFeatureData(node)
                        break
                    end
                end
            end
        end
    end

    return features
end

### Gather feature data from OSM element ###
function getFeatureData( node::LightXML.XMLElement )

    class = ""
    detail = ""
    feature_name = ""

    # Get node ID
    # id = int64(LightXML.attribute(node, "id"))

    # Iterate over all "label" fields
    for label in LightXML.child_elements(node)

        if LightXML.name(label) == "tag" && LightXML.has_attribute(label, "k")
            k = LightXML.attribute(label, "k")

            # If empty, find the class type
            if class == "" && LightXML.has_attribute(label, "v")
                v = LightXML.attribute(label, "v")
                if k == "amenity"
                    class = "amenity"
                    detail = v
                    continue
                elseif k == "shop"
                    class = "shop"
                    detail = v
                    continue
                elseif k == "building"
                    class = "building"
                    detail = v
                    continue
                elseif k == "craft"
                    class = "craft"
                    detail = v
                    continue
                elseif k == "historic"
                    class = "historic"
                    detail = v
                    continue
                elseif k == "sport"
                    class = "sport"
                    detail = v
                    continue
                elseif k == "tourism"
                    class = "tourism"
                    detail = v
                    continue
                end
            end

            # Check if feature has a name
            if feature_name == "" && k == "name"
                if LightXML.has_attribute(label, "v")
                    feature_name = LightXML.attribute(label, "v")
                    continue
                end
            end
        end
    end

    return Feature(class, detail, feature_name)
end

### Classify features ###
function classify( features::Dict{Int,Feature} )
    feats = Dict{Int,Int}()

    for key in keys(features)
        if haskey(FEATURE_CLASSES,features[key].class)
            feats[key] = FEATURE_CLASSES[features[key].class]
        end
    end

    return feats
end
