

def getModrinthId [] {
	$in.downloads.0 | str substring 30..37
}

def getProjects [ids] {
 { scheme: "https", host: "api.modrinth.com", path: "v2/projects", params: { ids: ($ids | to json ) } } | url join | http get --headers {User-Agent: "example"} $in 
}

export def modrinth-prefetch [modpack] {

let mrindex = ^unzip -p $modpack modrinth.index.json | from json;

let files = $mrindex.files;

let ids = $files | each { getModrinthId };

let projects = getProjects $ids;

let newfiles = $files | each {|filespec| let id = $filespec | getModrinthId; let project = $projects | where id == $id | first; $filespec | update env { $project | select server_side client_side | rename --block { str replace "_side" "" } } };

$mrindex | update files {$newfiles} | to json | save -f modrinth.index.json;

^zip $modpack modrinth.index.json
}
