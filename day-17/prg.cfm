<cfscript>
var fileObject = fileOpen("input");
try
{
	var target = fileReadLine(fileObject);
	var t = reMatch("-?[0-9]+", target);
	var xmin = parseNumber(t[1]);
	var xmax = parseNumber(t[2]);
	var ymin = parseNumber(t[3]);
	var ymax = parseNumber(t[4]);

	systemOutput( (ymin + 1) * ymin / 2 , true);

    var cnt = 0;
    var x = 0;
    var y = 0;
    for (dx = 1; dx <= xmax; dx = dx+1) {
        for (dy = ymin; dy <= -ymin; dy = dy+1) {
            // systemOutput("START [" & dx & ", " & dy & "]", true);

            var dxx = dx;
            var dyy = dy;
            var x = 0;
            var y = 0;
            for (s = 0;; s++) {
                if (x > xmax || y < ymin) {
                    // systemOutput("FAR [" & dx & ", " & dy & "]", true);
                    break;
                }
                if (x >= xmin && x <= xmax && y >= ymin && y <= ymax) {
                    // systemOutput("IN [" & dx & ", " & dy & "]", true);
                    cnt = cnt + 1;
                    break;
                }
                x = x + dxx;
                y = y + dyy;
                dxx = dxx < 0 ? dxx + 1 : (dxx > 0 ? dxx - 1 : 0);
                dyy = dyy - 1;
            }
        }
    }
    systemOutput( cnt, true );
}
catch(any ex)
{
	writeDump(ex);
}
finally
{
	fileClose(fileObject);
}
</cfscript>
