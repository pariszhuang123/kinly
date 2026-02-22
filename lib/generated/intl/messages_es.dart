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
      "Unos cuantos agradecimientos de nuestro hogar en Kinly. Descarga la app: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'Esta semana', one: 'hace # semana', other: 'hace # semanas')}";

  static String m6(partOfDay, name) => "Buen${partOfDay}, ${name}";

  static String m7(answered, total) =>
      "Basado en ${answered} de ${total} miembros";

  static String m8(current, total) => "Pregunta ${current} de ${total}";

  static String m9(link) =>
      "Compartiendo nuestro pulso del hogar en Kinly. Descarga la app: ${link}";

  static String m10(date) => "Actualizado el ${date}";

  static String m11(link) =>
      "Compartiendo nuestra vibra de casa en Kinly. Descarga la app: ${link}";

  static String m12(link) =>
      "Comparte Kinly para que juntos se sienta más ligero: ${link}";

  static String m13(code, link) =>
      "¡Bienvenido a nuestro hogar de Kinly! Introduce este código de invitación: ${code}\n\nDescarga la app de Kinly: ${link}";

  static String m14(code) => "Ya estás dentro. Bienvenido a casa.";

  static String m15(price) => "${price} al mes.";

  static String m16(current, total) => "Pregunta ${current} de ${total}";

  static String m17(period) => "Aplica a ${period}";

  static String m18(total, included, difference) =>
      "El reparto personalizado no coincide. Total: ${total}. Incluido: ${included}. Diferencia: ${difference}.";

  static String m19(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} recaudado";

  static String m20(paid, total) => "${paid} de ${total} pagadas";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} artículo por marcar', other: '${count} artículos por marcar')}";

  static String m22(name) => "Hola ${name}";

  static String m23(count) =>
      "Ver todo ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m24(name) => "No pudimos completar la solicitud de ${name}.";

  static String m25(name) => "${name} se unió a tu hogar.";

  static String m26(name) => "${name} se unió a otro hogar.";

  static String m27(names) =>
      "${names} quiere unirse a tu hogar. Mejora el plan para admitir miembros ilimitados.";

  static String m28(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} por saldar')}";

  static String m29(count) =>
      "${Intl.plural(count, one: '${count} nuevo pago para ti', other: '${count} nuevos pagos para ti')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar tu membresía del hogar. Inténtalo de nuevo.",
    ),
    "bootstrap_initializing": m0,
    "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Activa las notificaciones en los ajustes de tu teléfono para usar esto.",
        ),
    "connectionNotificationsTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Hora del recordatorio",
    ),
    "connectionNotificationsTimeSubtitle": m1,
    "connectionNotificationsToggleSubtitleOff":
        MessageLookupByLibrary.simpleMessage(
          "Activa recordatorios sobre tu hogar.",
        ),
    "connectionNotificationsToggleSubtitleOn":
        MessageLookupByLibrary.simpleMessage("Recibe un recordatorio al día."),
    "connectionNotificationsToggleTitle": MessageLookupByLibrary.simpleMessage(
      "Notificaciones diarias",
    ),
    "connectionSettingsGenericError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron actualizar los ajustes de conexión. Inténtalo de nuevo.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Controla los recordatorios diarios y el horario de notificación.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Ajustes de conexión",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar. Inténtalo de nuevo.",
    ),
    "demoAccess": MessageLookupByLibrary.simpleMessage(
      "Acceso de demostración",
    ),
    "demoAccessEmail": MessageLookupByLibrary.simpleMessage("Correo"),
    "demoAccessError": MessageLookupByLibrary.simpleMessage(
      "No se pudo iniciar sesión. Revisa tus credenciales.",
    ),
    "demoAccessPassword": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "demoAccessSubmit": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "demoAccessTapHint": m2,
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mira qué hay que hacer y quién se encarga.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Actualiza el estado y los detalles para mantener lo compartido claro.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ver cada factura que has creado y seguir los cobros.",
    ),
    "exploreShoppingSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Lista de compras",
    ),
    "exploreShoppingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ver y gestionar tus artículos compartidos.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "¿Quién se encarga?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Tarea creada.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir tarea",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Eliminar flujo",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina el flujo para todos en tu hogar.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar este flujo?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Marcar como completada",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar esta tarea. Inténtalo de nuevo.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Tarea completada.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Contexto útil",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "No se proporcionaron enlaces guía.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "No se proporcionó contexto.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles de la tarea",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Editar tarea"),
    "flowChoreViewTitle": MessageLookupByLibrary.simpleMessage("Ver tarea"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no forma parte de este hogar ahora mismo.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar este flujo.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar este flujo. Inténtalo de nuevo.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa ruta de foto no es válida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Este flujo no está disponible para actualizarse ahora mismo.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de flujos activos. Mejora el plan para tener más espacio.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de fotos de flujos. Mejora el plan para tener más espacio.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Añade un enlace si hay una forma específica de hacerlo",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Cómo hacerlo (opcional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir ese enlace. Inténtalo de nuevo.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar esta tarea. Inténtalo de nuevo.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. Noche de sacar la basura, limpiar la nevera, regar plantas",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "¿Qué hay que hacer?",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Cualquier cosa que ayude a otros a hacerlo fácilmente",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage(
      "Por qué importa",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Qué es lo ideal",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la foto",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Permite el acceso a la cámara para tomar una foto.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Abrir ajustes"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Una foto puede ayudar a que todos estén alineados",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo subir la foto. Inténtalo de nuevo.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "¿Con qué frecuencia aparece esto?",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage(
      "Una sola vez",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo aparece esto? ",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Crear flujo",
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
      "Elige una fecha de aquí a un año como máximo.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Introduce un enlace válido que empiece por http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Ponle un nombre a esta tarea.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Tareas para que todos estén alineados.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada aquí",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar las tareas. Desliza para actualizar.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Necesita atención",
    ),
    "flowListTabCurrent": MessageLookupByLibrary.simpleMessage("Actual"),
    "flowListTabFuture": MessageLookupByLibrary.simpleMessage("Próximas"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Esta versión de Kinly ya no es compatible. Instala la versión más reciente para continuar.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Actualizar Kinly",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Se necesita una actualización",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Aquí van los agradecimientos rápidos.\n\nAñade uno de esta semana.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay agradecimientos",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar los agradecimientos ahora mismo.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("Hogar"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "Un lugar privado para guardar agradecimientos rápidos.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage("Míos"),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "Mis agradecimientos",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage("Compartir"),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento. Inténtalo de nuevo.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Agradecimientos del hogar",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Hogares"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "Agradecimientos",
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
      "Ya enviaste tu respuesta esta semana.",
    ),
    "harmonyErrorCommentRequiredForMention":
        MessageLookupByLibrary.simpleMessage(
          "Añade una nota breve para enviar esta mención.",
        ),
    "harmonyErrorCommentRequiredForPublicWall":
        MessageLookupByLibrary.simpleMessage(
          "Añade una nota breve para publicar este agradecimiento.",
        ),
    "harmonyErrorComplaintNeedsSentence": MessageLookupByLibrary.simpleMessage(
      "Añade una frase clara para que sea más fácil de entender.",
    ),
    "harmonyErrorComplaintTooBrief": MessageLookupByLibrary.simpleMessage(
      "Escribe una frase corta para que sea más fácil de entender.",
    ),
    "harmonyErrorComplaintTooShort": MessageLookupByLibrary.simpleMessage(
      "Añade un poco más de detalle para que quede claro.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "El envío para este hogar no está disponible.",
    ),
    "harmonyErrorSingleMentionRequired": MessageLookupByLibrary.simpleMessage(
      "Elige a una persona para esta nota.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo de nuevo.",
    ),
    "harmonyFeedbackSingleHousemateHint": MessageLookupByLibrary.simpleMessage(
      "Escribe @ para dar feedback a 1 compañero de casa.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("Nublado"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "Parcialmente soleado",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("Lluvioso"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("Soleado"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage(
      "Tormenta eléctrica",
    ),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Algo que agradecer o ajustar esta semana?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Visible para todos en el hogar",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Guardar"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage("Guardado"),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("Vibra del hogar"),
    "houseNormCopyUrlCta": MessageLookupByLibrary.simpleMessage("Copiar URL"),
    "houseNormDoneCta": MessageLookupByLibrary.simpleMessage("Listo"),
    "houseNormEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar normas de la casa",
    ),
    "houseNormGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos generar las normas de la casa ahora mismo. Inténtalo de nuevo.",
    ),
    "houseNormOnboardingBack": MessageLookupByLibrary.simpleMessage("Atrás"),
    "houseNormOnboardingProgress": m8,
    "houseNormOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Generar normas de la casa",
    ),
    "houseNormOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Normas de la casa",
    ),
    "houseNormPromptCta": MessageLookupByLibrary.simpleMessage(
      "Crear normas de la casa",
    ),
    "houseNormPromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escribe un punto de partida compartido para cómo suele funcionar tu hogar.",
    ),
    "houseNormPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Crear normas de la casa",
    ),
    "houseNormPublishCta": MessageLookupByLibrary.simpleMessage(
      "Publicar en la web",
    ),
    "houseNormReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Genera las normas de la casa para ver su punto de partida compartido.",
    ),
    "houseNormReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Las normas de la casa no están listas",
    ),
    "houseNormReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Inténtalo de nuevo.",
    ),
    "houseNormReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar las normas de la casa",
    ),
    "houseNormReportTitle": MessageLookupByLibrary.simpleMessage(
      "Normas de la casa",
    ),
    "houseNormRepublishCta": MessageLookupByLibrary.simpleMessage(
      "Volver a publicar",
    ),
    "houseNormScenarioGuestsOption1": MessageLookupByLibrary.simpleMessage(
      "Se planifica y se habla antes",
    ),
    "houseNormScenarioGuestsOption2": MessageLookupByLibrary.simpleMessage(
      "Con avisar es suficiente",
    ),
    "houseNormScenarioGuestsOption3": MessageLookupByLibrary.simpleMessage(
      "Eso forma parte de la vida diaria aquí",
    ),
    "houseNormScenarioGuestsQuestion": MessageLookupByLibrary.simpleMessage(
      "Una amistad o pareja quiere venir. ¿Qué suele sentirse correcto?",
    ),
    "houseNormScenarioHomeIdentityOption1":
        MessageLookupByLibrary.simpleMessage(
          "Un lugar tranquilo para recargar",
        ),
    "houseNormScenarioHomeIdentityOption2":
        MessageLookupByLibrary.simpleMessage(
          "Un equilibrio entre tiempo en calma y tiempo juntos",
        ),
    "houseNormScenarioHomeIdentityOption3":
        MessageLookupByLibrary.simpleMessage(
          "Un lugar dinámico donde la gente entra y sale",
        ),
    "houseNormScenarioHomeIdentityQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En un buen día, este hogar se siente más como...",
        ),
    "houseNormScenarioPropertyContextOption1":
        MessageLookupByLibrary.simpleMessage("Somos propietarios de esta casa"),
    "houseNormScenarioPropertyContextOption2":
        MessageLookupByLibrary.simpleMessage("Alquilamos toda esta casa"),
    "houseNormScenarioPropertyContextOption3":
        MessageLookupByLibrary.simpleMessage(
          "Alquilamos habitaciones en una casa compartida",
        ),
    "houseNormScenarioPropertyContextQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Viven en esta casa de alquiler o en propiedad?",
        ),
    "houseNormScenarioRelationshipModelOption1":
        MessageLookupByLibrary.simpleMessage("Compañeros de piso"),
    "houseNormScenarioRelationshipModelOption2":
        MessageLookupByLibrary.simpleMessage("Familia"),
    "houseNormScenarioRelationshipModelOption3":
        MessageLookupByLibrary.simpleMessage("Familia y compañeros de piso"),
    "houseNormScenarioRelationshipModelQuestion":
        MessageLookupByLibrary.simpleMessage("¿Quién comparte este hogar?"),
    "houseNormScenarioRepairOption1": MessageLookupByLibrary.simpleMessage(
      "Hablarlo más pronto que tarde",
    ),
    "houseNormScenarioRepairOption2": MessageLookupByLibrary.simpleMessage(
      "Abordarlo con suavidad cuando el momento sea adecuado",
    ),
    "houseNormScenarioRepairOption3": MessageLookupByLibrary.simpleMessage(
      "Dejar pasar lo pequeño mientras no se acumule",
    ),
    "houseNormScenarioRepairQuestion": MessageLookupByLibrary.simpleMessage(
      "Algo se siente un poco tenso entre personas. ¿Qué ayuda más?",
    ),
    "houseNormScenarioResponsibilityOption1":
        MessageLookupByLibrary.simpleMessage(
          "Normalmente tenemos acuerdos claros",
        ),
    "houseNormScenarioResponsibilityOption2":
        MessageLookupByLibrary.simpleMessage(
          "Alguien se encarga cuando lo nota",
        ),
    "houseNormScenarioResponsibilityOption3":
        MessageLookupByLibrary.simpleMessage(
          "Cada quien se ocupa más bien de lo suyo",
        ),
    "houseNormScenarioResponsibilityQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Hay algo pequeño por hacer en casa. ¿Qué suele pasar?",
        ),
    "houseNormScenarioRhythmOption1": MessageLookupByLibrary.simpleMessage(
      "Normalmente bajamos el ritmo para que la casa descanse",
    ),
    "houseNormScenarioRhythmOption2": MessageLookupByLibrary.simpleMessage(
      "Depende, algunas noches son más tranquilas que otras",
    ),
    "houseNormScenarioRhythmOption3": MessageLookupByLibrary.simpleMessage(
      "Cada quien sigue con lo suyo",
    ),
    "houseNormScenarioRhythmQuestion": MessageLookupByLibrary.simpleMessage(
      "Es de noche y alguien sigue activo en casa. ¿Qué suele ser aceptable?",
    ),
    "houseNormScenarioSharedSpacesOption1":
        MessageLookupByLibrary.simpleMessage(
          "Mayormente despejada y lista para usar",
        ),
    "houseNormScenarioSharedSpacesOption2":
        MessageLookupByLibrary.simpleMessage("Vivida, pero se ordena después"),
    "houseNormScenarioSharedSpacesOption3":
        MessageLookupByLibrary.simpleMessage(
          "Un poco de desorden está bien, es una casa compartida",
        ),
    "houseNormScenarioSharedSpacesQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Llegas a la cocina al final del día. ¿Qué te resulta más cómodo?",
        ),
    "houseNormSectionEditLabel": MessageLookupByLibrary.simpleMessage(
      "Ajusta esta sección",
    ),
    "houseNormSectionEmptyError": MessageLookupByLibrary.simpleMessage(
      "Añade texto antes de guardar.",
    ),
    "houseNormSectionFallbackTitle": MessageLookupByLibrary.simpleMessage(
      "Sección",
    ),
    "houseNormSectionGuestsSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Visitas y dinámica social",
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
      "No pudimos guardar esa actualización.",
    ),
    "houseNormSectionSaveSuccess": MessageLookupByLibrary.simpleMessage(
      "Sección actualizada.",
    ),
    "houseNormSectionSharedSpacesTitle": MessageLookupByLibrary.simpleMessage(
      "Espacios compartidos",
    ),
    "houseNormShareSubject": MessageLookupByLibrary.simpleMessage(
      "Nuestras normas de la casa",
    ),
    "houseNormShareUrlCta": MessageLookupByLibrary.simpleMessage(
      "Compartir URL",
    ),
    "houseNormSummaryFramingLabel": MessageLookupByLibrary.simpleMessage(
      "Marco del resumen",
    ),
    "houseNormSummarySubtitle": MessageLookupByLibrary.simpleMessage(
      "Un punto de partida compartido, no un reglamento.",
    ),
    "houseNormSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Normas de la casa",
    ),
    "houseNormUrlCopied": MessageLookupByLibrary.simpleMessage(
      "URL de normas de la casa copiada.",
    ),
    "houseNormViewTitle": MessageLookupByLibrary.simpleMessage(
      "Ver normas de la casa",
    ),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "Pulso semanal del hogar",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir pulso",
    ),
    "housePulseShareMessage": m9,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Compartiendo nuestro pulso del hogar en Kinly",
    ),
    "housePulseUpdatedOn": m10,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir vibra",
    ),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento. Inténtalo de nuevo.",
    ),
    "houseVibeShareMessage": m11,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage(
      "Vibra de la casa",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gracias rápidos de tu hogar.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Agradecimientos",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Código de invitación copiado",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Centro del hogar. Inténtalo de nuevo.",
    ),
    "hubHouseNormsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Un punto de partida compartido sobre cómo suele funcionar este hogar.",
    ),
    "hubHouseNormsTitle": MessageLookupByLibrary.simpleMessage(
      "Normas de la casa",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación. Inténtalo de nuevo.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Aún no hay miembros activos.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cómo prefiere cada persona que funcione la convivencia.",
    ),
    "hubPreferencesTitle": MessageLookupByLibrary.simpleMessage(
      "Preferencias personales",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escanea para descargar Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Compartir la app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo rotar la invitación. Inténtalo de nuevo.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotar invitación"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitación rotada",
    ),
    "hubShareAppBody": m12,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Consigue la app de Kinly",
    ),
    "hubShareInviteBody": m13,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invitar a mi hogar de Kinly",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "Hemos notificado al dueño del hogar.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Listo"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "Este hogar no está aceptando nuevos miembros en este momento",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Sal de tu hogar actual para unirte a uno nuevo",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esa invitación ya no está activa. Pídele al dueño un nuevo código.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación no parece correcto.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar alcanzó su límite de miembros. Pídele al dueño que actualice el plan o elimine a un miembro.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No pudimos unirte a este hogar. Inténtalo de nuevo.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Introduce el código de invitación, p. ej. ABC123",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m14,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse al hogar"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" y "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "He leído y acepto los ",
    ),
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
      "Conectándote con tu hogar…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Tu hogar compartido empieza aquí.",
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
      "0 significa nada. 10 significa que marcó una diferencia real.",
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
      "Los comentarios no están disponibles ahora mismo.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudieron enviar tus comentarios. Inténtalo de nuevo.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Elige un número entre 0 y 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "No necesitas compartir comentarios ahora mismo.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "¿Kinly ha ayudado a que tu hogar funcione más fluidamente?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly necesita conexión a internet. Revisa tu señal e inténtalo de nuevo.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Intentar de nuevo"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Estás sin conexión"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Tareas ilimitadas",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Miembros ilimitados en el hogar",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos de tareas ilimitadas",
    ),
    "paywallFeatureUnlimitedSharedExpensePhotos":
        MessageLookupByLibrary.simpleMessage(
          "Fotos de gastos compartidos ilimitadas",
        ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Gastos compartidos ilimitados",
    ),
    "paywallBulletShoppingPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos de la lista de compras ilimitadas",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el paywall.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Un plan para el hogar, sin niveles ocultos.",
    ),
    "paywallPricePerMonth": m15,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "El precio no está disponible en este momento.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Mejorar a Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "La compra no se completó; puedes intentarlo de nuevo cuando quieras.",
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
      "Cuesta menos del 0,5% de tu alquiler.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Mantén tu hogar funcionando sin problemas",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu perfil personal ahora mismo. Inténtalo de nuevo.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "Preferencias personales",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("Tu perfil"),
    "planFreeLabel": MessageLookupByLibrary.simpleMessage("Mejorar a Premium"),
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
      "Guardar preferencias",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Preferencias personales",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage(
      "Empezar preferencias",
    ),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Configura tus preferencias personales para que tu hogar aprenda cómo te gustan las cosas.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Comparte tus preferencias",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Listo"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Editar"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "No pudimos guardar esa actualización.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Listo",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Escribe lo que te parezca correcto",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Ajusta la redacción de esta sección.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar preferencias",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Completa tus preferencias para generar tu informe.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "El informe de preferencias no está listo",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Inténtalo de nuevo.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el informe",
    ),
    "preferenceReportGenerationFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos terminar tu reflexión de preferencias. Vuelve atrás e inténtalo de nuevo.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "No pudimos terminar tu reflexión de preferencias. Inténtalo de nuevo pronto.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "Esto muestra lo que les resulta cómodo.",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Tu informe de preferencias",
    ),
    "preferenceReportViewTitle": MessageLookupByLibrary.simpleMessage(
      "Ver preferencias",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me siento mejor cuando las cosas se mantienen bastante ordenadas",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage(
          "Un poco de desorden está bien en el día a día",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage(
          "Me relajo con el desorden en áreas compartidas",
        ),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En espacios compartidos, ¿qué nivel de orden te funciona?",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Mensajes o texto"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("Hablar en persona cuando surge"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage(
          "Una llamada rápida es lo más fácil",
        ),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Cuando necesitas coordinar en casa, ¿qué te resulta más fácil?",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage(
          "Con suavidad, con contexto o poco a poco",
        ),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage(
          "Una mezcla: depende de la situación",
        ),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("De forma directa y clara"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Cuando alguien te comenta algo, ¿cómo prefieres recibirlo?",
        ),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage(
          "Tomarme un tiempo para calmarme primero",
        ),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage(
          "Hablarlo con suavidad en el momento adecuado",
        ),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage(
          "Hablarlo antes, en lugar de dejarlo para más tarde",
        ),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Si hay algo que abordar en casa, ¿qué ayuda más?",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Iluminación más suave o tenue"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage(
          "Iluminación equilibrada y natural",
        ),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage(
          "Iluminación brillante y bien iluminada",
        ),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En áreas compartidas, ¿qué iluminación prefieres?",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me siento mejor cuando, por lo general, todo está tranquilo",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "Un nivel moderado de ruido cotidiano me parece bien",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "El ruido no me molesta mucho: los espacios animados están bien",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Qué tan cómodo te sientes con el ruido de fondo en espacios compartidos?",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage(
          "Soy bastante sensible a los aromas fuertes",
        ),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage(
          "En general me resulta indiferente",
        ),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage(
          "Los aromas fuertes no suelen molestarme",
        ),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Qué tan cómodo te sientes con aromas fuertes (velas, comida, limpiadores)?",
        ),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage(
          "Prefiero que no me contacten después de las horas de descanso",
        ),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage(
          "Mensajes limitados o importantes están bien",
        ),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage(
          "Me parece bien que me contacten en cualquier momento",
        ),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Qué piensas de los mensajes por la noche?",
        ),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "Prefiero que me pidan permiso o llamen antes de entrar",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage(
          "Pedir permiso está bien, pero cierta flexibilidad está bien",
        ),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "En general me siento cómodo con acceso abierto",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Antes de entrar en la habitación de alguien, ¿qué te parece correcto?",
        ),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage(
          "Tener planes y estructura me ayuda",
        ),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage(
          "Una mezcla de planificación y espontaneidad",
        ),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage(
          "Dejar que las cosas fluyan me sienta mejor",
        ),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En la vida diaria en casa, ¿qué te parece más natural?",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage(
          "Las noches suelen ser más tranquilas para mí",
        ),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage(
          "Depende: algunas noches son más tranquilas que otras",
        ),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage(
          "La actividad nocturna no suele molestarme",
        ),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Por las noches, ¿qué suele funcionarte mejor?",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me acuesto y me levanto temprano",
        ),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("En un punto intermedio"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Me acuesto y me levanto tarde"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Eres más madrugador o noctámbulo?",
        ),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me siento más cómodo si los invitados son raros",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage(
          "Invitados ocasionales me parecen bien",
        ),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage(
          "Invitados frecuentes están bien para mí",
        ),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Cómo te sientes con que haya invitados en casa?",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Mayormente a lo mío"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "Una mezcla de tiempo compartido y tiempo a solas",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Pasar tiempo juntos a menudo"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En casa, ¿qué equilibrio te funciona mejor?",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina tu cuenta y cierra tu sesión. No podrás deshacerlo.",
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
      "Gestiona notificaciones y recordatorios.",
    ),
    "profileConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Ajustes de conexión",
    ),
    "profileContactEmailSubject": MessageLookupByLibrary.simpleMessage(
      "Contáctanos",
    ),
    "profileContactLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir tu app de correo. Inténtalo de nuevo.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Envía un email a support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage(
      "Contáctanos",
    ),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elimina tu cuenta de Kinly y los datos de tu perfil.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Tu cuenta se eliminará en breve. Cerraremos tu sesión.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo de nuevo.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay avatares disponibles ahora mismo. Inténtalo más tarde.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Cada avatar es único dentro de tu hogar.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Elige un avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu perfil ahora mismo.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Guardar cambios",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige un nombre de usuario y un avatar para tu hogar.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Perfil actualizado.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Editar perfil",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Introduce un nombre de usuario para continuar.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Usa 3-30 letras minúsculas o números. Puedes incluir puntos o guiones bajos en el medio.",
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
      "Ese nombre de usuario ya está en uso. Prueba otro.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Centro de información. Revisa tu conexión.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abre el hub de Notion de Kinly dentro de la app.",
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
      "Solo el dueño del hogar puede eliminar miembros.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona un miembro para eliminar. Perderá el acceso de inmediato.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar a un miembro",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Ya no tiene acceso a este hogar.",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar los miembros de tu hogar. Inténtalo de nuevo.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Comprobando los miembros de tu hogar...",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Salir de este hogar significa dejar tu espacio compartido en Kinly.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Nadie más puede asumir la propiedad ahora mismo. Inténtalo más tarde.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Eres el último miembro. Al salir se desactivará este hogar.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Saliste de tu hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona quién será el nuevo dueño antes de salir.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transferir propiedad",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Propiedad transferida. Terminando tu salida...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cierra sesión de Kinly en este dispositivo.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "No pudimos encontrar tu hogar actual. Inténtalo de nuevo.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona las preferencias de tu cuenta y el acceso al hogar.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Tu perfil está desactivado. Inicia sesión con otra dirección de correo.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "Una mezcla de momentos fluidos y pequeñas fricciones.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage("Mixto"),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana surgió algo de tensión.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Necesita atención",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "Unas cuantas respuestas más darán una imagen más clara.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage(
      "Aún en formación",
    ),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "En general estable, con algunas áreas por mejorar.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Bien en general",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Puede ser el momento de un pequeño reinicio.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Se recomienda reinicio",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Hay fricción notable ahora mismo.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Se necesita reinicio",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "Casi todo bien, con unos pequeños tropiezos.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "Casi todo bien",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana las cosas fueron fluidas.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage("Todo va bien"),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "La tensión es alta. Un reinicio rápido puede ayudar.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "Tensión alta",
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
      "Un momento de calma antes de mostrarlo.",
    ),
    "reflectiveHouseNormsPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflejando lo que compartió este hogar.",
    ),
    "reflectiveHouseNormsSecondary": MessageLookupByLibrary.simpleMessage(
      "Una referencia compartida, no un reglamento.",
    ),
    "reflectiveHousePrimary": MessageLookupByLibrary.simpleMessage(
      "Poniendo en palabras las expectativas del hogar.",
    ),
    "reflectiveHouseSecondary": MessageLookupByLibrary.simpleMessage(
      "Para que todos sepan qué esperar.",
    ),
    "reflectivePersonalPrimary": MessageLookupByLibrary.simpleMessage(
      "Reflejando lo que compartiste.",
    ),
    "reflectivePersonalSecondary": MessageLookupByLibrary.simpleMessage(
      "Para que otros entiendan qué te resulta cómodo.",
    ),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Importe"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Importe",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Introduce la parte de cada persona. Asegúrate de que el total coincida con el importe de arriba.",
    ),
    "shareCreateCyclePeriod": m17,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. Compra del súper",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Descripción",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para crear esto ahora mismo.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear. Inténtalo de nuevo.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de facturas activas. Mejora el plan para tener más espacio.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Los borradores no pueden repetirse hasta que añadas un reparto.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar los miembros de tu hogar.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Contexto opcional visible para todos",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Contexto"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "Necesitas al menos dos miembros del hogar para compartir.",
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
      "Elegir importes",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Repartir por igual",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cómo queremos repartirlo?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo aplica esto?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura creada.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Crear factura"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Introduce un importe válido mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Introduce un importe válido para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos una persona para esta factura.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "No puedes incluir solo a ti en esta factura. Añade al menos otra persona.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Asegúrate de que el reparto personalizado sume el importe de arriba.",
    ),
    "shareCreateValidationCustomSumBreakdown": m18,
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Introduce una descripción.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos una persona para repartir el importe.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Elige con qué frecuencia se repite.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Elige cómo repartir antes de configurar la repetición.",
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
      "Repártelo para que todos sepan su parte antes de publicarlo.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Las facturas mantienen el dinero claro, sin recordatorios incómodos.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay facturas",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tus facturas. Desliza para actualizar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Pagado"),
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
      "¿Eliminar?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "No se pudo eliminar. Inténtalo de nuevo.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura eliminada.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Las facturas activas están bloqueadas para edición.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "Esta factura ahora es un plan y no se puede editar.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "Editar esta factura no está disponible en este momento.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Los ciclos recurrentes están bloqueados para edición aquí.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Esto queda bloqueado hasta que alguien tome esta factura.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Los repartos están bloqueados porque alguien ya pagó. Aún puedes actualizar la descripción y las notas.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Factura actualizada.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo finalizar el plan. Inténtalo de nuevo.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "Finalizar plan",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Finalizando…",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "Finalizar plan",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "Esto detiene los futuros ciclos de facturación.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "¿Finalizar plan recurrente?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Plan finalizado.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Editar factura"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Estás al día con esta persona.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "No pudimos marcar esa factura como saldada. Inténtalo de nuevo.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Marcar como saldado",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage("Saldado."),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage("Por saldar"),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Confirmar recepción",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "No pudimos confirmar la recepción de las facturas.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Confirmando…",
    ),
    "shoppingAmountHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. 2 cartones",
    ),
    "shoppingAmountLabel": MessageLookupByLibrary.simpleMessage("Cuántos"),
    "shoppingArchiveCta": MessageLookupByLibrary.simpleMessage(
      "Artículos comprados",
    ),
    "shoppingArchiveSharePromptBody": MessageLookupByLibrary.simpleMessage(
      "¿Quieres crear una factura en borrador a partir de estos artículos?",
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
      "Cualquier detalle útil (marca, tamaño, etc.)",
    ),
    "shoppingContextLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "shoppingCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir artículo",
    ),
    "shoppingDelete": MessageLookupByLibrary.simpleMessage("Eliminar artículo"),
    "shoppingDeleteConfirmBody": MessageLookupByLibrary.simpleMessage(
      "Esto elimina el artículo de tu lista de compras compartida.",
    ),
    "shoppingDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar este artículo?",
    ),
    "shoppingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Artículo de compra",
    ),
    "shoppingEditTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles del artículo",
    ),
    "shoppingEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No hay artículos por comprar.",
    ),
    "shoppingErrorItemAlreadyCompletedByOther":
        MessageLookupByLibrary.simpleMessage(
          "Otra persona ya marcó este artículo.",
        ),
    "shoppingListTitle": MessageLookupByLibrary.simpleMessage(
      "Lista de compras",
    ),
    "shoppingMarkCompleteCta": MessageLookupByLibrary.simpleMessage(
      "Marcar como completado",
    ),
    "shoppingNameHint": MessageLookupByLibrary.simpleMessage("p. ej. Leche"),
    "shoppingNameLabel": MessageLookupByLibrary.simpleMessage("Nombre"),
    "shoppingPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Añadir una foto",
    ),
    "shoppingPhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Añade una foto para ayudar con la compra",
    ),
    "shoppingPhotoReplaceLabel": MessageLookupByLibrary.simpleMessage(
      "Ayuda a alguien a saber qué comprar",
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
      "¿Qué quieres hacer a continuación?",
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
      "Disfruta la calma: Kinly te avisará cuando algo necesite tu atención.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Tómate un respiro",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Todo al día por hoy",
    ),
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
      "Agradecimientos del hogar",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "Mis agradecimientos",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de agradecimientos",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "Hay nuevos agradecimientos esperándote.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte Kinly para que puedan hacer la vida compartida más fácil.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a tus amigos a Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir invitación",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Mejorar el hogar",
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
      "Tu hogar está creciendo. Mejora el plan para dar la bienvenida a más personas.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Alguien quiere unirse a tu hogar",
    ),
    "todayShareActiveSubtitle": m28,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar Share en este momento.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Importe saldado",
    ),
    "todaySharePaidUnseen": m29,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Factura"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Por saldar"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Saldado"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente acogedor y calmado cuando la gente pasa tiempo junta.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social acogedor",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente fácil de vivir para todos.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage(
      "Un hogar equilibrado",
    ),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente relajado y abierto a cambiar día a día.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "Flujo relajado",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar apoya el espacio y la tranquilidad.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Calma independiente",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Completa las preferencias para ver la vibra del hogar.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay suficientes datos",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar muestra una mezcla de estilos de comodidad, influida por cómo le gusta vivir a cada persona.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("Un hogar mixto"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente calmado, con energía suave y ritmos tranquilos.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage(
      "Cuidado tranquilo",
    ),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente activo, con gente en compañía.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Energía social"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente estable, con cuidado mostrado a través de hábitos diarios.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Calma constante"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar funciona mejor con rutinas claras y planes compartidos.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Ritmo estructurado",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente cálido y acogedor, con gente a menudo junta.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social cálido",
    ),
    "weeklyRewriteCta": MessageLookupByLibrary.simpleMessage(
      "Enviar con calma con Kinly",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirte a tu hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
