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

  static String m2(client, current) =>
      "Tu versión: ${client}\nÚltima versión: ${current}";

  static String m3(appName) => "Hecho con ${appName} - Juntos todo pesa menos";

  static String m4(link) =>
      "Compartiendo un vistazo de nuestro Muro de Gratitud. Descarga la app: ${link}";

  static String m5(time) => "${time} hoy";

  static String m6(count) => "Muro de gratitud (${count})";

  static String m7(weeks) =>
      "${Intl.plural(weeks, zero: 'Esta semana', one: 'Hace 1 semana', other: 'Hace ${weeks} semanas')}";

  static String m8(partOfDay, name) => "Buen${partOfDay}, ${name}";

  static String m9(link) =>
      "Comparte Kinly para que compartir sea más ligero: ${link}";

  static String m10(code, link) =>
      "¡Bienvenido a nuestro hogar en Kinly! Usa este código de invitación: ${code}\n\nDescarga la app: ${link}";

  static String m11(code) => "Te uniste con el código: ${code}";

  static String m12(price) => "${price} al mes para toda tu casa.";

  static String m13(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} recibidos";

  static String m14(paid, total) => "${paid} de ${total} pagados";

  static String m15(count) => "Ver todo (${count})";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} pagos pendientes')}";

  static String m17(homeId, role) => "Hogar actual: ${homeId} • Rol: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar tu membresía. Inténtalo nuevamente.",
    ),
    "bootstrap_initializing": m0,
    "connectionNotificationsPermissionBlocked":
        MessageLookupByLibrary.simpleMessage(
          "Permite notificaciones en tu teléfono para activar esto.",
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
      "No se pudieron actualizar los ajustes. Intenta nuevamente.",
    ),
    "connectionSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Controla recordatorios diarios y horarios.",
    ),
    "connectionSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Ajustes de conexión",
    ),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar. Inténtalo nuevamente.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crearemos tu hogar al instante. Podrás renombrarlo e invitar personas más tarde.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("¡Hogar creado!"),
    "create_title": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "dopamineFlowAffirmation": MessageLookupByLibrary.simpleMessage(
      "Gracias, tu hogar se siente más ligero.",
    ),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Revisa cada Flow y mantenlos en movimiento",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Explora maneras de mantener tu hogar más ligero.",
    ),
    "exploreIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Descubre lo que sigue",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ve cada Share creado y controla los pagos.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("Asignar a"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage("Añadir Flow"),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Eliminar Flow",
    ),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Esto lo eliminará para todos en tu hogar.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar este Flow?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Completar Flow",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar el Flow. Intenta nuevamente.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Más detalles",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "No se proporcionó enlace de guía.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "Sin notas aún.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles del Flow",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage("Editar Flow"),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no puede ser asignado ahora.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para modificar este Flow.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar el Flow. Intenta nuevamente.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa foto no es válida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Este Flow no puede actualizarse en este momento.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de Flows activos. Actualiza para añadir más.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de fotos. Elimina una o actualiza.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de expectativa",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Pega un enlace a video o documento (opcional)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage("Link de guía"),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir ese enlace. Intenta nuevamente.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar este Flow. Intenta nuevamente.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Dale un título corto y claro",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre del Flow",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Añade contexto opcional",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (opcional)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de expectativa",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la foto",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Se requiere permiso de cámara para tomar una foto.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Abrir configuración"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Añade una foto que muestre cómo debería verse",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo subir la foto. Inténtalo nuevamente.",
    ),
    "flowChoreRecurrenceAnnual": MessageLookupByLibrary.simpleMessage("Anual"),
    "flowChoreRecurrenceDaily": MessageLookupByLibrary.simpleMessage(
      "Diariamente",
    ),
    "flowChoreRecurrenceEvery2Months": MessageLookupByLibrary.simpleMessage(
      "Cada 2 meses",
    ),
    "flowChoreRecurrenceEvery2Weeks": MessageLookupByLibrary.simpleMessage(
      "Cada 2 semanas",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "Frecuencia",
    ),
    "flowChoreRecurrenceMonthly": MessageLookupByLibrary.simpleMessage(
      "Mensualmente",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("Una vez"),
    "flowChoreRecurrenceWeekly": MessageLookupByLibrary.simpleMessage(
      "Semanalmente",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "Fecha del Flow",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Añadir Flow",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Guardar Flow",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a alguien.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha hasta dentro de un año.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Ingresa un enlace válido que comience con http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Ingresa un nombre para el Flow.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Añade tu primera rutina para que todos sepan qué hacer.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay Flows",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar Flow. Desliza para refrescar.",
    ),
    "flowListOverdueLabel": MessageLookupByLibrary.simpleMessage("Atrasado"),
    "force_update_body": MessageLookupByLibrary.simpleMessage(
      "Esta versión de Kinly ya no es compatible. Instala la versión más reciente para continuar.",
    ),
    "force_update_button": MessageLookupByLibrary.simpleMessage(
      "Actualizar Kinly",
    ),
    "force_update_notes_label": MessageLookupByLibrary.simpleMessage(
      "Novedades",
    ),
    "force_update_title": MessageLookupByLibrary.simpleMessage(
      "Actualización requerida",
    ),
    "force_update_version_details": m2,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "gratitudeWallEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte un momento positivo para empezar.",
    ),
    "gratitudeWallEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay publicaciones",
    ),
    "gratitudeWallFooter": m3,
    "gratitudeWallKinlySubtitle": MessageLookupByLibrary.simpleMessage(
      "Kinly ayuda a tu hogar a compartir momentos de gratitud.",
    ),
    "gratitudeWallPoweredBy": MessageLookupByLibrary.simpleMessage(
      "Impulsado por",
    ),
    "gratitudeWallRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "gratitudeWallShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir este muro",
    ),
    "gratitudeWallShareError": MessageLookupByLibrary.simpleMessage(
      "No se pudo compartir. Inténtalo.",
    ),
    "gratitudeWallShareMessage": m4,
    "gratitudeWallShareTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "gratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Momentos compartidos del hogar.",
    ),
    "gratitudeWallTimestamp": m5,
    "gratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "gratitudeWallTitleCount": m6,
    "gratitudeWallWeeksAgo": m7,
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("as tardes"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("as noches"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("os días"),
    "greetingPartOfDay": m8,
    "greetingPartOfDay_name": MessageLookupByLibrary.simpleMessage("nombre"),
    "greetingPartOfDay_partOfDay": MessageLookupByLibrary.simpleMessage(
      "parte del día (mañana/tarde/noche)",
    ),
    "harmonyCommentHint": MessageLookupByLibrary.simpleMessage(
      "¿Qué hace que el hogar se sienta así?",
    ),
    "harmonyCommentLabel": MessageLookupByLibrary.simpleMessage(
      "Añadir nota (opcional)",
    ),
    "harmonyEntryCta": MessageLookupByLibrary.simpleMessage(
      "Compartir armonía de la semana",
    ),
    "harmonyEntryError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir la armonía.",
    ),
    "harmonyErrorAlreadySubmitted": MessageLookupByLibrary.simpleMessage(
      "Ya compartiste tu estado esta semana.",
    ),
    "harmonyErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No puedes enviar comentarios para este hogar.",
    ),
    "harmonyErrorSelectMood": MessageLookupByLibrary.simpleMessage(
      "Elige un estado antes de enviar.",
    ),
    "harmonyErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal.",
    ),
    "harmonyMoodCloudy": MessageLookupByLibrary.simpleMessage("Nublado"),
    "harmonyMoodPartiallySunny": MessageLookupByLibrary.simpleMessage(
      "Parcialmente soleado",
    ),
    "harmonyMoodRainy": MessageLookupByLibrary.simpleMessage("Lluvioso"),
    "harmonyMoodSunny": MessageLookupByLibrary.simpleMessage("Soleado"),
    "harmonyMoodThunderstorm": MessageLookupByLibrary.simpleMessage("Tormenta"),
    "harmonyQuestion": MessageLookupByLibrary.simpleMessage(
      "¿Cómo se siente el hogar esta semana?",
    ),
    "harmonyShareLabel": MessageLookupByLibrary.simpleMessage(
      "Compartir en el Muro de Gratitud",
    ),
    "harmonyShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Visible para tu hogar cuando el ánimo es soleado o parcialmente soleado.",
    ),
    "harmonySubmitCta": MessageLookupByLibrary.simpleMessage("Enviar"),
    "harmonySubmitSuccess": MessageLookupByLibrary.simpleMessage(
      "¡Gracias! Comentario guardado.",
    ),
    "harmonySubtext": MessageLookupByLibrary.simpleMessage(
      "Elige el clima que mejor refleje tu sensación y deja una nota opcional.",
    ),
    "harmonyTitle": MessageLookupByLibrary.simpleMessage(
      "Armonía semanal del hogar",
    ),
    "hubCardGratitudeWallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lee agradecimientos y momentos especiales.",
    ),
    "hubCardGratitudeWallTitle": MessageLookupByLibrary.simpleMessage(
      "Muro de gratitud",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("Código copiado"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage("Copiar código"),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Hub. Inténtalo nuevamente.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación. Inténtalo nuevamente.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Aún no hay miembros activos.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "Personas actualmente activas en este hogar.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage(
      "Miembros del hogar",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escanea para descargar Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Compartir la app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo rotar la invitación. Intenta de nuevo.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotar invitación"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitación rotada",
    ),
    "hubShareAppBody": m9,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Obtén la app Kinly",
    ),
    "hubShareInviteBody": m10,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invitar a mi hogar en Kinly",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Ya perteneces a otro hogar. Debes salir antes de unirte a uno nuevo.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esa invitación ya no está activa. Pide un nuevo código al propietario.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación no parece correcto.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar alcanzó su límite de miembros. Pide al propietario actualizar o remover a alguien.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo unir. Inténtalo nuevamente.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Ingresa el código de invitación",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m11,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse al hogar"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" y "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "He leído y acepto los ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage(
      "Política de privacidad",
    ),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "Juntos todo pesa menos",
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
      "Comprobando estado de membresía…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Aún no perteneces a un hogar.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explorar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "npsCannotSkip": MessageLookupByLibrary.simpleMessage(
      "Debes elegir una puntuación para continuar.",
    ),
    "npsDescription": MessageLookupByLibrary.simpleMessage(
      "El Net Promoter Score nos ayuda a saber cómo vamos. Elige un número del 0 (nada probable) al 10 (muy probable).",
    ),
    "npsEmailSubject": MessageLookupByLibrary.simpleMessage(
      "¿Qué podemos mejorar?",
    ),
    "npsLaunchError": MessageLookupByLibrary.simpleMessage(
      "No se pudo abrir el siguiente paso.",
    ),
    "npsScaleHighLabel": MessageLookupByLibrary.simpleMessage(
      "10 Muy probable",
    ),
    "npsScaleLowLabel": MessageLookupByLibrary.simpleMessage("0 Nada probable"),
    "npsSubmitErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No puedes enviar comentarios ahora.",
    ),
    "npsSubmitErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo enviar tu comentario.",
    ),
    "npsSubmitErrorInvalidScore": MessageLookupByLibrary.simpleMessage(
      "Elige un valor entre 0 y 10.",
    ),
    "npsSubmitErrorNotRequired": MessageLookupByLibrary.simpleMessage(
      "Este comentario no es necesario ahora.",
    ),
    "npsTitle": MessageLookupByLibrary.simpleMessage(
      "¿Qué tan probable es que recomiendes Kinly a un amigo o familiar?",
    ),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly necesita conexión a internet. Revisa tu señal e inténtalo nuevamente.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Estás sin conexión"),
    "paywallBulletFlows": MessageLookupByLibrary.simpleMessage(
      "Flows ilimitados",
    ),
    "paywallBulletMembers": MessageLookupByLibrary.simpleMessage(
      "Miembros ilimitados del hogar",
    ),
    "paywallBulletPhotos": MessageLookupByLibrary.simpleMessage(
      "Fotos ilimitadas de flows",
    ),
    "paywallBulletShares": MessageLookupByLibrary.simpleMessage(
      "Gastos compartidos ilimitados",
    ),
    "paywallEmotional": MessageLookupByLibrary.simpleMessage(
      "Premium ayuda a que tu hogar se sienta m?s ligero cada d?a: sin bloqueos, sin l?mites y todos alineados.",
    ),
    "paywallErrorTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la pantalla de pago.",
    ),
    "paywallPriceCaption": MessageLookupByLibrary.simpleMessage(
      "Una mejora para el hogar. Un plan compartido, sin niveles ocultos.",
    ),
    "paywallPricePerMonth": m12,
    "paywallPriceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Precio no disponible en este momento.",
    ),
    "paywallPrimaryCta": MessageLookupByLibrary.simpleMessage(
      "Actualizar a Kinly Premium",
    ),
    "paywallPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "La compra no se completó — puedes intentarlo de nuevo en cualquier momento.",
    ),
    "paywallPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Ahora tienes Kinly Premium.",
    ),
    "paywallRestoreCta": MessageLookupByLibrary.simpleMessage(
      "Restaurar compras",
    ),
    "paywallRetryLabel": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "paywallSecondaryCta": MessageLookupByLibrary.simpleMessage(
      "Continuar con hogar gratuito",
    ),
    "paywallSubtitle": MessageLookupByLibrary.simpleMessage(
      "Un plan mensual simple para toda tu casa. Todos tienen acceso ilimitado.",
    ),
    "paywallTitle": MessageLookupByLibrary.simpleMessage(
      "Lleva m?s armon?a a tu hogar, juntos.",
    ),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileActionConfirmDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Esto eliminará tu cuenta y cerrará sesión. No se puede deshacer.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar tu cuenta?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Perderás acceso a Flow, historial y invitaciones.",
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
      "No pudimos abrir tu app de correo.",
    ),
    "profileContactUsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Email: support@makinglifeeasie.com",
    ),
    "profileContactUsTitle": MessageLookupByLibrary.simpleMessage(
      "Contáctanos",
    ),
    "profileDeleteAccountSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elimina tu cuenta y datos.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Tu cuenta será eliminada pronto. Cerraremos tu sesión.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo nuevamente.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay avatares disponibles. Inténtalo más tarde.",
    ),
    "profileIdentityAvatarSectionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Cada avatar es único dentro de tu hogar.",
        ),
    "profileIdentityAvatarSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Elige un avatar",
    ),
    "profileIdentityLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tu perfil.",
    ),
    "profileIdentityRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "profileIdentitySaveButton": MessageLookupByLibrary.simpleMessage(
      "Guardar cambios",
    ),
    "profileIdentitySubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige un nombre de usuario y avatar.",
    ),
    "profileIdentitySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Perfil actualizado.",
    ),
    "profileIdentityTitle": MessageLookupByLibrary.simpleMessage(
      "Editar perfil",
    ),
    "profileIdentityUsernameEmptyError": MessageLookupByLibrary.simpleMessage(
      "Ingresa un nombre de usuario.",
    ),
    "profileIdentityUsernameFormatError": MessageLookupByLibrary.simpleMessage(
      "Usa 3-30 letras minúsculas o números. Puedes incluir puntos o guiones bajos en medio.",
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
      "Ese nombre ya está en uso. Prueba otro.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar el Info Hub.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abre el hub de Notion en la app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileKickActionConfirm": MessageLookupByLibrary.simpleMessage(
      "Remover miembro",
    ),
    "profileKickMemberSubtitle": MessageLookupByLibrary.simpleMessage(
      "Elige quién debe perder acceso al hogar.",
    ),
    "profileKickMemberTitle": MessageLookupByLibrary.simpleMessage(
      "Remover miembro",
    ),
    "profileKickNoMembers": MessageLookupByLibrary.simpleMessage(
      "No hay otros miembros para remover.",
    ),
    "profileKickOwnerOnly": MessageLookupByLibrary.simpleMessage(
      "Solo el propietario puede remover miembros.",
    ),
    "profileKickSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona un miembro. Perderá acceso inmediatamente.",
    ),
    "profileKickSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Remover miembro",
    ),
    "profileKickSuccessClose": MessageLookupByLibrary.simpleMessage(
      "Volver a ajustes",
    ),
    "profileKickSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Ya no tiene acceso al hogar.",
    ),
    "profileKickSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Miembro removido",
    ),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar los miembros del hogar.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Comprobando miembros del hogar…",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Salir significa dejar tu espacio compartido en Kinly.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Nadie más puede asumir la propiedad ahora. Inténtalo después.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Eres el último miembro. Al salir, el hogar se desactivará.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Saliste del hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona quién será el nuevo propietario antes de salir.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transferir propiedad",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Propiedad transferida. Finalizando tu salida…",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Necesitarás iniciar sesión para acceder a tu hogar.",
    ),
    "profileLogoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Cerrar sesión?",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cerrar sesión de Kinly en este dispositivo.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "No pudimos encontrar tu hogar actual.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona tus preferencias y el acceso al hogar.",
    ),
    "profileSettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Perfil y hogar",
    ),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar una entrada de equidad",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "Fair Share",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Añadir un Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crear una encuesta rápida",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("Encuesta"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar un Share",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Añadir rápido"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Monto"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Monto",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Ingresa cuánto debe cada persona. El total debe coincidir con el monto.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "ej. Compra del súper",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Descripción",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para crear esto ahora.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear. Intenta de nuevo.",
    ),
    "shareCreateErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite gratuito de 10 gastos activos o borradores. Cierra o cancela uno para continuar.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cargar los miembros del hogar.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Contexto opcional visible para todos",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "Necesitas al menos dos miembros para compartir.",
    ),
    "shareCreateParticipantsLabel": MessageLookupByLibrary.simpleMessage(
      "¿Quiénes comparten?",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "División personalizada",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Dividir automáticamente",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "Tipo de división",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("Share creado."),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Ingresa un monto válido mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Ingresa montos válidos para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "La división personalizada necesita al menos dos personas.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "Una sola persona no puede cubrir el monto entero en una división personalizada.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "La suma debe coincidir con el monto ingresado arriba.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Ingresa una descripción.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos dos personas para dividir el monto.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "Elige cómo quieres compartir.",
    ),
    "shareCreatedListActiveAmount": m13,
    "shareCreatedListActiveSubtitle": m14,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Asígnalo a cada persona antes de publicar.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Crea un Share para verlo aquí.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aún no hay shares",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tus shares. Desliza para refrescar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Pagado"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage("Tus shares"),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Esto eliminará el borrador para todos.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "No se pudo eliminar. Inténtalo nuevamente.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Share eliminado.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Esto ya no se puede editar porque debes asignar el share.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Las divisiones están bloqueadas porque alguien ya pagó. Aún puedes actualizar la descripción y las notas.",
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
      "No se pudo marcar como pagado. Inténtalo nuevamente.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Marcar como pagado",
    ),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "Selecciona con quién compartir.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona el share que acabas de liquidar.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Pago registrado.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Pago pendiente",
    ),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Añadir Flow"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage("Añadir Share"),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir a tu hogar",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Disfruta la calma — Kinly te avisará cuando haya algo que requiera tu atención.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage("Respira"),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "No hay nada pendiente por hoy ✨",
    ),
    "todayFlatmateInviteSubtitle": MessageLookupByLibrary.simpleMessage(
      "Comparte tu invitación para repartir tareas juntos.",
    ),
    "todayFlatmateInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a tu compañero de piso",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("nuevo hoy"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m15,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Esto es lo que fluye en tu hogar hoy.",
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
      "Comparte Kinly para que también aporten armonía a su hogar.",
    ),
    "todayInviteFriendsTitle": MessageLookupByLibrary.simpleMessage(
      "Invita amigos a Kinly",
    ),
    "todayInviteNotNow": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "todayInviteShareCta": MessageLookupByLibrary.simpleMessage(
      "Compartir invitación",
    ),
    "todayShareActiveSubtitle": m16,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage("próximo"),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Divide según la contribución.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada aquí.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar Share ahora.",
    ),
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "Compra compartida de ayer",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "Factura de internet esta semana",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "Recordatorio de alquiler próximamente",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage(
      "Ver todos los shares",
    ),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Activos"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "today_home_details": m17,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "Sin hogar activo aún. Crea o únete a uno para ver la vista de hoy.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("Hoy"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("?"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
