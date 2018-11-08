class SketchupUtils

  def self.get_parent_group(ent)
    if ent.parent.kind_of? Sketchup::ComponentDefinition and ent.parent.group?
      ent.parent.instances[0]
    end
  end

  def self.is_container(ent)
    ent.kind_of? Sketchup::Group
  end

  def self.get_global_transform(ent)
    grp = get_parent_group(ent)
    ent_transform = is_container(ent) ? ent.transformation : Geom::Transformation.new
    unless grp
      return ent_transform
    end
    self.get_global_transform(grp) * ent_transform
  end
end