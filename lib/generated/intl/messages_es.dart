// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(env) => "Iniciando Kinly (${env})";

  static String m1(time) => "Programado para las ${time}";

  static String m2(current) => "Acceso demo: ${current} de 7 toques";

  static String m3(appName) =>
      "Hecho con ${appName} - Juntos se siente más ligero";

  static String m4(link) =>
      "Algunos reconocimientos de nuestro hogar en Kinly. Descarga la app: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'Esta semana', one: 'hace # semana', other: 'hace # semanas')}";

  static String m6(partOfDay, name) =>
      "${Intl.select(partOfDay, {'morning': 'Buenos días, ${name}', 'afternoon': 'Buenas tardes, ${name}', 'evening': 'Buenas noches, ${name}', 'other': 'Hola, ${name}'})}";

  static String m7(answered, total) =>
      "Basado en ${answered} de ${Intl.plural(total, one: '${total} miembro', other: '${total} miembros')}";

  static String m8(current, total) => "${current}/${total}";

  static String m9(link) =>
      "Compartiendo el pulso de nuestro hogar en Kinly. Descarga la app: ${link}";

  static String m10(date) => "Actualizado ${date}";

  static String m11(link) =>
      "Compartiendo el ambiente de nuestro hogar en Kinly. Descarga la app: ${link}";

  static String m12(link) =>
      "Haz la vida compartida más fácil con Kinly: ${link}";

  static String m13(code, link) =>
      "Únete a nuestro hogar de Kinly con este código de invitación: ${code}\n\nDescarga Kinly: ${link}";

  static String m14(code) => "Te uniste a tu hogar.";

  static String m15(price) => "${price} al mes";

  static String m16(current, total) => "${current}/${total}";

  static String m17(period) => "Aplica a ${period}";

  static String m18(total, included, difference) =>
      "La división no coincide. Total: ${total}. Incluido: ${included}. Diferencia: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} cobrados";

  static String m20(paid, total) =>
      "${paid} de ${Intl.plural(total, one: '${total} pago', other: '${total} pagos')} pagados";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} artículo por comprar', other: '${count} artículos por comprar')}";

  static String m22(name) => "Hola ${name}";

  static String m23(count) =>
      "Ver todo ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "No se pudo completar la solicitud de ${name}.";

  static String m25(name) => "${name} se unió a tu hogar.";

  static String m26(name) => "${name} se unió a otro hogar.";

  static String m27(names) =>
      "${names} quiere unirse a tu hogar. Actualiza para añadir más miembros.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} por liquidar')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} nuevo pago para ti', other: '${count} nuevos pagos para ti')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo actualizar tu membresía del hogar.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Primero activa las notificaciones en los ajustes de tu teléfono.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Hora del recordatorio",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "Activa recordatorios para tu hogar.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage(
          "Recibe un recordatorio cada día.",
        ),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "Recordatorios diarios",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron actualizar los ajustes de notificación.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Controla los recordatorios diarios y el horario.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notificaciones",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage("Acceso demo"),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage(
      "Correo electrónico",
    ),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "No se pudo iniciar sesión. Revisa tus credenciales.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mira qué hay que hacer y quién lo está haciendo.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mantén claras las cosas compartidas.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mira cada factura que has creado y sigue los cobros.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Lista de compras",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ver y gestionar artículos de compra compartidos.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "¿Quién hará esto?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tarea creada.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir tarea",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Eliminar tarea",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina la tarea para todos en tu hogar.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar esta tarea?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Marcar como completada",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar esta tarea.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Tarea completada.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles útiles",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles de la tarea",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Editar tarea"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Esa persona no forma parte de este hogar en este momento.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar esta tarea.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar esta tarea.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa foto no pertenece a este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Esta tarea no se puede actualizar ahora mismo.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de tareas activas. Actualiza para más.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de fotos de tareas. Actualiza para más.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Añade un enlace si hay una forma específica",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Cómo hacerlo (opcional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir ese enlace.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar esta tarea.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. sacar la basura, limpiar la nevera, regar las plantas",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "¿Qué hay que hacer?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Cualquier cosa que ayude a otros a hacerlo",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Por qué importa",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Cómo se ve bien hecho",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la foto.",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Permite acceso a la cámara para tomar una foto.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Abrir ajustes"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Añade una foto para que todos estén alineados",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo subir la foto.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "¿Con qué frecuencia ocurre esto?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "Una sola vez",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo vence?",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Crear tarea",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Guardar cambios",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tarea actualizada.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a alguien.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha dentro del próximo año.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Introduce un enlace válido que empiece con http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Introduce el nombre de una tarea.",
    ),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("Ver tarea"),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Las tareas mantienen a todos alineados.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada aquí",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar las tareas. Desliza para actualizar.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Necesita atención",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("Actuales"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("Próximas"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Esta versión de Kinly ya no es compatible. Actualiza para continuar.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Actualizar Kinly",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Se necesita actualización",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Añade un reconocimiento de esta semana.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay reconocimientos",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar los reconocimientos en este momento.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("Hogar"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "Un lugar privado para agradecimientos rápidos.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("Míos"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "Mis reconocimientos",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("Compartir"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Reconocimientos del hogar",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Hogares"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "Reconocimientos",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage(
      "Personas",
    ),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "Añade contexto si ayuda",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Nota opcional",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "Ya enviaste tu comentario esta semana.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "Añade una nota breve antes de enviar esta mención.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "Añade una nota breve antes de publicar este reconocimiento.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "Añade una frase clara.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "Escribe una frase corta para que quede claro.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "Añade un poco más de detalle.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "La retroalimentación semanal no está disponible ahora mismo.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "Elige una persona para esta nota.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal.",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "Escribe @ para mencionar a 1 compañero de casa.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("Nublado"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "Parcialmente soleado",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("Lluvioso"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("Soleado"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage("Tormenta"),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Qué salió bien o qué necesita ajustarse esta semana?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Visible para todos en el hogar",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Guardar"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("Guardado"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("Ambiente del hogar"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("Copiar URL"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("Hecho"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar normas del hogar",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudieron generar las normas del hogar en este momento.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("Atrás"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Generar",
    ),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Ambiente del hogar",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage("Generar"),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Convierte tus respuestas en una guía compartida.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Crear normas del hogar",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "Publicar en la web",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Genera las normas del hogar para verlas.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Las normas del hogar no están listas",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Por favor, inténtalo de nuevo.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar las normas del hogar",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage(
      "Normas del hogar",
    ),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage(
      "Volver a publicar",
    ),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "Preguntar antes",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "Avisar",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "Totalmente normal",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Traer invitados?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage("Hogar tranquilo"),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage("Hogar equilibrado"),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage("Hogar social"),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage("¿La mejor descripción?"),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("Propio"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("Alquiler completo"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage("Alquiler de habitación"),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage("Este hogar es:"),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("Compañeros de casa"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("Familia"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("Mixto"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("¿Quién vive aquí?"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "Hablar pronto",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "Elegir el momento",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "Dejar pasar las cosas pequeñas",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Tensión?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage("Acuerdos claros"),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage("Quien lo note"),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage(
          "Cada quien se encarga de lo suyo",
        ),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage("¿Pequeñas tareas?"),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "Bajar el ritmo",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "Depende",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "Cada quien a lo suyo",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Tarde en la noche?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage("Limpia"),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("Vivida"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage(
          "No pasa nada si está desordenada",
        ),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage("¿Cocina por la noche?"),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "Editar esta sección",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "Añade texto antes de guardar.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "Sección",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Invitados y dinámica social",
    ),
    "houseNormSectionHomeIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Identidad del hogar",
    ),
    "houseNormSectionRepairStyleTitle": MessageLookupByLibrary.simpleMessage(
      "Estilo para reparar tensiones",
    ),
    "houseNormSectionResponsibilityFlowTitle":
        MessageLookupByLibrary.simpleMessage("Flujo de responsabilidades"),
    "houseNormSectionRhythmQuietTitle": MessageLookupByLibrary.simpleMessage(
      "Ritmo y silencio",
    ),
    "houseNormSectionSaveCta": MessageLookupByLibrary.simpleMessage("Guardar"),
    "houseNormSectionSaveFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar esa actualización.",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "Sección actualizada.",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "Espacios compartidos",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "Nuestras normas del hogar",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage(
      "Compartir URL",
    ),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "Resumen",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "Una guía, no un reglamento.",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Normas del hogar",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "URL de las normas del hogar copiada.",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "Ver normas del hogar",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "Pulso semanal del hogar",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir pulso",
    ),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Compartiendo el pulso de nuestro hogar en Kinly",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir ambiente",
    ),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage(
      "Ambiente del hogar",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Agradecimientos rápidos de tu hogar.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Reconocimientos",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Código de invitación copiado",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Centro del hogar.",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Una guía de cómo funciona este hogar.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage(
      "Normas del hogar",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Todavía no hay miembros activos.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cómo le gusta a cada persona que funcione la vida compartida.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage("Preferencias"),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escanea para descargar Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Comparte la app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo rotar la invitación.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotar invitación"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitación rotada",
    ),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage("Consigue Kinly"),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invitar a mi hogar de Kinly",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "Hemos notificado al propietario del hogar.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Hecho"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "Este hogar no está aceptando nuevos miembros en este momento",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Primero deja tu hogar actual.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esa invitación ha caducado. Pídele al propietario una nueva.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación parece incorrecto.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar ha alcanzado el límite de miembros. Pídele al propietario que actualice el plan o elimine a alguien.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo unir a este hogar.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Introduce el código de invitación (p. ej. ABC123)",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse al hogar"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" y la "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage("Acepto los "),
    "login_privacy": MessageLookupByLibrary.simpleMessage(
      "Política de privacidad",
    ),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "Juntos se siente más ligero",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage(
      "Términos del servicio",
    ),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "Continuar con Apple",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Continuar con Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "Estás conectado a un hogar.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Conectando con tu hogar...",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Crea o únete a un hogar.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "Escribe @ para mencionar a alguien",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Gestionar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Centro del hogar"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Elige una puntuación para continuar.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "0 significa que nada. 10 significa que marcó una diferencia real.",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "¿Cómo podría Kinly apoyar mejor a tu hogar?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir el siguiente paso.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Marcó una diferencia real",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Nada"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "La retroalimentación no está disponible ahora mismo.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo enviar tu comentario.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Elige un número entre 0 y 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "No necesitas compartir comentarios ahora mismo.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "¿Kinly ha ayudado a que tu hogar funcione con más fluidez?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "No hay conexión a internet. Inténtalo de nuevo.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Intentar de nuevo"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Estás sin conexión"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Tareas ilimitadas",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Miembros ilimitados",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos de tareas ilimitadas",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Facturas ilimitadas",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos de compras ilimitadas",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el paywall.",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage("Fotos de facturas ilimitadas"),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Un plan para el hogar. Sin niveles ocultos.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "El precio no está disponible en este momento.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Actualizar a Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "La compra no se completó.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Ahora tienes Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Seguir con el plan gratuito",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Menos del 0.5% de tu alquiler.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Haz que tu hogar funcione sin problemas",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar tu perfil personal.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "Preferencias personales",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("Tu perfil"),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage(
      "Actualizar a Premium",
    ),
    "planPremiumActiveBody": MessageLookupByLibrary.simpleMessage(
      "Disfruta acceso ilimitado a todas las funciones.",
    ),
    "planPremiumActiveTitle": MessageLookupByLibrary.simpleMessage(
      "Tienes Premium",
    ),
    "planPremiumLabel": MessageLookupByLibrary.simpleMessage("Premium"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("Atrás"),
    "preferenceOnboardingProgress": m16,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Guardar",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Tu ambiente",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage("Empezar"),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ayuda a tu hogar a entender qué funciona para ti.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Define tu ambiente",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Hecho"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Editar"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar esa actualización.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Hecho",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Escribe lo que te parezca correcto",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Edita esta sección.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar preferencias",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Completa tus preferencias para generar tu informe.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Las preferencias no están listas",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Por favor, inténtalo de nuevo.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el informe",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar la reflexión de tus preferencias. Vuelve atrás e inténtalo de nuevo.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar la reflexión de tus preferencias. Inténtalo de nuevo pronto.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "Esto muestra lo que les resulta cómodo.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Tus preferencias",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "Ver preferencias",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage("Mantener ordenado"),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("Un poco desordenado"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage("No pasa nada si hay desorden"),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage("¿Espacio compartido?"),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Mensaje"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("En persona"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("Llamada"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage("¿La mejor forma de contactarte?"),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage("Con delicadeza"),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage("Depende"),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("Directo"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage("¿Cuando algo va mal?"),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("Primero enfriarse"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage("Hablarlo después"),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("Hablar pronto"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage("¿Si algo no va bien?"),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Suave"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("Equilibrada"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("Brillante"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage("¿Iluminación?"),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage("Silencio, por favor"),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage("Ruido normal"),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage("No pasa nada si hay ambiente"),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage("¿Nivel de ruido?"),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage("Sensible"),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("Neutral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage("No me molesta"),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage("¿Olores fuertes?"),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage("Preferiría que no"),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage("Solo si es importante"),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage("En cualquier momento"),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage("¿Mensajes por la noche?"),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage("Tocar primero"),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage("Normalmente tocar"),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage("Puerta abierta"),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage("¿Entrar en tu habitación?"),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage("Estructurada"),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage("Algo de estructura"),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("Ir sobre la marcha"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage("¿Vida diaria?"),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage("Noches tranquilas"),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage("Depende"),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage("No pasa nada si hay actividad"),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage("¿Por las noches?"),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("Madrugador"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("Intermedio"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Noctámbulo"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage("¿Estilo de sueño?"),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage("Rara vez"),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("A veces"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage("A menudo"),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage("¿Invitados?"),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Mayormente cada uno a lo suyo"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage("Una mezcla de ambas"),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Pasar mucho tiempo juntos"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage("¿Energía en casa?"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina tu cuenta y cierra tu sesión. No puedes deshacerlo.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar tu cuenta?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Perderás acceso a tareas, historial e invitaciones.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "¿Salir de este hogar?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona recordatorios y alertas.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Notificaciones",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Contáctanos",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir tu aplicación de correo.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escribe a support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage(
      "Contáctanos",
    ),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elimina tu cuenta y tus datos de Kinly.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Tu cuenta se eliminará en breve. Cerraremos tu sesión.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay avatares disponibles en este momento.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Cada avatar debe ser único en tu hogar.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Elige un avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar tu perfil.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Guardar cambios",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige un nombre de usuario y un avatar.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Perfil actualizado.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Editar perfil",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Introduce un nombre de usuario.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Usa entre 3 y 30 letras minúsculas o números. Los puntos y guiones bajos pueden ir en medio.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "letras, números, . o _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre de usuario",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("tu nombre de usuario"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "Ese nombre de usuario ya está en uso.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Centro de información. Revisa tu conexión.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abre el centro de Notion de Kinly dentro de la app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage(
      "Centro de información",
    ),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Eliminar miembro",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige quién perderá el acceso a este hogar.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar a un miembro",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "No hay otros miembros para eliminar ahora mismo.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Solo el propietario del hogar puede eliminar miembros.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige un miembro para eliminar. Perderá el acceso de inmediato.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar a un miembro",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Ya no tiene acceso a este hogar.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar los miembros de tu hogar.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Comprobando miembros del hogar...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Saldrás de este espacio compartido de Kinly.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Nadie más puede asumir la propiedad en este momento.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Eres el último miembro. Salir desactivará este hogar.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Saliste de tu hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige quién será el nuevo propietario antes de salir.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transferir propiedad",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Propiedad transferida. Finalizando salida...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cierra sesión de Kinly en este dispositivo.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "No se pudo encontrar tu hogar actual.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona tu cuenta y el acceso a tu hogar.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Tu perfil está desactivado. Inicia sesión con otra dirección de correo.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "Algunas cosas funcionaron. Otras no.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("Mixto"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Apareció algo de tensión esta semana.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Necesita atención",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "Algunas revisiones más darán una imagen más clara.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage(
      "Todavía formándose",
    ),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Mayormente estable, con algo de margen para mejorar.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "En general bien",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Quizá sea momento de un pequeño reinicio.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Se recomienda reiniciar",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Hay fricción notable en este momento.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Se necesita reinicio",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "Mayormente fluido, con algunos baches.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "Mayormente fluido",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "Las cosas se sintieron fluidas esta semana.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage(
      "Funciona sin problemas",
    ),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "La tensión es alta. Reinicien pronto.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "Alta tensión",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crear una tarea",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Tarea"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Añadir una factura",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Factura"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Añadir rápido"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "Entendido.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "Preparando esto con cuidado.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "Una breve pausa antes de mostrarlo.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflejando lo que este hogar compartió.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "Una guía compartida, no un reglamento.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "Poniendo en palabras las expectativas de tu hogar.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "Para que las expectativas estén claras.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflejando lo que compartiste.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "Para que otros entiendan qué te resulta cómodo.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Cantidad"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Cantidad",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Introduce la parte de cada persona. El total debe coincidir con la cantidad de arriba.",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. Compra del supermercado",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Descripción",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para crear esto ahora mismo.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear la factura.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de facturas activas. Actualiza para más.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Los borradores no pueden repetirse hasta que añadas una división.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar los miembros de tu hogar.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Nota opcional que todos pueden ver",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "Necesitas al menos dos miembros del hogar para compartir una factura.",
    ),
    "shareCreateRecurrenceEveryLabel": MessageLookupByLibrary.simpleMessage(
      "Cada",
    ),
    "shareCreateRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Repetir",
    ),
    "shareCreateRecurrenceToggleLabel": MessageLookupByLibrary.simpleMessage(
      "Recurrente",
    ),
    "shareCreateRecurrenceUnitDay": MessageLookupByLibrary.simpleMessage("Día"),
    "shareCreateRecurrenceUnitMonth": MessageLookupByLibrary.simpleMessage(
      "Mes",
    ),
    "shareCreateRecurrenceUnitWeek": MessageLookupByLibrary.simpleMessage(
      "Semana",
    ),
    "shareCreateRecurrenceUnitYear": MessageLookupByLibrary.simpleMessage(
      "Año",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "Elegir cantidades",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Dividir por igual",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cómo debe dividirse esto?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo aplica esto?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura creada.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Añadir factura"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Introduce una cantidad mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Introduce una cantidad válida para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos una persona para esta factura.",
        ),
    "shareCreateValidationCustomSinglePayer":
        MessageLookupByLibrary.simpleMessage("Añade al menos otra persona."),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Asegúrate de que la división sume el importe total.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Introduce una descripción.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos una persona para dividir esta factura.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Elige con qué frecuencia se repite esto.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Elige una división antes de hacer esto recurrente.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha dentro del rango permitido.",
    ),
    "shareCreatedListActiveAmount": m19,
    "shareCreatedListActiveSubtitle": m20,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Divídela antes de publicarla para que todos sepan su parte.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Las facturas hacen que el dinero esté claro.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay facturas",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar tus facturas. Desliza para actualizar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Pagada"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "Tus facturas",
    ),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina el borrador para todos.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar factura?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "No se pudo eliminar la factura.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura eliminada.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Las facturas activas no se pueden editar.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "Esta factura ahora es un plan y no se puede editar aquí.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "Esta factura no se puede editar ahora mismo.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Los ciclos recurrentes no se pueden editar aquí.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Esto permanece bloqueado hasta que alguien tome esta factura.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Las divisiones están bloqueadas porque alguien ya pagó. Aún puedes actualizar la descripción y las notas.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura actualizada.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo finalizar el plan.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "Finalizar plan",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Finalizando...",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "Finalizar plan",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "Esto detiene futuros ciclos de facturación.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "¿Finalizar plan recurrente?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Plan finalizado.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Editar factura"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Ya estás al día con esta persona.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "No se pudo marcar este pago como liquidado.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Marcar como liquidado",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Marcado como liquidado.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Por liquidar",
    ),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Confirmar recepción",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "No se pudo confirmar este pago.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Confirmando...",
    ),
    "shoppingAllItemsBought": MessageLookupByLibrary.simpleMessage(
      "Todo comprado",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. 2 cartones",
    ),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("Cantidad"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "Artículos comprados",
    ),
    "shoppingArchiveDraftBillCreated": MessageLookupByLibrary.simpleMessage(
      "Borrador de factura creado",
    ),
    "shoppingArchiveItemsBought": MessageLookupByLibrary.simpleMessage(
      "Artículos marcados como comprados y eliminados",
    ),
    "shoppingArchiveShareNo": MessageLookupByLibrary.simpleMessage("No"),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "¿Crear un borrador de factura con estos artículos?",
    ),
    "shoppingArchiveSharePromptTitle": MessageLookupByLibrary.simpleMessage(
      "¿Crear factura?",
    ),
    "shoppingArchiveShareYes": MessageLookupByLibrary.simpleMessage("Sí"),
    "shoppingCardSubtitle": m21,
    "shoppingCardTitle": MessageLookupByLibrary.simpleMessage(
      "Lista de compras",
    ),
    "shoppingContextHint": MessageLookupByLibrary.simpleMessage(
      "Marca, tamaño o notas",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir artículo de compra",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("Eliminar artículo"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "Esto lo elimina de la lista de compras compartida.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar este artículo?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Artículo de compra",
    ),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar artículo de compra",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No hay artículos de compra.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "Alguien ya marcó esto como comprado.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage(
      "Lista de compras",
    ),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "Marcar como comprado",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("p. ej. Leche"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("Nombre"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage("Añadir foto"),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Añadir una foto",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Ayuda a otros a comprar el artículo correcto",
    ),
    "shoppingSubmitAdd": MessageLookupByLibrary.simpleMessage(
      "Añadir artículo",
    ),
    "shoppingSubmitEdit": MessageLookupByLibrary.simpleMessage(
      "Guardar cambios",
    ),
    "shoppingTabPending": MessageLookupByLibrary.simpleMessage("Por comprar"),
    "shoppingValidationName": MessageLookupByLibrary.simpleMessage(
      "Introduce el nombre del artículo.",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "¿Qué quieres hacer?",
    ),
    "startReturningTitle": m22,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Añadir tarea"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage(
      "Añadir factura",
    ),
    "todayAddSheetShopping": MessageLookupByLibrary.simpleMessage(
      "Añadir artículo de compra",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir a tu hogar",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Nada necesita tu atención ahora mismo.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Tómate un respiro",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage("Todo al día"),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manténganse alineados y compartan responsabilidades.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a tus compañeros de piso",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("nuevo hoy"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Tareas"),
    "todayFlowSeeAll": m23,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Esto es lo que necesita atención hoy.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Activas"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "Reconocimientos del hogar",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "Mis reconocimientos",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Reconocimientos",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "Tienes nuevos reconocimientos esperándote.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte Kinly con amigos.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a amigos a Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir invitación",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Actualizar hogar",
    ),
    "todayMemberCapResolutionFailed": m24,
    "todayMemberCapResolutionJoined": m25,
    "todayMemberCapResolutionSuperseded": m26,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "Alguien",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Ignorar",
    ),
    "todayMemberCapSubtitle": m27,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "Actualiza para añadir más personas.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Alguien quiere unirse a tu hogar",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron actualizar las facturas ahora mismo.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cantidad liquidada",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Facturas"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Por liquidar"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Liquidadas"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente acogedor y tranquilo juntos.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social y acogedor",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente equilibrado.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage(
      "Hogar equilibrado",
    ),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente relajado y flexible.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "Flujo relajado",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar valora el espacio y la tranquilidad.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Calma independiente",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Completa las preferencias para ver el ambiente de tu hogar.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay suficientes datos",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar tiene estilos de vida mixtos.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("Hogar mixto"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente calmado y amable.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage(
      "Cuidado tranquilo",
    ),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente activo y social.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Energía social"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente estable y constante.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Calma estable"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar funciona mejor con rutinas y planes.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Ritmo estructurado",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente cálido y acogedor.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social y cálido",
    ),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Envíalo con calma con Kinly",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
