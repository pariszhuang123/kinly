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

  static String m1(time) => "Programado para ${time}";

  static String m2(appName) =>
      "Hecho con ${appName} - Juntos se siente más ligero";

  static String m3(link) =>
      "Compartiendo un vistazo de nuestro muro de gratitud de Kinly. Descarga la app: ${link}";

  static String m4(count) =>
      "Muro de gratitud ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'Esta semana', one: 'hace # semana', other: 'hace # semanas')}";

  static String m6(partOfDay, name) => "Buen${partOfDay}, ${name}";

  static String m7(link) =>
      "Comparte Kinly para que compartir se sienta más ligero: ${link}";

  static String m8(code, link) =>
      "¡Bienvenido a nuestro hogar de Kinly! Introduce este código de invitación: ${code}\n\nDescarga la app de Kinly: ${link}";

  static String m9(code) => "Te uniste con el código: ${code}";

  static String m10(price) => "${price} al mes para todo tu hogar.";

  static String m11(current, total) => "Question ${current} of ${total}";

  static String m12(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} cobrados";

  static String m13(paid, total) => "${paid} de ${total} pagados";

  static String m14(count) =>
      "Ver todo ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m15(name) => "We could not complete ${name}\'s request.";

  static String m16(name) => "${name} joined your home.";

  static String m17(name) => "${name} joined another home.";

  static String m18(names) =>
      "${names} wants to join your home. Upgrade to support unlimited members.";

  static String m19(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} pagos pendientes')}";

  static String m20(count) =>
      "${Intl.plural(count, one: '${count} pago nuevo para ti', other: '${count} pagos nuevos para ti')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar tu membresía del hogar. Inténtalo de nuevo.",
    ),
    "bootstrap_initializing": m0,
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
      "Controla los recordatorios diarios y la hora de notificación.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Ajustes de conexión",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar. Inténtalo de nuevo.",
    ),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Revisa cada Flow y mantén los flows en movimiento",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Explora más maneras de hacer que tu hogar se sienta más ligero.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ve cada Share que has creado y haz seguimiento de los cobros.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("Asignar a"),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Flow creado.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("Añadir Flow"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Eliminar flow",
    ),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina el flow para todos en tu hogar.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar este flow?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Completar flow",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No pudimos completar el flow. Inténtalo de nuevo.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Flow completado.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Más detalles",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "No se proporcionó un enlace de instrucciones.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "Aún no hay notas.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles del Flow",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Editar Flow"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no se puede asignar en este momento.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar este flow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar el flow. Inténtalo de nuevo.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa ruta de foto no es válida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Este flow no se puede actualizar ahora mismo.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de flows activos. Actualiza para añadir más.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de fotos de referencia. Elimina una o actualiza el plan.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Pega un enlace a un vídeo o documento (opcional)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Enlace de instrucciones",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir ese enlace. Inténtalo de nuevo.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar este flow. Inténtalo de nuevo.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Dale a tu flow un título corto y claro",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre del Flow",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Añade contexto o recordatorios opcionales",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la foto",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Se requiere permiso de cámara para tomar una foto.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Abrir ajustes"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Añade una foto para mostrar cómo se ve “bien hecho”",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo subir la foto. Inténtalo de nuevo.",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Frecuencia de repetición",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("Una vez"),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "Fecha del Flow",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Añadir flow",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Guardar flow",
    ),
    "flowChoreUpdateSuccess": MessageLookupByLibrary.simpleMessage(
      "Flow actualizado.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a alguien para asignar este flow.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de hasta un año a partir de hoy.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Introduce un enlace válido que empiece por http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Ponle un nombre al flow.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Añade tu primera rutina para que todos sepan qué hacer.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada en Flow",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar Flow. Desliza para actualizar.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("Vencido"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Esta versión de Kinly ya no es compatible. Instala la versión más reciente para continuar.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Actualizar Kinly",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Actualización requerida",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte un momento soleado para empezar a llenar el muro.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay publicaciones de gratitud",
    ),
    "gratitudeWallFooter": m2,
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir este muro",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir ahora mismo. Inténtalo de nuevo.",
    ),
    "gratitudeWallShareMessage": m3,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "gratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Momentos compartidos de tu hogar.",
    ),
    "gratitudeWallTitleCount": m4,
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "¿Qué hace que el hogar se sienta así?",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Añadir una nota (opcional)",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "Ya compartiste tu ánimo de esta semana.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No puedes enviar feedback para este hogar.",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "Elige un ánimo antes de enviar.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo de nuevo.",
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
      "¿Cómo se siente tu hogar esta semana?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Compartir esto en el muro de gratitud",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Enviar feedback"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "¡Gracias! Tu feedback se guardó.",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lee agradecimientos rápidos y pequeños momentos de aprecio.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Código de invitación copiado",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Hub. Inténtalo de nuevo.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación. Inténtalo de nuevo.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Aún no hay miembros activos.",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escanea para descargar Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Comparte la app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo rotar la invitación. Inténtalo de nuevo.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotar invitación"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitación rotada",
    ),
    "hubShareAppBody": m7,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Consigue la app de Kinly",
    ),
    "hubShareInviteBody": m8,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invitar a mi hogar de Kinly",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "We\'ve notified the home owner.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Done"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "This home isn\'t accepting new members right now",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Ya estás en otro hogar. Sal de él antes de unirte a uno nuevo.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esta invitación ya no está activa. Pídele al dueño un nuevo código.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación no parece correcto.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar ha alcanzado su límite de miembros. Pídele al dueño que actualice el plan o elimine a un miembro.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesiA3n para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No pudimos unirte a este hogar. Inténtalo de nuevo.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Introduce el código de invitación",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m9,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
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
      "Ya formas parte de un hogar.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Comprobando el estado de la membresía…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Aún no te has unido a un hogar.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explorar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Necesitas elegir una puntuación para continuar.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "El Net Promoter Score nos ayuda a saber cómo lo estamos haciendo. Elige un número de 0 (nada probable) a 10 (extremadamente probable).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "¿Qué podemos mejorar?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir el siguiente paso.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Extremadamente probable",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Nada probable"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para enviar feedback ahora mismo.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo enviar tu feedback. Inténtalo de nuevo.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Elige una puntuación entre 0 y 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "Este feedback no es necesario ahora mismo.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "¿Qué tan probable es que recomiendes Kinly a un amigo?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly necesita una conexión a internet. Revisa tu señal e inténtalo de nuevo.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Intentar de nuevo"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Estás sin conexión"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Flows ilimitados",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Miembros del hogar ilimitados",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos ilimitadas en Flow",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Gastos compartidos ilimitados",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el paywall.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Un solo plan para el hogar, sin niveles ocultos.",
    ),
    "paywallPricePerMonth": m10,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Los precios no están disponibles en este momento.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Actualizar a Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "La compra no se completó. Puedes intentarlo de nuevo cuando quieras.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Ahora tienes Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Continuar con hogar gratis",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Actualiza tu hogar por menos del 0,5% de tu renta.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Trae más armonía a tu hogar",
    ),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("Back"),
    "preferenceOnboardingProgress": m11,
    "preferenceOnboardingSubmit": MessageLookupByLibrary.simpleMessage(
      "Save preferences",
    ),
    "preferenceOnboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Personal preferences",
    ),
    "preferencePromptCta": MessageLookupByLibrary.simpleMessage(
      "Start preferences",
    ),
    "preferencePromptSubtitle": MessageLookupByLibrary.simpleMessage(
      "Set up your personal preferences so your home can learn how you like things.",
    ),
    "preferencePromptTitle": MessageLookupByLibrary.simpleMessage(
      "Share your preferences",
    ),
    "preferenceReportDoneCta": MessageLookupByLibrary.simpleMessage("Done"),
    "preferenceReportEditCta": MessageLookupByLibrary.simpleMessage("Edit"),
    "preferenceReportEditError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t save that update.",
    ),
    "preferenceReportEditSectionDone": MessageLookupByLibrary.simpleMessage(
      "Done",
    ),
    "preferenceReportEditSectionHint": MessageLookupByLibrary.simpleMessage(
      "Write what feels right for you",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Adjust the wording for this section.",
    ),
    "preferenceReportEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit preferences",
    ),
    "preferenceReportEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Complete your preferences to generate your report.",
    ),
    "preferenceReportEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Preference report not ready",
    ),
    "preferenceReportErrorBody": MessageLookupByLibrary.simpleMessage(
      "Please try again.",
    ),
    "preferenceReportErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Could not load report",
    ),
    "preferenceReportTitle": MessageLookupByLibrary.simpleMessage(
      "Your preference report",
    ),
    "preferenceScenarioCleanlinessSharedSpaceOption1":
        MessageLookupByLibrary.simpleMessage(
          "I feel best when things are kept fairly tidy",
        ),
    "preferenceScenarioCleanlinessSharedSpaceOption2":
        MessageLookupByLibrary.simpleMessage("Some clutter is okay day-to-day"),
    "preferenceScenarioCleanlinessSharedSpaceOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m relaxed about mess in shared areas",
        ),
    "preferenceScenarioCleanlinessSharedSpaceQuestion":
        MessageLookupByLibrary.simpleMessage(
          "In shared spaces, how tidy feels good to you?",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Messaging or text"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage(
          "Talking in person when it comes up",
        ),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage("A quick call feels easiest"),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When you need to coordinate at home, what works best for you?",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage(
          "Gently, with context or easing in",
        ),
    "preferenceScenarioCommunicationDirectnessOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix - it depends on the situation",
        ),
    "preferenceScenarioCommunicationDirectnessOption3":
        MessageLookupByLibrary.simpleMessage("Directly and clearly"),
    "preferenceScenarioCommunicationDirectnessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When something small is on your mind, how do you like to say it?",
        ),
    "preferenceScenarioConflictResolutionOption1":
        MessageLookupByLibrary.simpleMessage("Taking time to cool off first"),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage(
          "Gently checking in at the right moment",
        ),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage(
          "Talking it through sooner rather than later",
        ),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "If something feels a bit off between people at home, what usually helps you most?",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Softer or dimmer lighting"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage("Balanced, natural lighting"),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage("Bright, well-lit spaces"),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "In shared areas, what kind of lighting do you tend to feel most comfortable with?",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m most comfortable when things are generally quiet",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "A moderate level of everyday noise feels fine",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "Noise doesn\'t bother me much - lively spaces are okay",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How ok are you with background noise in shared spaces?",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m quite sensitive to strong scents",
        ),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("I\'m mostly neutral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage(
          "Strong scents don\'t really bother me",
        ),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How do strong scents (candles, cooking, cleaners) feel to you?",
        ),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage(
          "I prefer not to be contacted after quiet hours",
        ),
    "preferenceScenarioPrivacyNotificationsOption2":
        MessageLookupByLibrary.simpleMessage(
          "Limited or important messages are okay",
        ),
    "preferenceScenarioPrivacyNotificationsOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m fine being contacted anytime",
        ),
    "preferenceScenarioPrivacyNotificationsQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How do you feel about messages or notifications at night?",
        ),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "I prefer people to ask or knock first",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage(
          "Asking is nice, but flexibility is okay",
        ),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "I\'m generally comfortable with open access",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "About entering each other\'s rooms, what feels right to you?",
        ),
    "preferenceScenarioRoutinePlanningOption1":
        MessageLookupByLibrary.simpleMessage(
          "Having plans and structure helps me",
        ),
    "preferenceScenarioRoutinePlanningOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix of planning and spontaneity",
        ),
    "preferenceScenarioRoutinePlanningOption3":
        MessageLookupByLibrary.simpleMessage("Going with the flow feels best"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When it comes to daily life at home, what feels most natural to you?",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage(
          "Evenings tend to be quieter for me",
        ),
    "preferenceScenarioScheduleQuietHoursOption2":
        MessageLookupByLibrary.simpleMessage(
          "It depends - some nights are quieter than others",
        ),
    "preferenceScenarioScheduleQuietHoursOption3":
        MessageLookupByLibrary.simpleMessage(
          "Nighttime activity doesn\'t usually bother me",
        ),
    "preferenceScenarioScheduleQuietHoursQuestion":
        MessageLookupByLibrary.simpleMessage(
          "As the day winds down, what usually feels okay to you at home?",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage("Earlier nights and mornings"),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("Somewhere in the middle"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage("Later nights and mornings"),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "When do you usually feel most in sync with your sleep routine?",
        ),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "I\'m most comfortable with guests being rare",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage("Occasional guests feel fine"),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage(
          "Frequent guests are okay with me",
        ),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "How do you generally feel about guests coming over to the home?",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Mostly doing my own thing"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "A mix of shared time and solo time",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Spending time together often"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "At home, what balance usually feels best for you?",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina tu cuenta y cierra sesión. No podrás deshacerlo.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar tu cuenta?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Perderás acceso a Flow, el historial y las invitaciones.",
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
      "Enviar email a support@makinglifeeasie.com",
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
      "Ese nombre de usuario ya está en uso. Prueba con otro.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Info Hub. Revisa tu conexión.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abrir el hub de Notion de Kinly dentro de la app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Eliminar miembro",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige quién perderá acceso a este hogar.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar a un miembro",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "Ahora mismo no hay otros miembros para eliminar.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Solo el dueño del hogar puede eliminar miembros.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona un miembro para eliminar. Perderá acceso de inmediato.",
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
      "Comprobando los miembros del hogar...",
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
      "Eres el último miembro. Si te vas, este hogar se desactivará para todos.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Saliste de tu hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona quién será el nuevo dueño antes de irte.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transferir propiedad",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Propiedad transferida. Finalizando tu salida...",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cerrar sesión de Kinly en este dispositivo.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "No pudimos encontrar tu hogar actual. Inténtalo de nuevo.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona las preferencias de tu cuenta y el acceso al hogar.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Perfil y hogar",
    ),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Your profile is deactivated. Please sign in with another email address.",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Añadir un Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar un Share",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Añadir rápido"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Importe"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Importe",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Introduce la parte de cada persona. Asegúrate de que el total coincida con el importe de arriba.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "p. ej., compra del súper",
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
      "Has alcanzado el límite gratuito de 10 shares activos o en borrador. Cierra o cancela uno para continuar.",
    ),
    "shareCreateErrorRecurrenceDraft": MessageLookupByLibrary.simpleMessage(
      "Los borradores no pueden repetirse hasta que agregues una división.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar los miembros de tu hogar.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Contexto opcional que todos pueden ver",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
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
      "Reparto personalizado",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Repartir automáticamente",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "Tipo de reparto",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo aplica?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("Share creado."),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Introduce un importe válido mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Introduce un importe válido para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "El reparto personalizado necesita al menos dos personas.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "Reparte el importe entre al menos dos personas cuando uses un reparto personalizado.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Asegúrate de que el reparto personalizado sume el importe de arriba.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Introduce una descripción.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos dos personas para dividir el importe.",
        ),
    "shareCreateValidationRecurrence": MessageLookupByLibrary.simpleMessage(
      "Elige con qué frecuencia se repite.",
    ),
    "shareCreateValidationRecurrenceSplit":
        MessageLookupByLibrary.simpleMessage(
          "Elige cómo dividir antes de configurar una repetición.",
        ),
    "shareCreateValidationStartDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio.",
    ),
    "shareCreateValidationStartDateRange": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha dentro del rango permitido.",
    ),
    "shareCreatedListActiveAmount": m12,
    "shareCreatedListActiveSubtitle": m13,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Divídelo para asignar a cada persona antes de publicarlo.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Crea un Share para verlo aquí.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay shares",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu share. Desliza para actualizar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage(
      "Saldado",
    ),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("Tu share"),
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
      "Share eliminado.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Los gastos activos no se pueden editar.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "Este gasto se convirtió en un plan y no se puede editar.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "No puedes editar este gasto ahora mismo.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Los ciclos recurrentes no se editan aquí.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Está bloqueado hasta que asignes el share a alguien.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Las divisiones están bloqueadas porque alguien ya pagó. Aun así puedes actualizar la descripción y las notas.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Share actualizado.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Editar Share"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Estás al día con esta persona.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "No pudimos marcar ese share como pagado. Inténtalo de nuevo.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Marcar como pagado",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Pago registrado.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Pago pendiente",
    ),
    "sharePaidDetailAcknowledge": MessageLookupByLibrary.simpleMessage(
      "Reconocer pagos",
    ),
    "sharePaidDetailAcknowledgeError": MessageLookupByLibrary.simpleMessage(
      "No pudimos reconocer estos pagos.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Marcando...",
    ),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Añadir Flow"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("Añadir Share"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir a tu hogar",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Disfruta de la calma: Kinly te avisará cuando algo necesite tu atención.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Tómate un respiro",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Todo al día por hoy",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte tu invitación para poder dividir las tareas juntos.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a tu compañero de piso",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("nuevo hoy"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m14,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Esto es lo que fluye hoy en tu hogar.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Activos"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayGratitudeOpenCta": MessageLookupByLibrary.simpleMessage("Ver muro"),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud del hogar",
    ),
    "todayGratitudeUnreadBody": MessageLookupByLibrary.simpleMessage(
      "Hay nuevas publicaciones de gratitud esperándote.",
    ),
    "todayInviteFriendsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte Kinly con un amigo para que también pueda traer más armonía a su hogar.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a amigos a Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir invitación",
    ),
    "todayMemberCapPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Upgrade home",
    ),
    "todayMemberCapResolutionFailed": m15,
    "todayMemberCapResolutionJoined": m16,
    "todayMemberCapResolutionSuperseded": m17,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "Someone",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Ignore",
    ),
    "todayMemberCapSubtitle": m18,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "A member is requesting access. Upgrade to support unlimited members.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Someone wants to join your home",
    ),
    "todayShareActiveSubtitle": m19,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar Share en este momento.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pagado a ti",
    ),
    "todaySharePaidUnseen": m20,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Por pagar"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage(
      "Pagado a mí",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
