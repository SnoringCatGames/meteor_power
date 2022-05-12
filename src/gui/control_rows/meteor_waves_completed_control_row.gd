class_name MeteorWavesCompletedControlRow
extends TextControlRow


const LABEL := "Waves survived:"
const DESCRIPTION := ""


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func get_text() -> String:
    return str(Sc.levels.session.waves_completed_count) if \
            is_instance_valid(Sc.levels.session) else \
            "—"
