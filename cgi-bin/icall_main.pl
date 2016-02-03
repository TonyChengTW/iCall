#!/usr/bin/perl
#-------------------------------------------
# Writer : Miko Cheng
# Version: 2006042701
# Use for: select date to search
# Host   : db02 & ms01
#-------------------------------------------

use CGI;
use DBI;

##         Get Today
@localtime = localtime;
$today_min = $localtime[1];
$today_hour = $localtime[2];
$today_date = $localtime[3];
$today_month = $localtime[4]+1;
$today_year = $localtime[5]+1900;

##         Year  
$Select_Begin_y="<SELECT NAME='Begyy' SIZE=1>";
for ($i=0;$i>=-1;$i--)
{
   $the_ii = $today_year + $i;
   if ($today_year == $the_ii) {
       $Select_Begin_y.="<OPTION SELECTED VALUE='$today_year'>$today_year</OPTION>";
       next;
   }
   $Select_Begin_y.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_Begin_y.="</SELECT>";


$Select_End_y="<SELECT NAME='Endyy' SIZE=1>";
for ($i=0;$i>=-1;$i--)
{
   $the_ii = $today_year + $i;
   if ($today_year == $the_ii) {
       $Select_End_y.="<OPTION SELECTED VALUE='$today_year'>$today_year</OPTION>";
       next;
   }
   $Select_End_y.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_End_y.="</SELECT>";

##
##         Month
$Select_Begin_m="<SELECT NAME='Begmm' SIZE=1>";
for ($i=1;$i<=12 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_month) {
             $Select_Begin_m.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
             next;
        }
        $Select_Begin_m.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_Begin_m.="</SELECT>";


$Select_End_m="<SELECT NAME='Endmm' SIZE=1>";
for ($i=1;$i<=12 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_month) {
             $Select_End_m.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
             next;
        }
        $Select_End_m.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_End_m.="</SELECT>";

##
##          Day
$Select_Begin_d="<SELECT NAME='Begdd' SIZE=1>";
for ($i=1;$i<=31 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_date) {
           $Select_Begin_d.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
           next;
        }
        $Select_Begin_d.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_Begin_d.="</SELECT>";

$Select_End_d="<SELECT NAME='Enddd' SIZE=1>";
for ($i=1;$i<=31 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_date) {
             $Select_End_d.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
             next;
        }
        $Select_End_d.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_End_d.="</SELECT>";

##
##          Hour
$Select_Begin_h="<SELECT NAME='Beghh' SIZE=1>";
for ($i=0;$i<=59 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        $Select_Begin_h.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_Begin_h.="</SELECT>";

$Select_End_h="<SELECT NAME='Endhh' SIZE=1>";
for ($i=0;$i<=59 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_hour) {
           $Select_End_h.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
           next;
        }
        $Select_End_h.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_End_h.="</SELECT>";

##
##          Minute
$Select_Begin_mi="<SELECT NAME='Begmi' SIZE=1>";
for ($i=0;$i<=59 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        $Select_Begin_mi.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_Begin_mi.="</SELECT>";

$Select_End_mi="<SELECT NAME='Endmi' SIZE=1>";
for ($i=0;$i<=59 ;$i++)
{
        $the_ii = sprintf("%02d",$i);
        if ($the_ii == $today_min) {
           $Select_End_mi.="<OPTION SELECTED VALUE='$the_ii'>$the_ii</OPTION>";
           next;
        }
        $Select_End_mi.="<OPTION VALUE='$the_ii'>$the_ii</OPTION>";
}
$Select_End_mi.="</SELECT>";

########### Top 10 SELECT OPTIONS String Generate #########
($Select_Top10_Begin_y = $Select_Begin_y) =~ s/Select_/Select_Top10/g;
($Select_Top10_End_y = $Select_End_y) =~ s/Select_/Select_Top10/g;
($Select_Top10_Begin_m = $Select_Begin_m) =~ s/Select_/Select_Top10/g;
($Select_Top10_End_m = $Select_End_m) =~ s/Select_/Select_Top10/g;
($Select_Top10_Begin_d = $Select_Begin_d) =~ s/Select_/Select_Top10/g;
($Select_Top10_End_d = $Select_End_d) =~ s/Select_/Select_Top10/g;
($Select_Top10_Begin_h = $Select_Begin_h) =~ s/Select_/Select_Top10/g;
($Select_Top10_End_h = $Select_End_h) =~ s/Select_/Select_Top10/g;
($Select_Top10_Begin_mi = $Select_Begin_mi) =~ s/Select_/Select_Top10/g;
($Select_Top10_End_mi = $Select_End_mi) =~ s/Select_/Select_Top10/g;

########### Recipient SELECT OPTIONS String Generate #########
($Select_Recipient_Begin_y = $Select_Begin_y) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_End_y = $Select_End_y) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_Begin_m = $Select_Begin_m) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_End_m = $Select_End_m) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_Begin_d = $Select_Begin_d) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_End_d = $Select_End_d) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_Begin_h = $Select_Begin_h) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_End_h = $Select_End_h) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_Begin_mi = $Select_Begin_mi) =~ s/Select_/Select_Recipient/g;
($Select_Recipient_End_mi = $Select_End_mi) =~ s/Select_/Select_Recipient/g;
$Input_Recipient_Text = "<INPUT TYPE=\"text\" NAME=\"RecipientText\" size=20 MAXLENGTH=100>";

#<< Set Cookie ###############################
#$cookie = $query->cookie(-NAME=>'userid',
#                           -VALUE=>$userid,
#                           -path=>'/',
#                           -expires=>$expire);
#print $query->header(-Cookie=>$cookie);
#Content-type: text/html;charset=big5\n\n
#Content-type: text/html
################################ Set Cookie >>
print <<END_OF_HTML;
Content-type: text/html;charset=big5

<html>
<head>
<title>iCall-Log Search System</title>
</head>

<body BGCOLOR="#FFFFFF">
  <TABLE BORDER="0" cellspacing="8" cellpadding="0" WITDH="600">
    <TR ALIGN="center">
      <TD WITDH="600">
        <TABLE BORDER="1" WITDH="420" ALIGN="center" cellspacing="0" BGCOLOR="#E1F0FF" bordercolor="#002244" cellpadding="2">
           <TR ALIGN="center">
            <TD WITDH="590">
              <TABLE BORDER="0" WITDH="590" ALIGN="center" cellpadding="5" BGCOLOR="#E1F0FF" bordercolor="#CCCCCC" cellspacing="3">
                <TR>
                  <TD ALIGN="Center" WITDH="100%" colspan=3><FONT SIZE="5" color="#2244DD"><b>iCall - Bounce Log Search System v0.9</b>
                    </FONT></TD>
                </TR>
<FORM NAME="form1" METHOD="POST" ACTION="icall_search.pl" onSubmit="return Check(form1)">
                <TR>
                  <TD ALIGN="left" WITDH="100%" colspan=3><hr SIZE=-1 WITDH="95%"></TD>
                </TR>

                <TR>
                  <TD WITDH="360" ALIGN="left" BGCOLOR="#E1F0FF"><FONT SIZE="2" color="#2255EE"><B>Bounce Log:</FONT></B></TD></TR>
                <TR><TD>Begin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;End</TD></TR>
                <TR>
                  <TD VALIGN="middle" WITDH="360"> <FONT SIZE="-1">
$Select_Begin_y¢¬$Select_Begin_m¢¬$Select_Begin_d &nbsp;$Select_Begin_h¡G$Select_Begin_mi&nbsp;&nbsp; ¡ã&nbsp; $Select_End_y¢¬$Select_End_m¢¬$Select_End_d &nbsp;$Select_End_h¡G$Select_End_mi
                  </FONT></TD>
                  <TD VALIGN="middle" WITDH="90"> <FONT SIZE="-1">
                    <INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit">
                  </FONT></TD>
                  </TR>
</FORM>

<BR><BR>
<FORM NAME="form2" METHOD="POST" ACTION="icall_top10.pl" onSubmit="return Check(form2)">
                <TR>
                  <TD ALIGN="left" WITDH="100%" colspan=3><hr SIZE=-1 WITDH="95%"></TD>
                </TR>
                <TR>
                  <TD WITDH="360" ALIGN="left" BGCOLOR="#E1F0FF"><FONT SIZE="2" color="#2255EE"><B>Top 10 Bounce Domain:</FONT></B></TD></TR>
                <TR><TD>Begin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;End</TD></TR>
                <TR>
                  <TD VALIGN="middle" WITDH="360"> <FONT SIZE="-1">
$Select_Top10_Begin_y¢¬$Select_Top10_Begin_m¢¬$Select_Top10_Begin_d &nbsp;$Select_Top10_Begin_h¡G$Select_Top10_Begin_mi&nbsp;&nbsp; ¡ã&nbsp; $Select_Top10_End_y¢¬$Select_Top10_End_m¢¬$Select_Top10_End_d &nbsp;$Select_Top10_End_h¡G$Select_Top10_End_mi
                  </FONT></TD>
                  <TD VALIGN="middle" WITDH="90"> <FONT SIZE="-1">
                    <INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit">
                  </FONT></TD>
                  </TR>

</FORM>




<FORM NAME="form3" METHOD="POST" ACTION="icall_recipient.pl" onSubmit="return Check(form3)">
                <TR>
                  <TD ALIGN="left" WITDH="100%" colspan=3><hr SIZE=-1 WITDH="95%"></TD>
                </TR>
                <TR>
                  <TD WITDH="360" ALIGN="left" BGCOLOR="#E1F0FF"><FONT SIZE="2" color="#2255EE"><B>Specific Recipient:</FONT></B></TD></TR>
                <TR><TD>E-Mail Address : $Input_Recipient_Text</TD></TR>
                <TR><TD>Begin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;End</TD></TR>
                <TR>
                  <TD VALIGN="middle" WITDH="360"> <FONT SIZE="-1">
$Select_Recipient_Begin_y¢¬$Select_Recipient_Begin_m¢¬$Select_Recipient_Begin_d &nbsp;$Select_Recipient_Begin_h¡G$Select_Recipient_Begin_mi&nbsp;&nbsp; ¡ã&nbsp; $Select_Recipient_End_y¢¬$Select_Recipient_End_m¢¬$Select_Recipient_End_d &nbsp;$Select_Recipient_End_h¡G$Select_Recipient_End_mi
                  </FONT></TD>
                  <TD VALIGN="middle" WITDH="90"> <FONT SIZE="-1">
                    <INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit">
                  </FONT></TD>
                  </TR>

</FORM>

</TABLE>
<BR>
</body>
</html>
END_OF_HTML
