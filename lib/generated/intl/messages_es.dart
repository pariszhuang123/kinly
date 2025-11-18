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

  static String m1(code) => "Te has unido con el código: ${code}";

  static String m2(homeId, role) => "Hogar actual: ${homeId} • Rol: ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Kinly"),
    "create_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo crear el hogar. Intenta de nuevo.",
    ),
    "create_submit": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "create_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crearemos tu hogar al instante. Podrás renombrarlo e invitar luego.",
    ),
    "create_success": MessageLookupByLibrary.simpleMessage("¡Hogar creado!"),
    "create_title": MessageLookupByLibrary.simpleMessage("Crear hogar"),
    "join_failed_generic": MessageLookupByLibrary.simpleMessage(
      "No se pudo unir. Por favor, inténtalo de nuevo.",
    ),
    "join_hint": MessageLookupByLibrary.simpleMessage(
      "Ingresa el código de invitación",
    ),
    "join_submit": MessageLookupByLibrary.simpleMessage("Unirse"),
    "join_success": m1,
    "join_title": MessageLookupByLibrary.simpleMessage("Unirse al hogar"),
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
      "Ya eres parte de un hogar.",
    ),
    "membership_status_checking": MessageLookupByLibrary.simpleMessage(
      "Comprobando el estado de la membresía…",
    ),
    "membership_status_none": MessageLookupByLibrary.simpleMessage(
      "Aún no te has unido a un hogar.",
    ),
    "navExplore": MessageLookupByLibrary.simpleMessage("Explorar"),
    "navHub": MessageLookupByLibrary.simpleMessage("Centro"),
    "navToday": MessageLookupByLibrary.simpleMessage("Hoy"),
    "quick_add_fair_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar una entrada de equidad",
    ),
    "quick_add_fair_share_title": MessageLookupByLibrary.simpleMessage(
      "Fair Share",
    ),
    "quick_add_flow_subtitle": MessageLookupByLibrary.simpleMessage(
      "Añadir una tarea a Flow",
    ),
    "quick_add_flow_title": MessageLookupByLibrary.simpleMessage("Flow"),
    "quick_add_poll_subtitle": MessageLookupByLibrary.simpleMessage(
      "Crear una encuesta rápida para el hogar",
    ),
    "quick_add_poll_title": MessageLookupByLibrary.simpleMessage("Encuesta"),
    "quick_add_share_subtitle": MessageLookupByLibrary.simpleMessage(
      "Registrar un gasto compartido",
    ),
    "quick_add_share_title": MessageLookupByLibrary.simpleMessage("Share"),
    "quick_add_title": MessageLookupByLibrary.simpleMessage("Añadir rápido"),
    "todayEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Disfruta de la calma; Kinly te avisará cuando haya algo que hacer.",
    ),
    "todayEmptyCardBadge": MessageLookupByLibrary.simpleMessage(
      "Tómate un respiro",
    ),
    "todayEmptyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Hoy lo tienes todo al día ✨",
    ),
    "today_home_details": m2,
    "today_no_membership": MessageLookupByLibrary.simpleMessage(
      "Sin hogar activo todavía. Crea o únete para ver la vista de hoy.",
    ),
    "today_title": MessageLookupByLibrary.simpleMessage("Hoy"),
    "welcome_create": MessageLookupByLibrary.simpleMessage("Crear un hogar"),
    "welcome_join": MessageLookupByLibrary.simpleMessage("Unirse a un hogar"),
    "welcome_title": MessageLookupByLibrary.simpleMessage("Bienvenido a Kinly"),
    "todayAddShareComingSoon": MessageLookupByLibrary.simpleMessage(
      "La función de gastos de Share llegará pronto.",
    ),
    "todayAddSheetFlow": MessageLookupByLibrary.simpleMessage("Agregar tarea (Flow)"),
    "todayAddSheetShare": MessageLookupByLibrary.simpleMessage(
      "Agregar gasto (Share)",
    ),
    "todayAddSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Añade algo a tu hogar",
    ),
    "flowChoreCreateTitle": MessageLookupByLibrary.simpleMessage(
      "Agregar tarea de Flow",
    ),
    "flowChoreEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar tarea de Flow",
    ),
    "flowChoreNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre de la tarea",
    ),
    "flowChoreNameHint": MessageLookupByLibrary.simpleMessage(
      "Ponle un título corto y claro",
    ),
    "flowChoreValidationName": MessageLookupByLibrary.simpleMessage(
      "Dale un nombre a la tarea.",
    ),
    "flowChoreAssigneeLabel": MessageLookupByLibrary.simpleMessage("Asignar a"),
    "flowChoreAssigneeUnassigned": MessageLookupByLibrary.simpleMessage(
      "Sin asignar",
    ),
    "flowChoreValidationAssignee": MessageLookupByLibrary.simpleMessage(
      "Elige a quién asignar esta tarea.",
    ),
    "flowChoreStartLabel": MessageLookupByLibrary.simpleMessage("Fecha de inicio"),
    "flowChoreRecurrenceLabel": MessageLookupByLibrary.simpleMessage("Repetición"),
    "flowChoreRecurrenceNone": MessageLookupByLibrary.simpleMessage("Una vez"),
    "flowChoreRecurrenceDaily": MessageLookupByLibrary.simpleMessage("Diario"),
    "flowChoreRecurrenceWeekly": MessageLookupByLibrary.simpleMessage("Semanal"),
    "flowChoreRecurrenceEvery2Weeks": MessageLookupByLibrary.simpleMessage(
      "Cada 2 semanas",
    ),
    "flowChoreRecurrenceMonthly": MessageLookupByLibrary.simpleMessage("Mensual"),
    "flowChoreRecurrenceEvery2Months": MessageLookupByLibrary.simpleMessage(
      "Cada 2 meses",
    ),
    "flowChoreRecurrenceAnnual": MessageLookupByLibrary.simpleMessage("Anual"),
    "flowChoreNotesLabel": MessageLookupByLibrary.simpleMessage("Notas"),
    "flowChoreNotesHint": MessageLookupByLibrary.simpleMessage(
      "Agrega contexto o recordatorios opcionales",
    ),
    "flowChoreHowToLabel": MessageLookupByLibrary.simpleMessage(
      "Enlace de instrucciones",
    ),
    "flowChoreHowToHint": MessageLookupByLibrary.simpleMessage(
      "Pega un enlace de video o documento (opcional)",
    ),
    "flowChorePhotoLabel": MessageLookupByLibrary.simpleMessage(
      "Foto de referencia",
    ),
    "flowChorePhotoHint": MessageLookupByLibrary.simpleMessage(
      "storage/households/... (opcional)",
    ),
    "flowChoreSubmitCreate": MessageLookupByLibrary.simpleMessage("Agregar tarea"),
    "flowChoreSubmitUpdate": MessageLookupByLibrary.simpleMessage("Guardar tarea"),
    "flowChoreLoadError": MessageLookupByLibrary.simpleMessage(
      "No pudimos cargar esta tarea. Intenta de nuevo.",
    ),
    "flowChoreRetry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "flowChoreErrorPaywallActiveCap": MessageLookupByLibrary.simpleMessage(
      "Alcanzaste el límite gratuito de tareas activas. Mejora el plan para agregar más.",
    ),
    "flowChoreErrorPaywallMediaCap": MessageLookupByLibrary.simpleMessage(
      "Alcanzaste el límite gratuito de fotos de referencia. Elimina una o mejora el plan.",
    ),
    "flowChoreErrorAssigneeNotMember": MessageLookupByLibrary.simpleMessage(
      "Ese miembro no se puede asignar ahora.",
    ),
    "flowChoreErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "No tienes permiso para cambiar esta tarea.",
    ),
    "flowChoreErrorInvalidPhoto": MessageLookupByLibrary.simpleMessage(
      "Esa ruta de foto no es válida para este hogar.",
    ),
    "flowChoreErrorInvalidStart": MessageLookupByLibrary.simpleMessage(
      "Elige una fecha de inicio válida.",
    ),
    "flowChoreErrorInvalidState": MessageLookupByLibrary.simpleMessage(
      "Esta tarea no se puede actualizar en este momento.",
    ),
    "flowChoreErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar la tarea. Intenta de nuevo.",
    ),
  };
}
