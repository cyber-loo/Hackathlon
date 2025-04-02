import SwiftUI

class UsuariosGlobales: ObservableObject {
    @Published var nombre_usuario: String = ""
    @Published var peso_usuario: Double? = nil
    @Published var edad_usuario: Double? = nil
    @Published var sexo_usuario: String = ""
}


struct ContentView: View {
    @StateObject var datos = UsuariosGlobales()
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("DATOS PERSONALES").font(.headline).foregroundColor(.red)) {
                TextField("Nombre Completo", text: $datos.nombre_usuario)
                TextField("Edad", value: $datos.edad_usuario, formatter: numberFormatter)
                    .keyboardType(.numberPad)
                TextField("Peso (kg)", value: $datos.peso_usuario, formatter: numberFormatter)
                    .keyboardType(.decimalPad)
                TextField("Sexo (Femenino o Masculino)", text: $datos.sexo_usuario)
                            }

                Section {
                    NavigationLink("Todo listo!", destination: SegundaVista().environmentObject(datos))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                            }
                        }
                        .navigationTitle("SafeSip")
                        .environmentObject(datos)
                    }
    }
}

struct SegundaVista: View {
    @EnvironmentObject var usuario: UsuariosGlobales

    var body: some View {
        VStack {
            Text("BIENVENID@")
                .font(.largeTitle)
                .padding(.bottom, 3)
                .foregroundColor(Color(red: 211/255, green: 47/255, blue: 47/255))

            Text(usuario.nombre_usuario)
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .bold()
                .padding(.top, 0)

            NavigationLink("EMERGENCIA", destination: EmergenciaVista())
                .font(.title)
                .bold()
                .frame(width: 300, height: 70)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)
            
            NavigationLink("PÁNICO", destination: PanicoVista())
                .font(.title)
                .bold()
                .frame(width: 300, height: 70)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)

            Text("Seleccione su consumo: ")
                .font(.headline)
                .padding(.top)
                .bold()
        
            EleccionBebida()
            
            Text("Noticias: ")
                .bold()
            
            EleccionNoticias()
            
        }
        
    }
}

struct Bebida: Identifiable {
    let id = UUID()
    let nombre: String
    let graduacion: Double
}

struct DatosBebidas {
    static let lista: [Bebida] = [
        Bebida(nombre: "Cerveza", graduacion: 5),
        Bebida(nombre: "Vino blanco", graduacion: 12.5),
        Bebida(nombre: "Vino tinto", graduacion: 13.5),
        Bebida(nombre: "Vermut", graduacion: 15),
        Bebida(nombre: "Baileys", graduacion: 17),
        Bebida(nombre: "Pacharan", graduacion: 25),
        Bebida(nombre: "Brandy", graduacion: 36),
        Bebida(nombre: "Ron blanco", graduacion: 37),
        Bebida(nombre: "Ginebra rosa", graduacion: 37.5),
        Bebida(nombre: "Tequila", graduacion: 38),
        Bebida(nombre: "Ron negro", graduacion: 40),
        Bebida(nombre: "Vodka", graduacion: 40),
        Bebida(nombre: "Whisky", graduacion: 45),
        Bebida(nombre: "Ginebra blanca", graduacion: 47.3),
        Bebida(nombre: "Absenta", graduacion: 70)
    ]
}

struct EleccionBebida: View {
    let bebidas = DatosBebidas.lista

    var body: some View {
        NavigationStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(bebidas) { bebida in
                        NavigationLink(destination: DetallesBebidas (bebida:bebida)){
                            VStack {
                                Text(bebida.nombre)
                                    .frame(width: 100, height: 50)
                                    .background(Color.red.opacity(0.6))
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct EleccionNoticias: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(1...5, id: \.self) { noticia in
                        NavigationLink(destination: Noticias(noticia: noticia)) {
                            Text("Noticia \(noticia)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(Color.white)
                                .background(Color.red.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Noticias")
        }
    }
}


struct Noticias: View {
    let noticia: Int

    var body: some View {
        VStack {
            Text("TITULO \(noticia)")
                .font(.largeTitle)
                .padding()
                .bold()
            
            Spacer()
        }
        .navigationTitle("Noticia \(noticia)")
    }
}
struct DetallesBebidas: View {
    let bebida: Bebida

    var body: some View {
        VStack(spacing: 20) {
            Text("Información")
                .font(.largeTitle)
                .bold()

            Text("Graduación alcohólica: \(bebida.graduacion, specifier: "%.1f")%")
                .font(.title2)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle(bebida.nombre)
        .multilineTextAlignment(.center)
    }
}



struct EmergenciaVista: View {
    @State private var alerta = false
    
    var body: some View {
        VStack {
            Button(action: {
                alerta = true
                }) {
            Image(systemName: "car.circle")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(20)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                    .shadow(radius: 5)
                        }
                    }
        .alert("SafeSip desea acceder a su ubicación", isPresented: $alerta) {
            Button("No permitir", role: .cancel) {
                print("Ubicación denegada")
                        }
            Button("Permitir") {
                print("Ubicación permitida")
                        }
    } message: {
            Text("Para poder brindarte ayuda, es necesario que nos proporciones tu ubicación")
                    }
                }
}

struct PanicoVista: View {
    @State private var alerta = false
    
    var body: some View {
        VStack {
            Button(action: {
                alerta = true
                }) {
            Image(systemName: "mappin.circle")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(20)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                    .shadow(radius: 5)
                        }
                    }
        .alert("SafeSip desea acceder a su ubicación", isPresented: $alerta) {
            Button("No permitir", role: .cancel) {
                print("Ubicación denegada")
                        }
            Button("Permitir") {
                print("Ubicación permitida")
                        }
    } message: {
            Text("Para poder brindarte ayuda, es necesario que nos proporciones tu ubicación")
                    }
                }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UsuariosGlobales())
    }
}
