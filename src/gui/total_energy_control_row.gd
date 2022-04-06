class_name TotalEnergyControlRow
extends TextControlRow


const LABEL := "Total:"
const DESCRIPTION := ""


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func get_text() -> String:
    return str(Sc.level_session.total_energy) if \
            Sc.level_session.has_started else \
            str(LevelSession.START_ENERGY)
