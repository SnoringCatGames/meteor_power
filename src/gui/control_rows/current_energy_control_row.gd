class_name CurrentEnergyControlRow
extends TextControlRow


const LABEL := "Energy:"
const DESCRIPTION := ""


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func get_text() -> String:
    return str(Sc.levels.session.current_energy) if \
            Sc.levels.session.has_started else \
            str(LevelSession.START_ENERGY)
