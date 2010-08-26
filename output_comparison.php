<?
require('timing.inc');
?>

<p>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) { ?>
hello <?= $i ?> world
<? }
ss_timing_stop();
?>
</div>
<?= "outputting with html/php: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) {
  print 'hello ' . $i . ' world';
}
ss_timing_stop();
?>
</div>
<?= "outputting with print single quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) {
  print "hello $i world";
}
ss_timing_stop();
?>
</div>
<?= "outputting with print double quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) {
  echo 'hello ' . $i . ' world';
}
ss_timing_stop();
?>
</div>
<?= "outputting with echo single quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) {
  echo "hello $i world";
}
ss_timing_stop();
?>
</div>
<?= "outputting with echo double quotes: " . ss_timing_current() . "<br>"; ?>

<div style="display:none;">
<?
ss_timing_start();
for ($i=0;$i<100000;$i++) { ?>
hello <?= $i ?> world
<? }
ss_timing_stop();
?>
</div>
<?= "outputting with html/php: " . ss_timing_current() . "<br>"; ?>


</p>
