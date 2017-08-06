using DenunciaFiesp.Dto;
using FireSharp;
using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;

namespace DenunciaFiesp.Repositorio
{
    public class ConversaRepositorio
    {
        private readonly IFirebaseClient _clientFirebase;

        public ConversaRepositorio()
        {
            IFirebaseConfig config = new FirebaseConfig
            {
                BasePath = "https://hackathonfiesp-4a889.firebaseio.com/"
            };

            _clientFirebase = new FirebaseClient(config);
        }

        public void Adicionar(Contato contato)
        {
            PushResponse response = _clientFirebase.PushAsync("conversas", contato).Result;
        }
    }
}