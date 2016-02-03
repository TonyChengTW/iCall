#!/usr/local/bin/perl
#----------------------------------------------
# Version : 2006033101
# Writer  : Miko Cheng
# Use for : 當退信給icallvideo_cs時, 將退信資訊記錄於DB02中,
#           另外也將原信件存於MS01的指定目錄中
# Host    : ms01 (帳號 : icall_return)
# Progress: 退信 --> icallvideo_cs --> icall_step1 & icall_step2 -->
#           執行信件分析程式(icall_step1) 分析 退信內容(icall_step2) -->
#           將資訊寫入 db02.aptg.net	
#-----------------------------------------------
# icallvideo_cs   .forward: 
# ipvoip-apol@apol.com.tw;jill@apol.com.tw;ccleader-apol@aptg.com.tw;icall_step1@aptg.net;icall_step2@aptg.net
#-----------------------------------------------
# icall_step1     .forward:
# |/mnt/ms01/i/c/icallvideo_cs/return_mail_statistics.sh
#-----------------------------------------------
use strict;
use DBI;

sleep 3;  #保險起見,為了讓信件先寫進來,所以先暫停N秒後再開始分析信件

my $time = localtime(time());

my $db02_host = 'db02';
my $db02_user = '';
my $db02_passwd = '';
my $db02_db = 'mail_db';

# 製作月曆雜湊
my %monthNums = qw(
    Jan  01 Feb  02 Mar  03 Apr  04 May  05 Jun 06 
    Jul  07 Aug  08 Sep  09 Oct  10 Nov 11 Dec 12);

my $mdir = "/mnt/ms01/i/c/icall_step2/Maildir/new";
my $reserve_bounce_dir = "/export/home/rmail/htdocs/icall_bounce";
my $log_file = "/mnt/ms01/icallvideo.log";

my $dsn = sprintf("DBI:mysql:%s;host=%s", $db02_db, $db02_host);
my $dbh = DBI->connect($dsn, $db02_user, $db02_passwd) || die_db($!);

open LOG,">>$log_file" or die "can't open $log_file\n";

# 抓取信件內容
my @files = glob "$mdir/*";
if (scalar @files == 0) {
	  print LOG "--------------------------------------------\n";
	  print LOG "$time  $mdir is empty! Abort program!\n";
		exit 0;
}

opendir DH, $mdir or die "Error: Can't open $mdir\n";
foreach (readdir DH) {
	  my $total_line; #先將 total_line 建立在 foreach 區塊變數作用範圍內
	  next if $_ eq "." or $_ eq "..";
		my $ab_bounce_file = $mdir.'/'.$_;
		open FH, $ab_bounce_file or die "Error: can't open $ab_bounce_file\n";
    while(<FH>) { $total_line = $total_line.$_; }
		close (FH);
		
# 抓 $recipient 與 $main_domain
    my($recipient) = ($total_line =~ /\nFinal-Recipient: rfc.*; (.*)\n/m);
		(my $mail_domain = $recipient) =~ s/^.*@//;

# 抓 $deliver_time
		my($day, $month_c, $year, $hour, $minute, $second)
		 	= ($total_line =~ /\nDate:.*,\s+(\d+) (\w\w\w) (\d+) (\d+):(\d+):(\d+) \+0800/m);
		my $month = $monthNums{$month_c};
		my $deliver_time = sprintf("%4d%02d%02d%02d%02d%02d", $year, $month, $day, $hour, $minute, $second);

# 抓 $reason
		(my $total_no_line = $total_line) =~ s/\n//g;
    my($reason) = ($total_no_line =~ /Diagnostic-Code:.*Sachiel; (.*)Content-Description/);

# 印出所有資料
		print LOG <<End_of_Log;
-------------------------------------------
$time  open $ab_bounce_file
$time  \$recipient:$recipient
$time  \$mail_domain:$mail_domain
$time  \$deliver_time:$deliver_time
$time  \$reason:$reason
End_of_Log

# 寫入資料庫
		my $sqlstmt = sprintf("INSERT INTO icall (deliver_time,bounce_time,recipient,reason,mail_domain) VALUES( '%s',NOW(),'%s','%s','%s')",$deliver_time, $recipient, $reason, $mail_domain);
    $dbh->do($sqlstmt);

# 搬移退信至 MS01 的$reserve_bounce_dir/$eml_file 以利 VOIP 員工下載退信訊息.
  $sqlstmt = sprintf("SELECT sn FROM icall WHERE deliver_time='%s' AND recipient='%s'", $deliver_time, $recipient);
                print LOG "$time  $sqlstmt\n";
		my $sth = $dbh->prepare($sqlstmt);
		$sth->execute();
		if ($sth->rows == 0) {
			  print LOG "$time  Can't find bounce file, exit!!\n";
				system "rm -f $mdir/*";
				$dbh->disconnect();
				exit 0; #找不到 sn ,代表退信的信件有問題
    } else {
			  (my $sn) = ($sth->fetchrow_array)[0];
        my $eml_file = $sn.'.eml';
        print LOG ("$time  mv $ab_bounce_file $reserve_bounce_dir/$eml_file\n");
        my $cmd_result=`mv $ab_bounce_file $reserve_bounce_dir/$eml_file 2>&1`;
				print LOG "$time  cmd result1:$cmd_result\n";

				print LOG "$time chown rmail $reserve_bounce_dir/$eml_file\n";
				my $cmd_result=`chown rmail $reserve_bounce_dir/$eml_file 2>&1`;
				print LOG "$time  cmd result2:$cmd_result\n";

				#為了保險起見,處理完所有流程後,將所有icall_step2目錄裡不必要的檔案全刪掉
        #以免讀到重覆的信件 (理論上來說,是不用做這一步驟),Just for robust!
				system "rm -f $mdir/*";
    }
    undef($total_line);
}
close (DH);
$dbh->disconnect();
