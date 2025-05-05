extends Control

var diario_contenido = {
	"Allen": "Me llamo Allen, tengo 27 años y este es mi diario. Vivo en Grayfields con mi hermana Tulip. En el pueblo se me conoce por mi ausencia, porque apenas salgo de casa. Debo admitir que no soy la persona más social. Supongo que escribir esto es mi forma de dejar constancia de que estoy vivo y que no soy un producto de la imaginación de mi hermana.\n\nTulip me insiste a diario para salir más. Qué pereza... Prefiero mi cuarto. Aquí el tiempo pasa más despacio.",
	
	"Grayfields": "Grayfields es un pueblo tranquilo. Un pequeño trozo de paraíso perdido entre un bosque y un lago. Mis padres solían decir que aquí no pasaba nada, y por eso era el lugar perfecto para criar a dos niños raros. Luego se fueron y seguimos aquí, igual de raros pero más mayores.\n\nTulip dice que el pueblo es aburrido, yo creo que simplemente se le queda pequeño. Siempre quiere explorar más, ver más...\n\nLa gente del pueblo es poco reseñable, y puedo contar los amigos que tengo con los dedos de una mano. A mí me sirve. Tulip es suficientemente sociable por mí.",
	
	"Nuestro árbol": "Cerca de casa, justo antes de que empiece el sendero, está el pequeño árbol que plantamos Tulip y yo. Era nuestra gran idea: regarlo, cuidarlo, verlo crecer… y algún día construir una casa entre sus ramas. Creo que tenía seis o siete años, y ninguna noción del tiempo.\n\nTulip le cambia el nombre de vez en cuando. Hoy lo llama Roberto Encinas, ayer fue David Robles, y probablemente mañana se llame Carlos del Pino o algo parecido.\n\nYo no le he puesto nombre. Me he limitado a verlo crecer, lento, pero siempre ahí. Aunque parezca una tontería, me gusta que exista. Me gusta que siga ahí de pie. Me recuerda que algunas promesas infantiles no están rotas.",
	
	"La piedra": "En medio del bosque hay una piedra bastante grande. No enorme, pero lo suficiente como para ser muchas cosas: ha sido nuestra mesa de picnic, nuestra fortaleza, el trono del rey de los elfos, y un sitio donde tirarse a mirar el cielo hasta que se ponía el sol. Me sorprende la cantidad de memorias que puede guardar algo tan simple.\n\nRecuerdo que una vez dormí sobre ella, después de tener una discusión con Tulip. No quería volver a casa. No recuerdo por qué discutimos, pero sí que al rato vino a buscarme con una linterna y dos chocolatinas.\n\nLa piedra sigue ahí. Inmóvil, indiferente. Como si siempre hubiera formado parte de nuestras vidas.",
	
	"El árbol caído": "Cuando era pequeño, este árbol me parecía gigantesco. Juraría que llegaba a las nubes. Estaba convencido de que dentro vivían pájaros mágicos o espíritus del bosque.\n\nAhora está en el suelo. No sé si lo tumbó el viento, si lo cortaron, o si simplemente se rindió.\n\nTulip y yo seguimos jugando a inventar historias de porqué se cayó.\n\nA veces tengo miedo de que un día yo también me caiga, y nadie recuerde que un día estuve depié. Pero Tulip sí lo recordará. Y eso es suficiente.",
	
	"Mi cuarto": "Mi cuarto es el único lugar donde siento que tengo control. El caos me pertenece: la cama deshecha, la mesa llena de papeles, los libros alineados en un orden que sólo yo entiendo...\n\nCada cosa está donde debe estar, incluso lo roto.\n\nCuando Tulip entra a mi cuarto, todo cambia. El aire se vuelve más ligero, aunque yo actúe como si me molestara. Siempre lo hace sin pedir permiso. No porque no respete mis límites, sino porque no cree que deba tenerlos con ella.\n\nSupongo que es su forma de decir: “No estás solo”.\n\nY yo… intento no olvidarlo.",
	
	"El lazo perdido": "Otro día, otro lazo. No sé cuántos tiene Tulip, pero siempre hay uno que es “el más importante”.\n\nEsta vez estaba debajo del sofá. No me molesta que me haga buscarlo. Lo que me molesta es que lo pierda a propósito para que yo lo busque.\n\nNo Importa... Cuando lo encuentro y sonríe así, como si le acabaran de devolver un tesoro, todo lo demás da igual.\n\nMe gusta que confíe en mí para estas tonterías...\n\nOjalá pudiera arreglarle todo tan fácilmente como encontrar un lazo bajo un cojín.",
	
	"El baño": "El baño está casi igual que siempre. Las toallas aún huelen a jabón barato, ni pista de la pasta de dientes, y un armario lleno de cremas con nombres imposibles. Son todas de Tulip.\n\nCada una de sus cosas ocupan más espacio del que deberían, igual que ella.\n\nFalta un cepillo de dientes. El suyo, creo.\n\nA veces me pregunto si un día dejará de estar en cada rincón de la casa. Y si eso pasa…\n\nNo. No quiero pensar en eso todavía."
};


var objetos = [
	"Sopa de champiñones",
	"Albondigas en salsa",
	"Chili picante",
	"Caja de galletas normales",
	"Caja de galletas rellenas",
	"Caja de galletas con pasas",
	"Refresco de cola",
	"Agua",
	"Leche con sabor a plátano",
	"Leche",
	"Yogures",
	"Queso",
	"Pizza congelada",
	"Helado de menta y chocolate",
	"Nuggets de pollo congelados",
	"Zanahorias",
	"Pechugas de pollo",
	"Pescado",
	"Pan",
	"Huevos",
	"Miel de Agatha",
	"Jabón",
	"Mr Coconut"
]

var mission_thoughts = {
	"Encontrar el lazo": "Tiene que estar en alguna parte.",
	"Hacer la compra": "Por poco que quiera, para limpiar se necesita jabón.",
	"Encontrar al gato de Lauren": "Mr Coconut ha salido a dar una vuelta.",
	"Devuelvele el gato a Lauren": "Hora de llevarte con tu dueña, chiquitín."
}

var item_thoughts = {
	"Sopa de champiñones": "No me fio demasiado de como pueda estar esto...",
	"Albondigas en salsa": "¿Será carne de verdad?",
	"Chili picante": "Un billete directo a villa cuarto de baño.",
	"Caja de galletas normales": "Crujientes. Simples. Perfectas.",
	"Caja de galletas rellenas": "De algo tendré que morirme.",
	"Caja de galletas con pasas": "A veces te odio, Tulip.",
	"Refresco de cola": "Caries para ti, caries para mí.",
	"Agua": "Es agua. ¿Qué más quieres?",
	"Leche con sabor a plátano": "Hay que mimar a la hermanita de vez en cuando.",
	"Leche": "Buena para los huesos. Y para las galletas.",
	"Yogures": "Caducan demasiado rápido.",
	"Queso": "Uno de los placeres de la vida.",
	"Pizza congelada": "No es la mejor, pero hace el trabajo.",
	"Helado de menta y chocolate": "Soy un incomprendido.",
	"Nuggets de pollo congelados": "Un clásico de media noche.",
	"Zanahorias": "Crujientes. Saludables. Meh.",
	"Pechugas de pollo": "Mmm... Sopa de pollo...",
	"Pescado": "No es mi favorito, pero es lo que hay.",
	"Pan": "No hay hogar sin pan.",
	"Huevos": "El alimento más versátil que has visto en tu vida.",
	"Miel de Agatha": "La etiqueta tiene un dibujo raro.",
	"Jabón": "Qué pocas ganas tengo de fregar.",
	"Mr Coconut": "El gato de Lauren. Tulip lo adora a morir."
}
