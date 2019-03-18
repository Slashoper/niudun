#!/usr/bin/env python
# -*- coding: utf8 -*-


def tcpstat():
    TCP_CODES={
         'TCP_ESTABLISHED':'01',
         'TCP_SYN_SENT':'02',
         'TCP_SYN_RECV':'03',
         'TCP_FIN_WAIT1':'04',
         'TCP_FIN_WAIT2':'05',
         'TCP_TIME_WAIT':'06',
         'TCP_CLOSE':'07',
         'TCP_CLOSE_WAIT':'08',
         'TCP_LAST_ACK':'09',
         'TCP_LISTEN':'0A',
         'TCP_CLOSING':'0B'
          }
    TCP_ESTABLISHED = int(0)
    TCP_SYN_SENT = int(0)
    TCP_SYN_RECV = int(0)
    TCP_FIN_WAIT1 = int(0)
    TCP_FIN_WAIT2 = int(0)
    TCP_TIME_WAIT = int(0)
    TCP_CLOSE = int(0)
    TCP_CLOSE_WAIT = int(0)
    TCP_LAST_ACK = int(0)
    TCP_LISTEN = int(0)
    TCP_CLOSING = int(0)

    fp=open(r'/proc/net/tcp', 'r')
    for i in fp.readlines()[1:]:
         for i in [ i for i in i.split(' ')  if i != '' ][3:4]:
             if i == TCP_CODES.get("TCP_ESTABLISHED") :
                 TCP_ESTABLISHED = TCP_ESTABLISHED + 1
             elif i == TCP_CODES.get("TCP_SYN_SENT") :
                 TCP_SYN_SENT = TCP_SYN_SENT + 1
             elif i == TCP_CODES.get("TCP_SYN_RECV") :
                 TCP_SYN_RECV = TCP_SYN_RECV +1
             elif i == TCP_CODES.get("TCP_FIN_WAIT1") :
                 TCP_FIN_WAIT1 = TCP_FIN_WAIT1 + 1
             elif i == TCP_CODES.get("TCP_FIN_WAIT2") :
                 TCP_FIN_WAIT2 = TCP_FIN_WAIT2 + 1
             elif i == TCP_CODES.get("TCP_CLOSE") :
                 TCP_CLOSE = TCP_CLOSE + 1
             elif i == TCP_CODES.get("TCP_CLOSE_WAIT") :
                 TCP_CLOSE_WAIT = TCP_CLOSE_WAIT + 1
             elif i == TCP_CODES.get("TCP_LAST_ACK") :
                 TCP_LAST_ACK = TCP_LAST_ACK + 1
             elif i == TCP_CODES.get("TCP_LISTEN") :
                 TCP_LISTEN = TCP_LISTEN + 1
             else:
                 TCP_CLOSING = TCP_CLOSING + 1
                 #print TCP_CLOSING
    fp.close() 
    #print "TCP_ESTABLISHED    : %s" % TCP_ESTABLISHED
    #print "TCP_SYN_SENT       : %s" % TCP_SYN_SENT
    #print "TCP_SYN_RECV       : %s" % TCP_SYN_RECV
    #print "TCP_FIN_WAIT1      : %s" % TCP_FIN_WAIT1
    #print "TCP_FIN_WAIT2      : %s" % TCP_FIN_WAIT2
    #print "TCP_CLOSE          : %s" % TCP_CLOSE
    #print "TCP_CLOSE_WAIT     : %s" % TCP_CLOSE_WAIT
    #print "TCP_LAST_ACK       : %s" % TCP_LAST_ACK
    #print "TCP_LISTEN         : %s" % TCP_LISTEN
    #print "TCP_CLOSING        : %s" % TCP_CLOSING
    print TCP_ESTABLISHED
    file = open('/tmp/tcp.txt', 'w')
    file.write('TCP_ESTABLISHED    : %s\n' % TCP_ESTABLISHED)
    file.write('TCP_SYN_SENT       : %s\n' % TCP_SYN_SENT)
    file.write('TCP_SYN_RECV       : %s\n' % TCP_SYN_RECV)
    file.write('TCP_FIN_WAIT1      : %s\n' % TCP_FIN_WAIT1)
    file.write('TCP_FIN_WAIT2      : %s\n' % TCP_FIN_WAIT2)
    file.write('TCP_CLOSE          : %s\n' % TCP_CLOSE)
    file.write('TCP_CLOSE_WAIT     : %s\n' % TCP_CLOSE_WAIT)
    file.write('TCP_LAST_ACK       : %s\n' % TCP_LAST_ACK)
    file.write('TCP_LISTEN         : %s\n' % TCP_LISTEN)
    file.write('TCP_CLOSING        : %s\n' % TCP_CLOSING)
    file.close()






if __name__ == "__main__":
    tcpstat()
