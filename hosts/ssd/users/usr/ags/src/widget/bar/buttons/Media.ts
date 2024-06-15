import { type MprisPlayer } from "types/service/mpris"
import PanelButton from "../PanelButton"
import options from "options"
import icons from "lib/icons"
import { icon } from "lib/utils"

const mpris = await Service.import("mpris")
const { length, direction, preferred, monochrome, format } = options.bar.media

const getPlayer = (name = preferred.value) =>
    mpris.getPlayer(name) || (mpris.players[0].name != "playerctld" ? mpris.players[0] : mpris.players[1]) || null

const Content = (player: MprisPlayer) => {
    player.bind("position").as((pos)=> {progress.setValue(pos)})
    Utils.merge([
        player.bind("track_title"),
        player.bind("track_artists"),
        format.bind(),
    ], () => `${format}`
        .replace("{title}", player.track_title)
        .replace("{artists}", player.track_artists.join(", "))
        .replace("{artist}", player.track_artists[0] || "")
        .replace("{album}", player.track_album)
        .replace("{name}", player.name)
        .replace("{identity}", player.identity),
    ).as((title) => { name.setValue(title)})
    const revealer = Widget.Revealer({
        click_through: true,
        visible: length.bind().as(l => l > 0),
        transition: direction.bind().as(d => `slide_${d}` as const),
        setup: self => {
            let current = ""
            self.hook(player, () => {
                if (current === player.track_title)
                    return

                current = player.track_title
                self.reveal_child = true
                active.setValue(true)
                Utils.timeout(3000, () => {
                    !self.is_destroyed && (self.reveal_child = false)
                    active.setValue(false)
                })
            })
        },
        child: Widget.Box({
            children: [
                Widget.Button({
                    on_clicked: () => player.previous(),
                    visible: player.bind("can_go_prev"),
                    child: Widget.Icon(icons.mpris.prev),
                }),
                Widget.Button({
                    class_name: "play-pause",
                    on_clicked: () => player.playPause(),
                    visible: player.bind("can_play"),
                    child: Widget.Icon({
                        icon: player.bind("play_back_status").as(s => {
                            switch (s) {
                                case "Playing": return icons.mpris.playing
                                case "Paused":
                                case "Stopped": return icons.mpris.stopped
                            }
                       }),
                    }),
                }),
                Widget.Button({
                    on_clicked: () => player.next(),
                    visible: player.bind("can_go_next"),
                    child: Widget.Icon(icons.mpris.next),
                })
            ],
            vertical: false
        }),
    })

    const playericon = Widget.Icon({
        icon: Utils.merge([player.bind("entry"), monochrome.bind()], (entry => {
            const name = `${entry}${monochrome.value ? "-symbolic" : ""}`
            return icon(name, icons.fallback.audio)
        })),
    })

    return Widget.Box({
        attribute: { revealer },
        children: direction.bind().as(d => d === "right"
            ? [playericon, revealer] : [revealer, playericon]),
    })
}
export const name = Variable("")
export const progress = Variable(-1)
export const active = Variable(false)
export default () => {
    let player = getPlayer()

    const btn = PanelButton({
        class_name: "media",
        child: Widget.Icon(icons.fallback.audio),
    })

    const update = () => {
        player = getPlayer()
        btn.visible = !!player

        if (!player) {
            progress.setValue(-1)
            name.setValue("")
            return
        }

        const content = Content(player)
        const { revealer } = content.attribute
        btn.child = content
        btn.on_hover = () => { 
            revealer.reveal_child = true
            active.setValue(true)
         }
        btn.on_hover_lost = () => { 
            revealer.reveal_child = false
            active.setValue(false)
         }
    }

    return btn
        .hook(preferred, update)
        .hook(mpris, update, "notify::players")
}
