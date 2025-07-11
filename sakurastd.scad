include <BOSL2/std.scad>

$force_preview = 0;

module only_preview() {
    if ($force_preview != false && ($preview || $force_preview == true))
        children();
}

module only_render() {
    if ($force_preview != true && (!$preview || $force_preview == false))
        children();
}

module assemble(workspace, show_workspace=true, spacing=5) {
    only_preview(){
        preview_cut_at = $t > 0 ? $t * workspace[2] - workspace[2]/2 : workspace[2]*2;
        bottom_half(z=preview_cut_at, s=max(workspace[0], workspace[1]))
        union() {
            children();
        }
    
        if (show_workspace) {
            wireframe = cube(workspace);
            move([-workspace[0]/2, -workspace[1]/2, -workspace[2]/2])
            %vnf_wireframe(wireframe, width=0.2);
        }
    }
    only_render() {
        cols = ceil(sqrt($children));
        rows = ceil($children / cols);

        spacing = [workspace[0] + spacing, workspace[1] + spacing];

        total_size = [cols * spacing[0], rows * spacing[1]];

        for (i = [0 : $children - 1]) {
            x = (i % cols) * spacing[0] - total_size[0] / 2 + spacing[0] / 2;
            y = -(floor(i / cols) * spacing[1] - total_size[1] / 2 + spacing[1] / 2);
            translate([x, y, 0])
                children(i);
        }
    }
}
