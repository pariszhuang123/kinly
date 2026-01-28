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

  static String m2(current) => "Acceso de demo: ${current} de 7 toques";

  static String m3(appName) =>
      "Hecho con ${appName} - Juntos se siente más ligero";

  static String m4(link) =>
      "Compartiendo un vistazo de nuestro muro de gratitud en Kinly. Descarga la app: ${link}";

  static String m5(weeks) =>
      "${Intl.plural(weeks, zero: 'Esta semana', one: 'Hace # semana', other: 'Hace # semanas')}";

  static String m6(partOfDay, name) => "Buen ${partOfDay}, ${name}";

  static String m7(answered, total) =>
      "Basado en ${answered} de ${total} miembros";

  static String m8(link) =>
      "Compartiendo nuestro pulso del hogar en Kinly. Descarga la app: ${link}";

  static String m9(date) => "Actualizado el ${date}";

  static String m10(link) =>
      "Compartiendo la vibra de nuestra casa en Kinly. Descarga la app: ${link}";

  static String m11(link) =>
      "Comparte Kinly para que juntos se sienta más ligero: ${link}";

  static String m12(code, link) =>
      "¡Bienvenido a nuestro hogar de Kinly! Ingresa este código de invitación: ${code}\n\nDescarga la app de Kinly: ${link}";

  static String m13(code) => "Ya estás dentro. Bienvenido a casa.";

  static String m14(price) => "${price} al mes.";

  static String m15(current, total) => "Pregunta ${current} de ${total}";

  static String m16(period) => "Aplica a ${period}";

  static String m17(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} recaudado";

  static String m18(paid, total) => "${paid} de ${total} pagadas";

  static String m19(name) => "Hola ${name}";

  static String m20(count) =>
      "Ver todo: ${Intl.plural(count, one: '(#)', other: '(#)')}";

  static String m21(name) => "No pudimos completar la solicitud de ${name}.";

  static String m22(name) => "${name} se unió a tu hogar.";

  static String m23(name) => "${name} se unió a otro hogar.";

  static String m24(names) =>
      "${names} quiere unirse a tu hogar. Actualiza para admitir miembros ilimitados.";

  static String m25(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} por saldar')}";

  static String m26(count) =>
      "${Intl.plural(count, one: '${count} nuevo pago hacia ti', other: '${count} nuevos pagos hacia ti')}";

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
      "Controla los recordatorios diarios y el horario de notificaciones.",
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
      "Mira qué hay que hacer y quién se encarga.",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Explora más formas de mantener tu hogar más ligero.",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mira cada cuenta que has creado y haz seguimiento de cobros.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage(
      "¿Quién se encarga?",
    ),
    "flowChoreCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Flujo creado.",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir flujo",
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
      "Marcar como completado",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar el flujo. Inténtalo de nuevo.",
    ),
    "flowChoreDetailCompletionSuccess": MessageLookupByLibrary.simpleMessage(
      "Flujo completado.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Contexto útil",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "No se proporcionaron enlaces de guía.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "No se proporcionó contexto.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles del flujo",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Editar flujo"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no forma parte de este hogar en este momento.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar este flujo.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar el flujo. Inténtalo de nuevo.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa ruta de foto no es válida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Este flujo no se puede actualizar en este momento.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Llegaste al límite gratuito de flujos activos. Actualiza para tener más espacio.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Llegaste al límite gratuito de fotos de flujos. Actualiza para tener más espacio.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Agrega un enlace si hay una forma específica de hacerlo",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Cómo hacerlo (opcional)",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir ese enlace. Inténtalo de nuevo.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar este flujo. Inténtalo de nuevo.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "p. ej.: Noche de basura, limpiar el refrigerador, regar plantas",
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
      "Cómo se ve bien hecho",
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
      "Flujo actualizado.",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a alguien, o déjalo abierto para cualquiera.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha hasta un año a partir de hoy.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Ingresa un enlace válido que empiece con http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Ponle un nombre al flujo.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Los flujos mantienen a todos alineados.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada aquí",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar los flujos. Desliza para actualizar.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage(
      "Necesita atención",
    ),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Esta versión de Kinly ya no es compatible. Instala la versión más reciente para continuar.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Actualizar Kinly",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Se necesita actualización",
    ),
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Aquí viven los pequeños agradecimientos.\n\nEmpieza con un momento de esta semana.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay publicaciones de gratitud",
    ),
    "gratitudeWallErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la gratitud en este momento.",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallHouseTab": MessageLookupByLibrary.simpleMessage("Hogar"),
    "gratitudeWallPersonalSummary": MessageLookupByLibrary.simpleMessage(
      "Tu espacio privado para mensajes amables.",
    ),
    "gratitudeWallPersonalTab": MessageLookupByLibrary.simpleMessage(
      "Personal",
    ),
    "gratitudeWallPersonalTitle": MessageLookupByLibrary.simpleMessage(
      "Tu muro personal de gratitud",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir este muro",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento. Inténtalo de nuevo.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "gratitudeWallStatsHomes": MessageLookupByLibrary.simpleMessage("Hogares"),
    "gratitudeWallStatsMentions": MessageLookupByLibrary.simpleMessage(
      "Gracias",
    ),
    "gratitudeWallStatsPeople": MessageLookupByLibrary.simpleMessage(
      "Personas",
    ),
    "gratitudeWallWeeksAgo": m5,
    "greetingPartOfDay": m6,
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "¿Qué ha estado contribuyendo a este sentir en casa?",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "¿Algo que te gustaría compartir?",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "Ya compartiste tu estado de ánimo para esta semana.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No puedes enviar comentarios para este hogar.",
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
      "Compártelo con tu hogar",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage(
      "Enviar comentarios",
    ),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "¡Gracias! Tus comentarios se guardaron.",
    ),
    "homeVibeCoverage": m7,
    "homeVibeTitle": MessageLookupByLibrary.simpleMessage("Vibra del hogar"),
    "housePulseCardHeader": MessageLookupByLibrary.simpleMessage(
      "Pulso semanal del hogar",
    ),
    "housePulseShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir pulso",
    ),
    "housePulseShareMessage": m8,
    "housePulseShareTitle": MessageLookupByLibrary.simpleMessage(
      "Compartiendo nuestro pulso del hogar en Kinly",
    ),
    "housePulseUpdatedOn": m9,
    "houseVibeShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir vibra",
    ),
    "houseVibeShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir en este momento. Inténtalo de nuevo.",
    ),
    "houseVibeShareMessage": m10,
    "houseVibeShareTitle": MessageLookupByLibrary.simpleMessage(
      "Vibra del hogar",
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
      "No se pudo cargar el Centro. Inténtalo de nuevo.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación. Inténtalo de nuevo.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Aún no hay miembros activos.",
    ),
    "hubPreferencesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cómo vive cada persona la convivencia.",
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
    "hubShareAppBody": m11,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Obtén la app de Kinly",
    ),
    "hubShareInviteBody": m12,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invitar a mi hogar de Kinly",
    ),
    "join_blocked_body": MessageLookupByLibrary.simpleMessage(
      "Hemos notificado al propietario del hogar.",
    ),
    "join_blocked_cta": MessageLookupByLibrary.simpleMessage("Listo"),
    "join_blocked_title": MessageLookupByLibrary.simpleMessage(
      "Este hogar no está aceptando nuevos miembros en este momento",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Deja tu hogar actual para unirte a uno nuevo",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esa invitación ya no está activa. Pídele al propietario un nuevo código.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación no parece correcto.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar ha alcanzado su límite de miembros. Pídele al propietario que actualice el plan o quite a un miembro.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No pudimos unirte a este hogar. Inténtalo de nuevo.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Ingresa el código de invitación, p. ej.: ABC123",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirme"),
    "join_success": m13,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" y la "),
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
    "manual_invite_cta": MessageLookupByLibrary.simpleMessage(
      "¿Tienes un enlace de invitación?",
    ),
    "manual_invite_placeholder": MessageLookupByLibrary.simpleMessage(
      "Pega el enlace o el código de invitación",
    ),
    "manual_invite_saved": MessageLookupByLibrary.simpleMessage(
      "Invitación guardada. Continúa para iniciar sesión.",
    ),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "Estás conectado a un hogar.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Conectándote con tu hogar…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Tu hogar compartido comienza aquí.",
    ),
    "mentionFieldHint": MessageLookupByLibrary.simpleMessage(
      "Escribe @ para mencionar",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explorar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Centro"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Elige una puntuación para continuar.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "Elige un número del 0 (nada útil) al 10 (extremadamente útil).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "¿Qué podría hacer Kinly mejor para tu hogar?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir el siguiente paso.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Extremadamente útil",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Nada útil"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para enviar comentarios en este momento.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudieron enviar tus comentarios. Inténtalo de nuevo.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Elige una puntuación entre 0 y 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "No necesitas compartir comentarios en este momento.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "¿Kinly ha sido útil para tu hogar hasta ahora?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly necesita conexión a internet. Revisa tu señal e inténtalo de nuevo.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Intentar de nuevo"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Estás sin conexión"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Flujos ilimitados",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Miembros ilimitados del hogar",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos ilimitadas de flujos",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Gastos compartidos ilimitados",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el paywall.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Un plan por hogar, sin niveles ocultos.",
    ),
    "paywallPricePerMonth": m14,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "El precio no está disponible en este momento.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Actualizar a Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Compra no completada: puedes intentarlo de nuevo en cualquier momento.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Ahora tienes Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Mantener el plan gratuito",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Tu mejora a nivel de hogar por menos del 0.5% de tu alquiler.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Trae más armonía a tu hogar",
    ),
    "personalMentionsTitle": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfileLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu perfil personal en este momento. Inténtalo de nuevo.",
    ),
    "personalProfileMentions": MessageLookupByLibrary.simpleMessage(
      "Menciones personales",
    ),
    "personalProfilePreferences": MessageLookupByLibrary.simpleMessage(
      "Preferencias personales",
    ),
    "personalProfileTitle": MessageLookupByLibrary.simpleMessage("Tu perfil"),
    "preferenceOnboardingBack": MessageLookupByLibrary.simpleMessage("Atrás"),
    "preferenceOnboardingProgress": m15,
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
      "Escribe lo que te resulte natural",
    ),
    "preferenceReportEditSectionPrompt": MessageLookupByLibrary.simpleMessage(
      "Ajusta el texto de esta sección.",
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
      "No pudimos completar tu reflexión de preferencias. Vuelve y vuelve a intentarlo.",
    ),
    "preferenceReportGenerationMissing": MessageLookupByLibrary.simpleMessage(
      "No pudimos completar tu reflexión de preferencias. Inténtalo de nuevo pronto.",
    ),
    "preferenceReportReadOnlyNote": MessageLookupByLibrary.simpleMessage(
      "Esto muestra lo que les resulta cómodo a ellos.",
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
          "En espacios compartidos, ¿qué tan ordenado te hace sentir bien?",
        ),
    "preferenceScenarioCommunicationChannelOption1":
        MessageLookupByLibrary.simpleMessage("Mensajería o texto"),
    "preferenceScenarioCommunicationChannelOption2":
        MessageLookupByLibrary.simpleMessage("Hablar en persona cuando surja"),
    "preferenceScenarioCommunicationChannelOption3":
        MessageLookupByLibrary.simpleMessage(
          "Una llamada rápida se siente más fácil",
        ),
    "preferenceScenarioCommunicationChannelQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Cuando necesitas coordinar en casa, ¿qué te funciona mejor?",
        ),
    "preferenceScenarioCommunicationDirectnessOption1":
        MessageLookupByLibrary.simpleMessage(
          "Con suavidad, con contexto o entrando poco a poco",
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
          "Tomarme tiempo para calmarme primero",
        ),
    "preferenceScenarioConflictResolutionOption2":
        MessageLookupByLibrary.simpleMessage(
          "Hacer un check-in suave en el momento adecuado",
        ),
    "preferenceScenarioConflictResolutionOption3":
        MessageLookupByLibrary.simpleMessage("Hablarlo antes que después"),
    "preferenceScenarioConflictResolutionQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Si algo se siente un poco raro entre personas en casa, ¿qué suele ayudarte más?",
        ),
    "preferenceScenarioEnvironmentLightOption1":
        MessageLookupByLibrary.simpleMessage("Iluminación más suave o tenue"),
    "preferenceScenarioEnvironmentLightOption2":
        MessageLookupByLibrary.simpleMessage(
          "Iluminación equilibrada y natural",
        ),
    "preferenceScenarioEnvironmentLightOption3":
        MessageLookupByLibrary.simpleMessage(
          "Espacios brillantes y bien iluminados",
        ),
    "preferenceScenarioEnvironmentLightQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En áreas compartidas, ¿qué tipo de iluminación te hace sentir más cómodo?",
        ),
    "preferenceScenarioEnvironmentNoiseOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me siento más cómodo cuando en general hay silencio",
        ),
    "preferenceScenarioEnvironmentNoiseOption2":
        MessageLookupByLibrary.simpleMessage(
          "Un nivel moderado de ruido cotidiano me parece bien",
        ),
    "preferenceScenarioEnvironmentNoiseOption3":
        MessageLookupByLibrary.simpleMessage(
          "El ruido no me molesta mucho; los espacios animados están bien",
        ),
    "preferenceScenarioEnvironmentNoiseQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Qué tan bien llevas el ruido de fondo en espacios compartidos?",
        ),
    "preferenceScenarioEnvironmentScentOption1":
        MessageLookupByLibrary.simpleMessage(
          "Soy bastante sensible a los aromas fuertes",
        ),
    "preferenceScenarioEnvironmentScentOption2":
        MessageLookupByLibrary.simpleMessage("Soy mayormente neutral"),
    "preferenceScenarioEnvironmentScentOption3":
        MessageLookupByLibrary.simpleMessage(
          "Los aromas fuertes no me molestan mucho",
        ),
    "preferenceScenarioEnvironmentScentQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Cómo te sientan los aromas fuertes (velas, cocina, limpiadores)?",
        ),
    "preferenceScenarioPrivacyNotificationsOption1":
        MessageLookupByLibrary.simpleMessage(
          "Prefiero que no me contacten después de las horas de silencio",
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
          "¿Cómo te sientes con los mensajes por la noche?",
        ),
    "preferenceScenarioPrivacyRoomEntryOption1":
        MessageLookupByLibrary.simpleMessage(
          "Prefiero que me pidan permiso o toquen antes",
        ),
    "preferenceScenarioPrivacyRoomEntryOption2":
        MessageLookupByLibrary.simpleMessage(
          "Pedir permiso es agradable, pero la flexibilidad está bien",
        ),
    "preferenceScenarioPrivacyRoomEntryOption3":
        MessageLookupByLibrary.simpleMessage(
          "En general me siento cómodo con el acceso abierto",
        ),
    "preferenceScenarioPrivacyRoomEntryQuestion":
        MessageLookupByLibrary.simpleMessage(
          "Sobre entrar en las habitaciones de los demás, ¿qué te parece bien?",
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
        MessageLookupByLibrary.simpleMessage("Ir con el flujo se siente mejor"),
    "preferenceScenarioRoutinePlanningQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En la vida diaria en casa, ¿qué se siente más natural para ti?",
        ),
    "preferenceScenarioScheduleQuietHoursOption1":
        MessageLookupByLibrary.simpleMessage(
          "Las tardes suelen ser más tranquilas para mí",
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
          "Al terminar el día, ¿qué suele estar bien para ti en casa?",
        ),
    "preferenceScenarioScheduleSleepTimingOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me acuesto y me levanto más temprano",
        ),
    "preferenceScenarioScheduleSleepTimingOption2":
        MessageLookupByLibrary.simpleMessage("En un punto intermedio"),
    "preferenceScenarioScheduleSleepTimingOption3":
        MessageLookupByLibrary.simpleMessage(
          "Me acuesto y me levanto más tarde",
        ),
    "preferenceScenarioScheduleSleepTimingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "¿Cómo es tu horario de sueño y despertar?",
        ),
    "preferenceScenarioSocialHostingOption1":
        MessageLookupByLibrary.simpleMessage(
          "Me siento más cómodo si las visitas son raras",
        ),
    "preferenceScenarioSocialHostingOption2":
        MessageLookupByLibrary.simpleMessage(
          "Visitas ocasionales me parecen bien",
        ),
    "preferenceScenarioSocialHostingOption3":
        MessageLookupByLibrary.simpleMessage(
          "Visitas frecuentes me parecen bien",
        ),
    "preferenceScenarioSocialHostingQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En general, ¿cómo te sientes con que haya visitas en casa?",
        ),
    "preferenceScenarioSocialTogethernessOption1":
        MessageLookupByLibrary.simpleMessage("Más bien estar a mi aire"),
    "preferenceScenarioSocialTogethernessOption2":
        MessageLookupByLibrary.simpleMessage(
          "Una mezcla de tiempo compartido y tiempo a solas",
        ),
    "preferenceScenarioSocialTogethernessOption3":
        MessageLookupByLibrary.simpleMessage("Pasar tiempo juntos a menudo"),
    "preferenceScenarioSocialTogethernessQuestion":
        MessageLookupByLibrary.simpleMessage(
          "En casa, ¿qué equilibrio suele sentirse mejor para ti?",
        ),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Dejar el hogar",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina tu cuenta y cerrará tu sesión. No podrás deshacerlo.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar tu cuenta?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Perderás acceso a Flow, al historial y a las invitaciones.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "¿Dejar este hogar?",
    ),
    "profileConnectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Administra notificaciones y recordatorios.",
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
      "Envía un correo a support@makinglifeeasie.com",
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
      "Tu cuenta se eliminará pronto. Cerraremos tu sesión.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo de nuevo.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay avatares disponibles en este momento. Inténtalo de nuevo pronto.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Cada avatar es único dentro de tu hogar.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Elige un avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu perfil en este momento.",
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
      "Ingresa un nombre de usuario para continuar.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Usa 3–30 letras minúsculas o números. Puedes incluir puntos o guiones bajos en el medio.",
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
      "No se pudo cargar el Centro de información. Revisa tu conexión.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abre el hub de Kinly en Notion dentro de la app.",
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
      "No hay otros miembros para eliminar en este momento.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Solo el propietario del hogar puede eliminar miembros.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona a un miembro para eliminarlo. Perderá el acceso de inmediato.",
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
      "Dejar este hogar significa salir de tu espacio compartido en Kinly.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Dejar el hogar",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Nadie más puede asumir la propiedad en este momento. Inténtalo de nuevo más tarde.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Eres el último miembro. Al salir se desactivará este hogar.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Dejaste tu hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona quién será el nuevo propietario antes de irte.",
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
      "Administra las preferencias de tu cuenta y el acceso al hogar.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Perfil y hogar",
    ),
    "profile_deactivated_message": MessageLookupByLibrary.simpleMessage(
      "Tu perfil está desactivado. Inicia sesión con otra dirección de correo.",
    ),
    "pulseCloudySteadySummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió mixta y estable.",
    ),
    "pulseCloudySteadyTitle": MessageLookupByLibrary.simpleMessage(
      "Mixto y estable",
    ),
    "pulseCloudyTenseSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió mixta, con algo de tensión.",
    ),
    "pulseCloudyTenseTitle": MessageLookupByLibrary.simpleMessage(
      "Mixto con tensión",
    ),
    "pulseFormingSummary": MessageLookupByLibrary.simpleMessage(
      "Unos cuantos check-ins más ayudan.",
    ),
    "pulseFormingTitle": MessageLookupByLibrary.simpleMessage(
      "Aún en formación",
    ),
    "pulsePartlySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se sintió bien, con cuidado presente.",
    ),
    "pulsePartlySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Bien con cuidado",
    ),
    "pulseRainySupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió más pesada, pero hubo cuidado presente.",
    ),
    "pulseRainySupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Pesado pero con apoyo",
    ),
    "pulseRainyUnsupportedSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió pesada. Puede ayudar tener apoyo.",
    ),
    "pulseRainyUnsupportedTitle": MessageLookupByLibrary.simpleMessage(
      "Pesado, se necesita apoyo",
    ),
    "pulseSunnyBumpySummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió mayormente bien, con algunos baches.",
    ),
    "pulseSunnyBumpyTitle": MessageLookupByLibrary.simpleMessage(
      "Mayormente bien",
    ),
    "pulseSunnyCalmSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se sintió cálido y tranquilo esta semana.",
    ),
    "pulseSunnyCalmTitle": MessageLookupByLibrary.simpleMessage(
      "Cálido y tranquilo",
    ),
    "pulseThunderstormSummary": MessageLookupByLibrary.simpleMessage(
      "Esta semana se sintió tensa. La amabilidad importa ahora mismo.",
    ),
    "pulseThunderstormTitle": MessageLookupByLibrary.simpleMessage(
      "Tenso en este momento",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crear un flujo",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flujo"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Añadir una cuenta",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Añadir rápido"),
    "reflectiveAcknowledgementTitle": MessageLookupByLibrary.simpleMessage(
      "Entendido.",
    ),
    "reflectiveGenericPrimary": MessageLookupByLibrary.simpleMessage(
      "Armando esto con cuidado.",
    ),
    "reflectiveGenericSecondary": MessageLookupByLibrary.simpleMessage(
      "Un momento tranquilo antes de mostrártelo.",
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
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Monto"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Monto",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Ingresa la parte de cada persona. Asegúrate de que el total coincida con el monto de arriba.",
    ),
    "shareCreateCyclePeriod": m16,
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "p. ej.: Compra de supermercado",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Descripción",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para crear esto en este momento.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear. Inténtalo de nuevo.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Llegaste al límite gratuito de cuentas activas. Actualiza para tener más espacio.",
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
      "Elegir montos",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Dividir por igual",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cómo queremos dividir esto?",
    ),
    "shareCreateStartLabel": MessageLookupByLibrary.simpleMessage(
      "¿Cuándo aplica esto?",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage(
      "Cuenta creada.",
    ),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Crear cuenta"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Ingresa un monto válido mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Ingresa un monto válido para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "La división personalizada necesita al menos dos personas.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "Reparte el monto entre al menos dos personas al usar una división personalizada.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Asegúrate de que la división personalizada sume el monto de arriba.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Ingresa una descripción.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos dos personas para dividir el monto.",
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
    "shareCreatedListActiveAmount": m17,
    "shareCreatedListActiveSubtitle": m18,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Divídelo para que todos sepan su parte antes de publicarlo.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Las cuentas mantienen el dinero claro entre personas, sin recordatorios incómodos.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay cuentas",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tus cuentas. Desliza para actualizar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Pagado"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "Tus cuentas",
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
      "Cuenta eliminada.",
    ),
    "shareEditDisabledActive": MessageLookupByLibrary.simpleMessage(
      "Las cuentas activas están bloqueadas para edits.",
    ),
    "shareEditDisabledConverted": MessageLookupByLibrary.simpleMessage(
      "Esta cuenta ahora es un plan y la edición está desactivada.",
    ),
    "shareEditDisabledGeneric": MessageLookupByLibrary.simpleMessage(
      "La edición de esta cuenta no está disponible en este momento.",
    ),
    "shareEditDisabledRecurringCycle": MessageLookupByLibrary.simpleMessage(
      "Los ciclos recurrentes están bloqueados para editarse aquí.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Esto queda bloqueado hasta que alguien tome esta cuenta.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Los repartos están bloqueados porque alguien ya pagó. Aun así, puedes actualizar la descripción y las notas.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Cuenta actualizada.",
    ),
    "shareEditTerminateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo terminar el plan. Inténtalo de nuevo.",
    ),
    "shareEditTerminatePlan": MessageLookupByLibrary.simpleMessage(
      "Terminar plan",
    ),
    "shareEditTerminatePlanBusy": MessageLookupByLibrary.simpleMessage(
      "Terminando…",
    ),
    "shareEditTerminatePlanConfirm": MessageLookupByLibrary.simpleMessage(
      "Terminar plan",
    ),
    "shareEditTerminatePlanMessage": MessageLookupByLibrary.simpleMessage(
      "Esto detiene los ciclos futuros de la cuenta.",
    ),
    "shareEditTerminatePlanTitle": MessageLookupByLibrary.simpleMessage(
      "¿Terminar el plan recurrente?",
    ),
    "shareEditTerminateSuccess": MessageLookupByLibrary.simpleMessage(
      "Plan terminado.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Editar cuenta"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Ya estás al día con esta persona.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "No pudimos marcar esa cuenta como saldada. Inténtalo de nuevo.",
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
      "No pudimos confirmar la recepción de las cuentas.",
    ),
    "sharePaidDetailAcknowledging": MessageLookupByLibrary.simpleMessage(
      "Confirmando…",
    ),
    "startReturningSubtitle": MessageLookupByLibrary.simpleMessage(
      "¿Qué quieres hacer ahora?",
    ),
    "startReturningTitle": m19,
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Añadir flujo"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("Añadir cuenta"),
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
      "Invítalos para que puedan mantenerse alineados y compartir la carga.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Trae tu hogar a Kinly",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("nuevo hoy"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flujo"),
    "todayFlowSeeAll": m20,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Esto es lo que está fluyendo en tu hogar hoy.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Activos"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayGratitudeHouseCta": MessageLookupByLibrary.simpleMessage(
      "Muro del hogar",
    ),
    "todayGratitudePersonalCta": MessageLookupByLibrary.simpleMessage(
      "Muro personal",
    ),
    "todayGratitudeSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
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
      "Actualizar hogar",
    ),
    "todayMemberCapResolutionFailed": m21,
    "todayMemberCapResolutionJoined": m22,
    "todayMemberCapResolutionSuperseded": m23,
    "todayMemberCapResolutionUnknownName": MessageLookupByLibrary.simpleMessage(
      "Alguien",
    ),
    "todayMemberCapSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Ignorar",
    ),
    "todayMemberCapSubtitle": m24,
    "todayMemberCapSubtitleGeneric": MessageLookupByLibrary.simpleMessage(
      "Tu hogar está creciendo. Actualiza para dar la bienvenida a más personas.",
    ),
    "todayMemberCapTitle": MessageLookupByLibrary.simpleMessage(
      "Alguien quiere unirse a tu hogar",
    ),
    "todayShareActiveSubtitle": m25,
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar Share en este momento.",
    ),
    "todaySharePaidSubtitle": MessageLookupByLibrary.simpleMessage(
      "Monto saldado",
    ),
    "todaySharePaidUnseen": m26,
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Por saldar"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayShareTabPaidToMe": MessageLookupByLibrary.simpleMessage("Saldadas"),
    "vibeCozySocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente acogedor y calmado cuando la gente pasa tiempo junta.",
    ),
    "vibeCozySocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social y acogedor",
    ),
    "vibeDefaultSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente fácil de vivir para todos.",
    ),
    "vibeDefaultTitle": MessageLookupByLibrary.simpleMessage(
      "Un hogar equilibrado",
    ),
    "vibeEasygoingSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente relajado y abierto a cambios día a día.",
    ),
    "vibeEasygoingTitle": MessageLookupByLibrary.simpleMessage(
      "Flujo relajado",
    ),
    "vibeIndependentSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar respeta el espacio y la tranquilidad.",
    ),
    "vibeIndependentTitle": MessageLookupByLibrary.simpleMessage(
      "Calma independiente",
    ),
    "vibeInsufficientSummary": MessageLookupByLibrary.simpleMessage(
      "Termina las preferencias para ver la vibra de tu hogar.",
    ),
    "vibeInsufficientTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay datos suficientes",
    ),
    "vibeMixedSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar muestra una mezcla de estilos de comodidad, influida por cómo a cada persona le gusta vivir.",
    ),
    "vibeMixedTitle": MessageLookupByLibrary.simpleMessage("Un hogar mixto"),
    "vibeQuietCareSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente tranquilo, con energía suave y ritmos más calmados.",
    ),
    "vibeQuietCareTitle": MessageLookupByLibrary.simpleMessage(
      "Cuidado silencioso",
    ),
    "vibeSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente activo, con gente compartiendo tiempo.",
    ),
    "vibeSocialTitle": MessageLookupByLibrary.simpleMessage("Energía social"),
    "vibeSteadySummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente estable, con el cuidado expresándose a través de hábitos diarios.",
    ),
    "vibeSteadyTitle": MessageLookupByLibrary.simpleMessage("Calma constante"),
    "vibeStructuredSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar funciona mejor con rutinas claras y planes compartidos.",
    ),
    "vibeStructuredTitle": MessageLookupByLibrary.simpleMessage(
      "Ritmo con estructura",
    ),
    "vibeWarmSocialSummary": MessageLookupByLibrary.simpleMessage(
      "Tu hogar se siente cálido y acogedor, con gente a menudo junta.",
    ),
    "vibeWarmSocialTitle": MessageLookupByLibrary.simpleMessage(
      "Social y cálido",
    ),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirme a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
