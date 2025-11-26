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

  static String m1(client, current) =>
      "Tu versión: ${client}\nÚltima versión: ${current}";

  static String m2(partOfDay, name) => "Buen ${partOfDay}, ${name}";

  static String m3(link) =>
      "Comparte Kinly para que compartir sea más ligero: ${link}";

  static String m4(code, link) =>
      "Bienvenido a nuestro hogar Kinly. Introduce este código de invitación: ${code}\\nDescarga la app Kinly: ${link}";

  static String m5(code) => "Te has unido con el cÃ³digo: ${code}";

  static String m6(paidAmount, totalAmount) =>
      "${paidAmount} de ${totalAmount} recolectados";

  static String m7(paid, total) => "${paid} de ${total} pagos completos";

  static String m8(count) => "Ver todo (${count})";

  static String m9(count) =>
      "${Intl.plural(count, one: '${count} pago pendiente', other: '${count} pagos pendientes')}";

  static String m10(homeId, role) => "Hogar actual: ${homeId} â€¢ Rol: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "authMembershipLoadFailed": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar tu membresía del hogar. Inténtalo de nuevo.",
    ),
    "bootstrap_initializing": m0,
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar. Intenta de nuevo.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crearemos tu hogar al instante. PodrÃ¡s renombrarlo e invitar luego.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("Â¡Hogar creado!"),
    "create_title": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "exploreFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Revisa cada tarea de Flow y mantÃ©n las tareas en movimiento",
    ),
    "exploreIntroSubtitle": MessageLookupByLibrary.simpleMessage(
      "Explora mÃ¡s maneras de mantener tu hogar liviano.",
    ),
    "exploreIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Descubre quÃ© sigue",
    ),
    "exploreShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Revisa cada gasto Share que creaste y sigue los pagos.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("Asignar a"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Agregar tarea de Flow",
    ),
    "flowChoreDeleteButton": MessageLookupByLibrary.simpleMessage(
      "Eliminar tarea",
    ),
    "flowChoreDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "flowChoreDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "flowChoreDeleteDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Esto elimina el Flow para todos en tu hogar.",
    ),
    "flowChoreDeleteDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Â¿Eliminar esta tarea?",
    ),
    "flowChoreDetailCompleteButton": MessageLookupByLibrary.simpleMessage(
      "Completar tarea",
    ),
    "flowChoreDetailCompletionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar la tarea. Intenta de nuevo.",
    ),
    "flowChoreDetailMoreInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Más detalles",
    ),
    "flowChoreDetailNoHowTo": MessageLookupByLibrary.simpleMessage(
      "Sin enlace de instrucciones.",
    ),
    "flowChoreDetailNoNotes": MessageLookupByLibrary.simpleMessage(
      "Sin notas.",
    ),
    "flowChoreDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles de la tarea",
    ),
    "flowChoreDetailUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar tarea de Flow",
    ),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no se puede asignar ahora.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar esta tarea.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar la tarea. Intenta de nuevo.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa ruta de foto no es vÃ¡lida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio vÃ¡lida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Esta tarea no se puede actualizar en este momento.",
    ),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Alcanzaste el lÃ­mite gratuito de tareas activas. Mejora el plan para agregar mÃ¡s.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Alcanzaste el lÃ­mite gratuito de fotos de referencia. Elimina una o mejora el plan.",
    ),
    "flowChoreExpectationPhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Pega un enlace de video o documento (opcional)",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Enlace de instrucciones",
    ),
    "flowChoreHowToLaunchError": MessageLookupByLibrary.simpleMessage(
      "No pudimos abrir ese enlace. Inténtalo de nuevo.",
    ),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar esta tarea. Intenta de nuevo.",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Ponle un tÃ­tulo corto y claro",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre de la tarea",
    ),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Agrega contexto o recordatorios opcionales",
    ),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (opcional)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChorePhotoLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load photo",
    ),
    "flowChorePhotoPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Camera permission is required to take a photo.",
    ),
    "flowChorePhotoPermissionOpenSettings":
        MessageLookupByLibrary.simpleMessage("Open settings"),
    "flowChorePhotoPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Add a photo to show what great looks like",
    ),
    "flowChorePhotoUploadError": MessageLookupByLibrary.simpleMessage(
      "Could not upload the photo. Try again.",
    ),
    "flowChoreRecurrenceAnnual": MessageLookupByLibrary.simpleMessage("Anual"),
    "flowChoreRecurrenceDaily": MessageLookupByLibrary.simpleMessage("Diario"),
    "flowChoreRecurrenceEvery2Months": MessageLookupByLibrary.simpleMessage(
      "Cada 2 meses",
    ),
    "flowChoreRecurrenceEvery2Weeks": MessageLookupByLibrary.simpleMessage(
      "Cada 2 semanas",
    ),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage(
      "RepeticiÃ³n",
    ),
    "flowChoreRecurrenceMonthly": MessageLookupByLibrary.simpleMessage(
      "Mensual",
    ),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("Una vez"),
    "flowChoreRecurrenceWeekly": MessageLookupByLibrary.simpleMessage(
      "Semanal",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage(
      "Fecha de inicio",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage(
      "Agregar tarea",
    ),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage(
      "Guardar tarea",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a quiÃ©n asignar esta tarea.",
    ),
    "flowChoreValidationDate": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha hasta un año desde hoy.",
    ),
    "flowChoreValidationHowToUrl": MessageLookupByLibrary.simpleMessage(
      "Ingresa un enlace válido que empiece con http o https.",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Dale un nombre a la tarea.",
    ),
    "flowListDraftLabel": MessageLookupByLibrary.simpleMessage("Borrador"),
    "flowListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Agrega tu primera rutina para que todos sepan quÃ© hacer.",
    ),
    "flowListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "AÃºn no hay Flows",
    ),
    "flowListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar las tareas de Flow. Desliza para actualizar.",
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
    "force_update_version_details": m1,
    "friendDefaultName": MessageLookupByLibrary.simpleMessage("amigo"),
    "greetingPartAfternoon": MessageLookupByLibrary.simpleMessage("tarde"),
    "greetingPartEvening": MessageLookupByLibrary.simpleMessage("noche"),
    "greetingPartMorning": MessageLookupByLibrary.simpleMessage("mañana"),
    "greetingPartOfDay": m2,
    "greetingPartOfDay_name": MessageLookupByLibrary.simpleMessage("nombre"),
    "greetingPartOfDay_partOfDay": MessageLookupByLibrary.simpleMessage(
      "parte del dÃ­a (maÃ±ana/tarde/noche)",
    ),
    "hubCodeCopied": MessageLookupByLibrary.simpleMessage("Código copiado"),
    "hubCopyCode": MessageLookupByLibrary.simpleMessage(
      "Copiar código de invitación",
    ),
    "hubError": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar Hub. Intenta de nuevo.",
    ),
    "hubInviteCta": MessageLookupByLibrary.simpleMessage("Invitar"),
    "hubInviteUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la invitación. Intenta de nuevo.",
    ),
    "hubMembersEmpty": MessageLookupByLibrary.simpleMessage(
      "Aún no hay miembros activos.",
    ),
    "hubMembersSubtitle": MessageLookupByLibrary.simpleMessage(
      "Personas activas actualmente en este hogar.",
    ),
    "hubMembersTitle": MessageLookupByLibrary.simpleMessage(
      "Miembros del hogar",
    ),
    "hubQrSubtitle": MessageLookupByLibrary.simpleMessage(
      "Escanea para descargar Kinly",
    ),
    "hubQrTitle": MessageLookupByLibrary.simpleMessage("Comparte la app"),
    "hubRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "hubRotateError": MessageLookupByLibrary.simpleMessage(
      "No se pudo rotar la invitación. Intenta de nuevo.",
    ),
    "hubRotateInvite": MessageLookupByLibrary.simpleMessage("Rotar invitación"),
    "hubRotateSuccess": MessageLookupByLibrary.simpleMessage(
      "Invitación rotada",
    ),
    "hubShareAppBody": m3,
    "hubShareAppCta": MessageLookupByLibrary.simpleMessage("Compartir Kinly"),
    "hubShareAppTitle": MessageLookupByLibrary.simpleMessage(
      "Consigue la app Kinly",
    ),
    "hubShareInviteBody": m4,
    "hubShareInviteTitle": MessageLookupByLibrary.simpleMessage(
      "Invita a mi hogar Kinly",
    ),
    "join_error_already_in_other_home": MessageLookupByLibrary.simpleMessage(
      "Ya perteneces a otro hogar. Debes dejarlo antes de unirte.",
    ),
    "join_error_forbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para unirte a este hogar.",
    ),
    "join_error_inactive_invite": MessageLookupByLibrary.simpleMessage(
      "Esa invitación ya no está activa. Pide al dueño un nuevo código.",
    ),
    "join_error_invalid_code": MessageLookupByLibrary.simpleMessage(
      "Ese código de invitación no es válido.",
    ),
    "join_error_paywall_limit": MessageLookupByLibrary.simpleMessage(
      "Este hogar alcanzó su límite de miembros. Pide al dueño que mejore el plan o libere un lugar.",
    ),
    "join_error_unauthorized": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para unirte a este hogar.",
    ),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo unir. Por favor, intÃ©ntalo de nuevo.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Ingresa el cÃ³digo de invitaciÃ³n",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m5,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse al hogar"),
    "login_consent_connector": MessageLookupByLibrary.simpleMessage(" y "),
    "login_consent_prefix": MessageLookupByLibrary.simpleMessage(
      "He leído y acepto los ",
    ),
    "login_privacy": MessageLookupByLibrary.simpleMessage(
      "PolÃ­tica de privacidad",
    ),
    "login_tagline": MessageLookupByLibrary.simpleMessage(
      "Juntos se siente mÃ¡s ligero",
    ),
    "login_terms": MessageLookupByLibrary.simpleMessage(
      "TÃ©rminos del servicio",
    ),
    "login_with_apple": MessageLookupByLibrary.simpleMessage(
      "Continuar con Apple",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Continuar con Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesiÃ³n"),
    "membership_status_active": MessageLookupByLibrary.simpleMessage(
      "Ya eres parte de un hogar.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Comprobando el estado de la membresÃ­aâ€¦",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "AÃºn no te has unido a un hogar.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explorar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Centro"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "offline_body": MessageLookupByLibrary.simpleMessage(
      "Kinly necesita internet. Comprueba tu señal e inténtalo de nuevo.",
    ),
    "offline_retry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "offline_title": MessageLookupByLibrary.simpleMessage("Sin conexión"),
    "profileActionCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "profileActionConfirm": MessageLookupByLibrary.simpleMessage("Continuar"),
    "profileConfirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "Se elimina tu cuenta y se cierra la sesión. No se puede deshacer.",
    ),
    "profileConfirmDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "¿Eliminar tu cuenta?",
    ),
    "profileConfirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
      "Perderás acceso a Flow, historial compartido e invitaciones.",
    ),
    "profileConfirmLeaveTitle": MessageLookupByLibrary.simpleMessage(
      "¿Salir de este hogar?",
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
      "Elimina tu cuenta de Kinly y los datos de perfil.",
    ),
    "profileDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar cuenta",
    ),
    "profileDeleteSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Tu cuenta se eliminará pronto. Cerraremos tu sesión.",
    ),
    "profileGenericError": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. Inténtalo otra vez.",
    ),
    "profileIdentityAvatarEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay avatares disponibles por ahora. Inténtalo más tarde.",
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
      "Elige tu nombre de usuario y avatar para el hogar.",
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
      "Usa de 3 a 30 caracteres en minúscula o números. Puedes incluir puntos o guiones bajos en medio.",
    ),
    "profileIdentityUsernameHint": MessageLookupByLibrary.simpleMessage(
      "letras, números, . o _",
    ),
    "profileIdentityUsernameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre de usuario",
    ),
    "profileIdentityUsernamePreviewFallback":
        MessageLookupByLibrary.simpleMessage("tu usuario"),
    "profileIdentityUsernameTakenError": MessageLookupByLibrary.simpleMessage(
      "Ese nombre de usuario ya está en uso. Prueba con otro.",
    ),
    "profileInfoHubLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar el Info Hub. Revisa tu conexión.",
    ),
    "profileInfoHubSubtitle": MessageLookupByLibrary.simpleMessage(
      "Abre el hub de Notion de Kinly dentro de la app.",
    ),
    "profileInfoHubTitle": MessageLookupByLibrary.simpleMessage("Info Hub"),
    "profileLeaveEligibilityError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar a los miembros de tu hogar. Intenta nuevamente.",
    ),
    "profileLeaveEligibilityLoading": MessageLookupByLibrary.simpleMessage(
      "Comprobando los miembros del hogar…",
    ),
    "profileLeaveHomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Deja de compartir con este hogar. La persona propietaria debe transferir primero.",
    ),
    "profileLeaveHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Salir del hogar",
    ),
    "profileLeaveOwnerNoEligibleMembers": MessageLookupByLibrary.simpleMessage(
      "Nadie más puede asumir la propiedad ahora mismo. Intenta más tarde.",
    ),
    "profileLeaveOwnerSoloMessage": MessageLookupByLibrary.simpleMessage(
      "Eres la última persona miembro. Salir desactivará este hogar para todas las personas.",
    ),
    "profileLeaveSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Saliste de tu hogar.",
    ),
    "profileLeaveTransferSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona quién será la nueva persona propietaria antes de salir.",
    ),
    "profileLeaveTransferSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Transferir propiedad",
    ),
    "profileLeaveTransferSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Propiedad transferida. Terminando tu salida…",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Necesitarás iniciar sesión otra vez para acceder a tu hogar.",
    ),
    "profileLogoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "¿Cerrar sesión?",
    ),
    "profileLogoutSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cierra sesión de Kinly en este dispositivo.",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "profileMissingHomeError": MessageLookupByLibrary.simpleMessage(
      "No encontramos tu hogar actual. Inténtalo nuevamente.",
    ),
    "profileSettingsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Administra tus preferencias y el acceso a tu hogar.",
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
      "AÃ±adir una tarea a Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crear una encuesta rÃ¡pida para el hogar",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("Encuesta"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar un gasto compartido",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("AÃ±adir rÃ¡pido"),
    "shareCreateAmountHint": MessageLookupByLibrary.simpleMessage("0.00"),
    "shareCreateAmountLabel": MessageLookupByLibrary.simpleMessage("Monto"),
    "shareCreateCustomAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Monto",
    ),
    "shareCreateCustomHelper": MessageLookupByLibrary.simpleMessage(
      "Ingresa lo que debe cada persona. El total debe coincidir con el monto.",
    ),
    "shareCreateDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "p. ej. Compra de supermercado",
    ),
    "shareCreateDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "DescripciA?n",
    ),
    "shareCreateErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para crear este gasto ahora.",
    ),
    "shareCreateErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el gasto. Intenta otra vez.",
    ),
    "shareCreateLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar a los miembros del hogar.",
    ),
    "shareCreateNotesHint": MessageLookupByLibrary.simpleMessage(
      "Contexto opcional visible para todos",
    ),
    "shareCreateNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "shareCreateParticipantsEmpty": MessageLookupByLibrary.simpleMessage(
      "Necesitas al menos dos miembros para dividir un gasto.",
    ),
    "shareCreateParticipantsLabel": MessageLookupByLibrary.simpleMessage(
      "A?QuiA?nes comparten?",
    ),
    "shareCreateRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreateSplitCustom": MessageLookupByLibrary.simpleMessage(
      "DivisiA?n personalizada",
    ),
    "shareCreateSplitEqual": MessageLookupByLibrary.simpleMessage(
      "Dividir automA?ticamente",
    ),
    "shareCreateSplitLabel": MessageLookupByLibrary.simpleMessage(
      "Tipo de divisiA?n",
    ),
    "shareCreateSubmit": MessageLookupByLibrary.simpleMessage("Crear"),
    "shareCreateSuccess": MessageLookupByLibrary.simpleMessage("Gasto creado."),
    "shareCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Crear gasto compartido",
    ),
    "shareCreateValidationAmount": MessageLookupByLibrary.simpleMessage(
      "Ingresa un monto vA?lido mayor que cero.",
    ),
    "shareCreateValidationCustomAmounts": MessageLookupByLibrary.simpleMessage(
      "Ingresa un monto vA?lido para cada persona seleccionada.",
    ),
    "shareCreateValidationCustomParticipants":
        MessageLookupByLibrary.simpleMessage(
          "La divisiA?n personalizada necesita al menos dos personas.",
        ),
    "shareCreateValidationCustomSinglePayer": MessageLookupByLibrary.simpleMessage(
      "Una sola persona no puede cubrir todo el monto en una divisiA?n personalizada.",
    ),
    "shareCreateValidationCustomSum": MessageLookupByLibrary.simpleMessage(
      "Los montos personalizados deben sumar el total.",
    ),
    "shareCreateValidationDescription": MessageLookupByLibrary.simpleMessage(
      "Ingresa una descripciA?n.",
    ),
    "shareCreateValidationEqualParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Selecciona al menos dos personas para dividir el monto.",
        ),
    "shareCreateValidationSplit": MessageLookupByLibrary.simpleMessage(
      "Elige cA?mo quieres dividir este gasto.",
    ),
    "shareCreatedListActiveAmount": m6,
    "shareCreatedListActiveSubtitle": m7,
    "shareCreatedListDraftBadge": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "shareCreatedListDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Divide el monto para asignar a cada persona antes de publicar.",
    ),
    "shareCreatedListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Crea un Share para verlo listado aqu?.",
    ),
    "shareCreatedListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "A?n no hay gastos",
    ),
    "shareCreatedListError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar tus gastos compartidos. Desliza para actualizar.",
    ),
    "shareCreatedListPaidBadge": MessageLookupByLibrary.simpleMessage("Pagado"),
    "shareCreatedListRetry": MessageLookupByLibrary.simpleMessage(
      "Intentar de nuevo",
    ),
    "shareCreatedListTitle": MessageLookupByLibrary.simpleMessage(
      "Tus gastos compartidos",
    ),
    "shareEditClose": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "shareEditDeleteButton": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "shareEditDeleteConfirm": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "shareEditDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Esto quitar� el borrador para todos.",
    ),
    "shareEditDeleteConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "�Eliminar este gasto?",
    ),
    "shareEditDeleteError": MessageLookupByLibrary.simpleMessage(
      "No pudimos eliminar este gasto. Int�ntalo de nuevo.",
    ),
    "shareEditDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Gasto eliminado.",
    ),
    "shareEditLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar ese borrador.",
    ),
    "shareEditNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Este gasto ya no se puede editar porque está bloqueado.",
    ),
    "shareEditSplitsLocked": MessageLookupByLibrary.simpleMessage(
      "Las divisiones están bloqueadas porque alguien ya pagó. Aún puedes actualizar la descripción y las notas.",
    ),
    "shareEditSubmit": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "shareEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Gasto actualizado.",
    ),
    "shareEditTitle": MessageLookupByLibrary.simpleMessage("Terminar borrador"),
    "shareOwedDetailEmpty": MessageLookupByLibrary.simpleMessage(
      "Estás al día con esta persona.",
    ),
    "shareOwedDetailError": MessageLookupByLibrary.simpleMessage(
      "No pudimos marcar ese pago. Inténtalo de nuevo.",
    ),
    "shareOwedDetailPaid": MessageLookupByLibrary.simpleMessage(
      "Marcar como pagado",
    ),
    "shareOwedDetailSelectionLabel": MessageLookupByLibrary.simpleMessage(
      "Selecciona un gasto para continuar.",
    ),
    "shareOwedDetailSubtitle": MessageLookupByLibrary.simpleMessage(
      "Selecciona el gasto que acabas de pagar.",
    ),
    "shareOwedDetailSuccess": MessageLookupByLibrary.simpleMessage(
      "Pago registrado.",
    ),
    "shareOwedDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Pago pendiente",
    ),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage(
      "Agregar tarea (Flow)",
    ),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage(
      "Agregar gasto (Share)",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "AÃ±ade algo a tu hogar",
    ),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Disfruta de la calma; Kinly te avisarÃ¡ cuando haya algo que hacer.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "TÃ³mate un respiro",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Hoy lo tienes todo al dÃ­a âœ¨",
    ),
    "todayFlowBadgeNew": MessageLookupByLibrary.simpleMessage("nuevo hoy"),
    "todayFlowSectionTitle": MessageLookupByLibrary.simpleMessage("Flow"),
    "todayFlowSeeAll": m8,
    "todayFlowSubtitle": MessageLookupByLibrary.simpleMessage(
      "Esto es lo que fluye en tu hogar hoy.",
    ),
    "todayFlowTabActive": MessageLookupByLibrary.simpleMessage("Activas"),
    "todayFlowTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "todayShareActiveSubtitle": m9,
    "todayShareBadgeUpcoming": MessageLookupByLibrary.simpleMessage(
      "próximamente",
    ),
    "todayShareDraftSubtitle": MessageLookupByLibrary.simpleMessage(
      "Completa la división para publicar este gasto.",
    ),
    "todayShareEmptyState": MessageLookupByLibrary.simpleMessage(
      "Aún no hay nada aquí. Cuando registres gastos o empieces borradores, aparecerán en Share.",
    ),
    "todayShareError": MessageLookupByLibrary.simpleMessage(
      "No pudimos actualizar Share en este momento.",
    ),
    "todayShareSampleGroceries": MessageLookupByLibrary.simpleMessage(
      "Compras compartidas de ayer",
    ),
    "todayShareSampleInternet": MessageLookupByLibrary.simpleMessage(
      "Factura de internet esta semana",
    ),
    "todayShareSampleRent": MessageLookupByLibrary.simpleMessage(
      "Recordatorio de renta pronto",
    ),
    "todayShareSectionTitle": MessageLookupByLibrary.simpleMessage("Share"),
    "todayShareSeeAll": MessageLookupByLibrary.simpleMessage(
      "Ver todos los gastos",
    ),
    "todayShareTabActive": MessageLookupByLibrary.simpleMessage("Activas"),
    "todayShareTabDrafts": MessageLookupByLibrary.simpleMessage("Borradores"),
    "today_home_details": m10,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "Sin hogar activo todavÃ­a. Crea o Ãºnete para ver la vista de hoy.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("Hoy"),
    "unknownInitial": MessageLookupByLibrary.simpleMessage("?"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
  };
}
