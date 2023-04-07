{ config, user, ... }:

let
in
{
  services.openvpn.servers = {
    homeVPN = {
      config = ''
        local 172.105.102.90
        port 1194
        proto udp
        dev tun
        ca ca.crt
        cert server.crt
        key server.key
        dh dh.pem
        auth SHA512
        tls-crypt tc.key
        topology subnet
        server 10.8.0.0 255.255.255.0
        server-ipv6 fddd:1194:1194:1194::/64
        push "redirect-gateway def1 ipv6 bypass-dhcp"
        ifconfig-pool-persist ipp.txt
        push "dhcp-option DNS 8.8.8.8"
        push "dhcp-option DNS 8.8.4.4"
        keepalive 10 120
        cipher AES-256-CBC
        user nobody
        group nogroup
        persist-key
        persist-tun
        status openvpn-status.log
        verb 3
        crl-verify crl.pem
        explicit-exit-notify
      '';
    };
  };
}
