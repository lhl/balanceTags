<?
require('timing.inc');
?>

<p>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) { ?>
hello <?= $i ?> world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. 
<? }
ss_timing_stop();
?>
</div>
<?= "outputting with html/php: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) {
  print 'hello ' . $i . ' world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. ';
}
ss_timing_stop();
?>
</div>
<?= "outputting with print single quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) {
  print "hello $i world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. ";
}
ss_timing_stop();
?>
</div>
<?= "outputting with print double quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) {
  echo 'hello ' . $i . ' world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. ';
}
ss_timing_stop();
?>
</div>
<?= "outputting with echo single quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) {
  echo "hello $i world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. ";
}
ss_timing_stop();
?>
</div>
<?= "outputting with echo double quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<10000;$i++) { ?>
hello <?= $i ?> world. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel willum lunombro dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. 
<? }
ss_timing_stop();
?>
</div>
<?= "outputting with html/php: " . ss_timing_current() . "<br>"; ?>


</p>
