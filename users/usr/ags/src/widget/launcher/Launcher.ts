import { type Binding } from "lib/utils"
import PopupWindow, { Padding } from "widget/PopupWindow"
import icons from "lib/icons"
import options from "options"
import nix from "service/nix"
import * as AppLauncher from "./AppLauncher"
import * as NixRun from "./NixRun"
import * as ShRun from "./ShRun"

const { width, margin } = options.launcher
const isnix = nix.available

const commands = {
    ">": "run a shell command",
}
if (isnix){
    commands[":nix"] = options.launcher.nix.pkgs.bind().as(pkg =>
        `run a nix package from ${pkg}`)
}


function Launcher() {
    const applauncher = AppLauncher.Launcher()
    const sh = ShRun.ShRun()
    const shicon = ShRun.Icon()
    const nix = NixRun.NixRun()
    const nixload = NixRun.Spinner()

    function HelpButton(cmd: string, desc: string | Binding<string>) {
        return Widget.Box(
            { vertical: true },
            Widget.Separator(),
            Widget.Button(
                {
                    class_name: "help",
                    on_clicked: () => {
                        entry.grab_focus()
                        entry.text = `:${cmd} `
                        entry.set_position(-1)
                    },
                },
                Widget.Box([
                    Widget.Label({
                        class_name: "name",
                        label: `${cmd}`,
                    }),
                    Widget.Label({
                        hexpand: true,
                        hpack: "end",
                        class_name: "description",
                        label: desc,
                    }),
                ]),
            ),
        )
    }

    var _help = Widget.Revealer({
        child: Widget.Box(
            { vertical: true },
            HelpButton("/", "run a binary"),
            isnix ? HelpButton(":nx", options.launcher.nix.pkgs.bind().as(pkg =>
                `run a nix package from ${pkg}`,
            )) : Widget.Box(),
        ),
    })
    const help = Object.assign(_help, {
        filter: async (query)=>{
            query||=""
            if (query.split(" ").length > 1){
                _help.reveal_child = false
            }
            else {
                var matches:Array<string> = []
                for (var cmd in commands) {
                    if (cmd.startsWith(query)){
                        matches.push(cmd)
                    }
                }
                _help.child.children = matches.map((match)=>{return HelpButton(match, commands[match])})
                if (_help.child.children.length){
                    _help.reveal_child = true
                }
            }
        }   
    })

    const entry = Widget.Entry({
        hexpand: true,
        primary_icon_name: icons.ui.search,
        on_accept: ({ text }) => {
            if (text?.startsWith(":nx"))
                nix.run(text.substring(3))
            else if (text?.startsWith("/"))
                sh.run(text.substring(1))
            else
                applauncher.launchFirst()

            App.toggleWindow("launcher")
            entry.text = ""
        },
        on_change: async ({ text }) => {
            text ||= ""
            //help.reveal_child = text.split(" ").length === 1 && text?.startsWith(":")
            help.filter(text)

            if (text?.startsWith(":nx"))
                nix.filter(text.substring(3))
            else
                nix.filter("")

            if (text?.startsWith(">"))
                sh.filter(text.substring(1))
            else
                sh.filter("")

            if (text === " " || !Object.keys(commands).some((val, ind, arr)=>{
                return val.startsWith(text.split(" ")[0])
            })){
                applauncher.filter(text)
            }
            else {
                applauncher.filter("")
            }
        },
    })

    function focus() {
        var text = entry.text ? entry.text : ""
        if (text === ""){
            text = "Search"
            help.filter("");
        }
        else {
            help.filter(text)
            if (text.startsWith(":nx"))
                nix.filter(text.substring(3))
            else
                nix.filter("")

            if (text.startsWith(">"))
                sh.filter(text.substring(1))
            else
                sh.filter("")

            if (text === " " || !Object.keys(commands).some((val, ind, arr)=>{
                return val.startsWith(text.split(" ")[0])
            })){
                applauncher.filter(text)
            }
            else {
                applauncher.filter("")
            }
        }
        entry.set_position(-1)
        entry.select_region(0, -1)
        entry.grab_focus()
    }

    const layout = Widget.Box({
        css: width.bind().as(v => `min-width: ${v}pt;`),
        class_name: "launcher",
        vertical: true,
        vpack: "start",
        setup: self => self.hook(App, (_, win, visible) => {
            if (win !== "launcher")
                return

            if (visible)
                focus()
        }),
        children: [
            Widget.Box([entry, nixload, shicon]),
            help,
            applauncher,
            nix,
            sh,
        ],
    })

    return Widget.Box(
        { vertical: true, css: "padding: 1px" },
        Padding("applauncher", {
            css: margin.bind().as(v => `min-height: ${v}pt;`),
            vexpand: false,
        }),
        layout,
    )
}

export default () => PopupWindow({
    name: "launcher",
    layout: "center",
    child: Launcher(),
    transition: "slide_up"
})
