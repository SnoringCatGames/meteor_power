tool
class_name GameAnnotators
extends SurfacerAnnotators


const COMMAND := "COMMAND"


const _GAME_LEVEL_SPECIFIC_ANNOTATORS := [
    ScaffolderAnnotatorTypes.RULER,
    ScaffolderAnnotatorTypes.LEVEL,
    ScaffolderAnnotatorTypes.SURFACES,
    ScaffolderAnnotatorTypes.GRID_INDICES,
    ScaffolderAnnotatorTypes.PATH_PRESELECTION,
    COMMAND,
]

var command_annotator: CommandAnnotator


func _init().(
        _SURFACER_CHARACTER_SUB_ANNOTATORS,
        _GAME_LEVEL_SPECIFIC_ANNOTATORS,
        _SURFACER_DEFAULT_ENABLEMENT,
        SurfacerCharacterAnnotator) -> void:
    pass


func _create_annotator(annotator_type: String) -> void:
    assert(!is_annotator_enabled(annotator_type))
    match annotator_type:
        COMMAND:
            if Sc.level != null:
                command_annotator = CommandAnnotator.new()
                annotation_layer.add_child(command_annotator)
        _:
            ._create_annotator(annotator_type)


func _destroy_annotator(annotator_type: String) -> void:
    assert(is_annotator_enabled(annotator_type))
    match annotator_type:
        COMMAND:
            if command_annotator != null:
                command_annotator.queue_free()
                command_annotator = null
        _:
            ._destroy_annotator(annotator_type)
