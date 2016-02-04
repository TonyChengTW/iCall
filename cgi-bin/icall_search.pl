#!/usr/bin/perl
#-------------------------------------------
# Writer : Miko Cheng
# Version: 2006041801
# Use for: search bounce mails
# Host   : db02 & ms01
#-------------------------------------------

use CGI;
use DBI;
use Date::Calc qw(Add_Delta_Days Delta_Days);

$db_host = '210.200.211.4';
$db_user = 'rmail';
$db_passwd = 'xxxxxxx';

$cgi = new CGI;
$Begyy = $cgi->param('Begyy');
$Begmm = $cgi->param('Begmm');
$Begdd = $cgi->param('Begdd');
$Beghh = $cgi->param('Beghh');
$Begmi = $cgi->param('Begmi');
$Endyy = $cgi->param('Endyy');
$Endmm = $cgi->param('Endmm');
$Enddd = $cgi->param('Enddd');
$Endhh = $cgi->param('Endhh');
$Endmi = $cgi->param('Endmi');

$begdate = $Begyy.$Begmm.$Begdd.$Beghh.$Begmi."00";
$enddate = $Endyy.$Endmm.$Enddd.$Endhh.$Endmi."00";

#if (Delta_Days($Begyy,$Begmm,$Begdd,$Endyy,$Endmm,$Enddd) < 0) {
if ($begdate > $enddate) {
    print "Content-type: text/html\n\n";
    print "<HTML><TITLE> iCall Search Result </TITLE>";
    print "The End Date **MUST** be late than Begin Date<BR>";
    print "<A HREF=\"http://ms01.ebtnet.net/cgi-bin/icall_main.pl\">Return to Previous Page</A></HTML>";
    exit 0;
}

$dbh = DBI->connect("DBI:mysql:mail_db;host=$db_host",$db_user,$db_passwd) or die "$!\n";
$sqlstmt=sprintf("SELECT sn,deliver_time,bounce_time,recipient,reason FROM
                  icall WHERE deliver_time BETWEEN %s AND %s 
                  ORDER BY sn ASC",
                  $begdate, $enddate);
$sth=$dbh->prepare($sqlstmt);
$sth->execute();
$total_record = $sth->rows;
if ($total_record == 0) {
    print "Content-type: text/html\n\n";
    #print "$sqlstmt\n";
    print "<H3> Nothing has be found !! </H3>\n";
    exit 0;
}
print "Content-type: text/html\n\n";
print "<HTML><TITLE> Search bounce information</TITLE>\n";
print "<H3> Total Record: $total_record bounces<BR>\n";
print "You are searching from $Begyy/$Begmm/$Begdd $Beghh:$Begmi to $Endyy/$Endmm/$Enddd $Endhh:$Endmi</H3><BR>\n";
print "<TABLE BORDER=1>\n";
print "<TR><TD>Serial No.</TD><TD>Deliver Time</TD><TD>Bounce Time</TD><TD>Recipient</TD><TD>Bounce Reason</TD></TR>\n";
while (@icall_date = $sth->fetchrow_array) {
    ($sn, $deliver_time, $bounce_time, $recipient, $reason)= (@icall_date);
    print <<END_OF_HTML;
<TR>
<TD><A HREF="http://ms01.ebtnet.net/$sn.eml">$sn</A></TD><TD>$deliver_time</TD><TD>$bounce_time</TD><TD>$recipient</TD><TD>$reason</TD>
</TR>
END_OF_HTML
}

print "</HTML></TABLE>\n";
