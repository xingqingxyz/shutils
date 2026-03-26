import os
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

user = os.environ.get("QQ_EMAIL_ACCOUNT")
password = os.environ.get("QQ_EMAIL_AUTH_CODE")
if not user or not password:
    parser.error("QQ_EMAIL_ACCOUNT and QQ_EMAIL_AUTH_CODE must be set.")

body = args.body
if not body and args.file:
    if args.file == "-":
        body = sys.stdin.read()
    else:
        with open(args.file, encoding="utf8") as f:
            body = f.read()
body = MIMEText(body, "plain", "utf-8")
body["From"] = user
body["To"] = args.receiver
body["CC"] = args.CC
body["BCC"] = args.BCC
body["Subject"] = args.subject
body["Signature"] = args.signature
print(body)

smtp = smtplib.SMTP_SSL("smtp.qq.com")
smtp.login(user, password)
smtp.sendmail(user, args.receiver, str(body))
smtp.quit()
print(f"Sended to {args.receiver}!")
