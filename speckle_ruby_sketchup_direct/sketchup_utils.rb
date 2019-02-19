class SketchupUtils

  def self.get_parent_group(ent)
    #sketchup groups are now stored internally as components with a "group" flag
    if ent.parent.kind_of? Sketchup::ComponentDefinition and ent.parent.group?
      ent.parent.instances[0] #will just return first instance - may not be what we want, but unclear how to get actual group
    end
  end

  def self.is_container(ent)
    ent.kind_of? Sketchup::Group
  end

  def self.get_global_transform(ent)
    #with the new system of groups and components it's not clear if you can calculate a global transform for a particular face or edge because its unclear what the parent group is...
    grp = get_parent_group(ent)
    ent_transform = is_container(ent) ? ent.transformation : Geom::Transformation.new
    unless grp
      return ent_transform
    end
    self.get_global_transform(grp) * ent_transform
  end

  def self.color_to_hex(color)
    ans = '#'
    [color.red, color.green, color.blue].each {|c| ans << c.to_s(16).rjust(2, '0')}
    ans
  end
end