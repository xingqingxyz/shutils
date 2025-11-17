#!/usr/bin/env python
import smtplib
import sys
from argparse import ArgumentParser
from email.mime.text import MIMEText

parser = ArgumentParser(description="Send email to `receiver`.")
parser.add_argument("receiver")
parser.add_argument("body")
parser.add_argument("-f", "--file", help="use this file instead of read from stdin")
parser.add_argument("-c", "--CC")
parser.add_argument("-b", "--BCC")
parser.add_argument("-s", "--subject")
parser.add_argument("-S", "--signature")
args = parser.parse_args()

sender = "cm.email@qq.com"
body = args.body
if not body and args.file:
    if args.file == "-":
        body = sys.stdin.read()
    else:
        with open(args.file, encoding='utf8') as f:
            body = f.read()
body = MIMEText(body, "plain", "utf-8")
body["From"] = sender
body["To"] = args.receiver
body["CC"] = args.CC
body["BCC"] = args.BCC
body["Subject"] = args.subject
body["Signature"] = args.signature
print(body)

smtp = smtplib.SMTP_SSL("smtp.qq.com")
smtp.login(sender, "jkbuohotidzhciec")
smtp.sendmail(sender, args.receiver, str(body))
smtp.quit()
print(f"Sended to {args.receiver}!")
