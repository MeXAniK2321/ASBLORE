GameEvents.Subscribe("screamer_start1", screamer_start1);
GameEvents.Subscribe("emit_video", emit_video);
GameEvents.Subscribe("emit_video1", emit_video1);
GameEvents.Subscribe("emit_video2", emit_video2);
GameEvents.Subscribe("emit_video3", emit_video3);
GameEvents.Subscribe("emit_video4", emit_video4);
GameEvents.Subscribe("emit_video5", emit_video5);
GameEvents.Subscribe("emit_video6", emit_video6);
GameEvents.Subscribe("emit_video7", emit_video7);
GameEvents.Subscribe("screamer_end", screamer_end);
GameEvents.Subscribe("screamer_start2", screamer_start2);
GameEvents.Subscribe("screamer_end1", screamer_end);
GameEvents.Subscribe("baal_sword", baal_sword);
GameEvents.Subscribe("touch_the_child", touch_the_child);
GameEvents.Subscribe("emit_bomba", emit_bomba);

function screamer_start1() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/booga.webm")
	$("#Bgvideo").SetPlaybackVolume(0)
}

function screamer_end() {
	$("#screamer_start1").visible = false
	$("#Bgvideo").visible = false
	$("#dialvideo").visible = false
	$("#Bgvideo").SetPlaybackVolume(0)
	
}

function screamer_start2() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/images/custom_game/pika_screamer.webm")
	$("#Bgvideo").SetPlaybackVolume(0)
}
function touch_the_child() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/touch_the_child.webm")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function baal_sword() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/bobba.webm")
	$("#Bgvideo").SetPlaybackVolume(0)
}
function emit_bomba() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/bomba3.webm")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function screamer_end1() {
	$("#screamer_start1").visible = false
	$("#Bgvideo").visible = false
	$("#dialvideo").visible = false
	$("#Bgvideo").SetPlaybackVolume(0)
	
}

function emit_video() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/peppa.mp4")
	$("#Bgvideo").SetPlaybackVolume(1.0)
}

function emit_video1() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("https://cdn.discordapp.com/attachments/839161654817849454/845379650023587870/videoplayback.mp4")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function emit_video2() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("https://steamusercontent-a.akamaihd.net/ugc/1777210656623449251/00CB6380E0AC80D1E008189E61099E1166D86B4C/")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function emit_video3() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("https://r5---sn-f5f7lnl7.googlevideo.com/videoplayback?expire=1621909034&ei=ygmsYP_sHMyd8gOEobeYCQ&ip=1.20.203.35&id=o-ADLQ73TfEfBu1i7w3iWAlneEKoD_ToHaN4NAt3w0M4KC&itag=18&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&ns=Z8iPsUF6kJqB-YjL1rP6pesF&gir=yes&clen=33025618&ratebypass=yes&dur=1209.132&lmt=1553012221880088&fexp=24001373,24007246&c=WEB&txp=5531432&n=OSoxXvVCfQzKwF_N&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgFy4tFl-QM25bvLoMRUmOGdL6h2wORGAgF8MdBZ3075MCIQDvYaCHJw0-1N2W_n0m6WeR3TwA1O4XMvOoSizK-KPwaw%3D%3D&rm=sn-uvu-0gue76,sn-uvu-c33e676,sn-30all7d&req_id=674eeee3a27fa3ee&redirect_counter=3&cms_redirect=yes&ipbypass=yes&mh=Fz&mip=178.121.42.98&mm=30&mn=sn-f5f7lnl7&ms=nxu&mt=1621887144&mv=m&mvi=5&pl=21&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRgIhAJ-0cUNMRJmtJDV60p6lP4JBNCtR-kzUoc3NbiDci7viAiEA2W934Z75Vdy-cQNM9x7VDbpJ4Rv5RanLB_ws3OdZvc4%3D")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function emit_video4() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("https://steamusercontent-a.akamaihd.net/ugc/1769329363961993896/5E32953D2F0EBCEB83D9AA00BA03839F6DAA1177/")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function emit_video5() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("https://r7---sn-cxauxaxjvh-hn9e7.googlevideo.com/videoplayback?expire=1620173022&ei=foyRYNe9CNmPmLAP6tmJwAE&ip=45.153.33.166&id=o-AIziv6vGUAphuJ4uDRAmO3HJnjL5fewbIs2FAgI3sNxz&itag=18&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&ns=COpDfDDaLC27ufXnvAd3hccF&gir=yes&clen=18603110&ratebypass=yes&dur=332.161&lmt=1617509704562267&fvip=7&fexp=24001373,24007246&c=WEB&txp=5530422&n=WBfL1jeASUadDUttcOi&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgZXZfRQpGBPLCBBvV1qbfvPOxLyTKuXicsIgCP15c7o8CIBwYK_9T9W4wngLiQPJV31CK1RTTrDYTe7o4fDQE9b_o&redirect_counter=1&rm=sn-5hnee67z&req_id=bda164a1e1ffa3ee&cms_redirect=yes&ipbypass=yes&mh=J2&mip=178.121.28.125&mm=31&mn=sn-cxauxaxjvh-hn9e7&ms=au&mt=1620152446&mv=m&mvi=7&pcm2cms=yes&pl=21&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pcm2cms,pl&lsig=AG3C_xAwRgIhAKIsgKZnYm1tcKjbWsWiP31HkYEU-HsvzUCiynxmp71eAiEA4URQO1XGJr9vs6E6GzFj6GG-clLATP673xUrH5habQs%3D")
	$("#Bgvideo").SetPlaybackVolume(1)
}

function emit_video6() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/chara_scary.webm")
	$("#Bgvideo").SetPlaybackVolume(1)
}
function emit_video7() {
	$("#screamer_start1").visible = true
	$("#Bgvideo").visible = true
	$("#dialvideo").visible = false
	$("#Bgvideo").SetMovie("file://{resources}/videos/for_heroes/flan.webm")
	$("#Bgvideo").SetPlaybackVolume(0)
}