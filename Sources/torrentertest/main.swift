import Foundation
import BencodingKit
import TorrentKit

let path = URL(fileURLWithPath: "/Users/sam/Downloads/ubuntu-22.04-desktop-amd64.iso.torrent")
//let path = URL(fileURLWithPath: "/Users/sam/Downloads/debian-11.3.0-amd64-netinst.iso.torrent") //doesn't have complete or incomplete keys, doesn't have peerIDs
//let path = URL(fileURLWithPath: "/Users/sam/Downloads/archlinux-2022.05.01-x86_64.iso.torrent")

DEBUG = true
SOCKETEE = false
logger = Logger([.all])

let download = TorrentDownload(pathToTorrentFile: path)

/*
download.begin()

let _ = readLine()

download.stop()

let _ = readLine()

print("complete")
*/
Task {
    await download.begin()

    let _ = readLine()

    await download.stop()

    let _ = readLine()

    print("complete")
}
while true {}

/*
let tf = try TorrentFile(fromContentsOf: .init(fileURLWithPath: "/Users/sam/Downloads/ubuntu-22.04-desktop-amd64.iso.torrent"))
//let tf = try TorrentFile(fromContentsOf: .init(fileURLWithPath: "/Users/sam/Downloads/weathering-with-you_archive.torrent"))
//let tf = try TorrentFile(fromContentsOf: .init(fileURLWithPath: "/Users/sam/Downloads/debian-11.3.0-amd64-netinst.iso.torrent"))

let ih = tf.infoHash
let infoHash = ih.map { byte in
    switch byte {
    case 126:
        return "~"
    case 46:
        return "."
    case 95:
        return "_"
    case 45:
        return "-"
    case let x where x >= 48 && x <= 57: // [0-9]
        //return Character(UnicodeScalar(x))
        return "\(x-48)"
    case let x where x >= 65 && x <= 90: //[A-Z]
        return String(Character(UnicodeScalar(x)))
    case let x where x >= 97 && x <= 122: //[a-z]
        return String(Character(UnicodeScalar(x)))
    default:
        return String(format: "%%%02x", byte)
        //equivalent to String(byte, radix: 16, uppercase: true) but with padding
    }
}.joined(separator: "")
print("infoHash: \(ih.hexStringEncoded())")
print("(URL-encoded: \(infoHash)")

let peerID = "-SG0000-000000000000"
print("Peer ID: \(peerID)")

if let sfm = tf.singleFileMode {
    print("sfm")
    let length = sfm.length
    var ur = tf.announce.absoluteString
    ur += "?info_hash=\(infoHash)&peer_id=\(peerID)&port=6881&uploaded=0&downloaded=0&left=\(length)&event="
    let url = URL(string: ur + "started")!
    let url2 = URL(string: ur + "stopped")!
    var req = URLRequest(url: url)
    req.httpMethod = "GET"
    var req2 = URLRequest(url: url2)
    req2.httpMethod = "GET"
    var waiting = true
    let task = URLSession.shared.dataTask(with: req) { data, response, error in
        waiting = false
        print("r")
        dump(data)
        dump(response)
        dump(error)
        try! data!.write(to: .init(fileURLWithPath: "/tmp/data.dat"))
        dump(try! Bencoding.object(from: data!))
    }
    task.resume()

    while waiting {}
    let task2 = URLSession.shared.dataTask(with: req2) { data2, response2, error2 in
        print("r2")
        dump(data2)
        dump(response2)
        dump(error2)
        dump(try! Bencoding.object(from: data2!))
    }
    task2.resume()
    while true {}
} else if let mfm = tf.multipleFileMode {
    print("mfm")
    print(tf.infoHash)
    print(tf.announce)
    let total_length = mfm.files.map { $0.length }.reduce(0, +)
    var u = URLComponents(url: tf.announce, resolvingAgainstBaseURL: false)!
    let ih = tf.infoHash.hexStringEncoded()
    //let in_ha = String(ih[..<ih.index(ih.startIndex, offsetBy: 20)])
    let in_ha = String(bytes: tf.infoHash[..<20], encoding: .ascii)!
    //let in_ha = String(bytes: ih, encoding: .utf8)
    //let in_ha = ih
    print(in_ha)
    let peer_id = in_ha
    u.queryItems = [
        URLQueryItem(name: "info_hash", value: in_ha),
        URLQueryItem(name: "peer_id", value: peer_id),
        URLQueryItem(name: "port", value: "6881"),
        URLQueryItem(name: "uploaded", value: "0"),
        URLQueryItem(name: "downloaded", value: "0"),
        URLQueryItem(name: "left", value: "\(total_length)"),
        URLQueryItem(name: "event", value: "started")
    ]
    u.percentEncodedQuery = u.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    var u2 = URLComponents(url: tf.announce, resolvingAgainstBaseURL: false)!
    u2.queryItems = [
        URLQueryItem(name: "info_hash", value: in_ha),
        URLQueryItem(name: "peer_id", value: peer_id),
        URLQueryItem(name: "port", value: "6881"),
        URLQueryItem(name: "uploaded", value: "0"),
        URLQueryItem(name: "downloaded", value: "0"),
        URLQueryItem(name: "left", value: "\(total_length)"),
        URLQueryItem(name: "event", value: "stopped")
    ]
    u2.percentEncodedQuery = u.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    var req = URLRequest(url: u.url!)
    req.httpMethod = "GET"
    var req2 = URLRequest(url: u2.url!)
    req2.httpMethod = "GET"
    var waiting = true
    let task = URLSession.shared.dataTask(with: req) { data, response, error in
        waiting = false
        print("r")
        dump(data)
        dump(response)
        dump(error)
        try! data!.write(to: .init(fileURLWithPath: "/tmp/data.dat"))
        dump(try! Bencoding.object(from: data!))
    }
    task.resume()

    while waiting {}
    let task2 = URLSession.shared.dataTask(with: req2) { data2, response2, error2 in
        print("r2")
        dump(data2)
        dump(response2)
        dump(error2)
        dump(try! Bencoding.object(from: data2!))
    }
    task2.resume()
    while true {}
} else {
    fatalError("neither single noor multiple file")
}
*/
