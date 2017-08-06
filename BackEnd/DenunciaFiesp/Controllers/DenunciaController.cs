using DenunciaFiesp.Dto;
using DenunciaFiesp.Repositorio;
using RestSharp;
using RestSharp.Authenticators;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Linq;
using OneSignal.CSharp.SDK;
using OneSignal.CSharp.SDK.Resources.Notifications;
using OneSignal.CSharp.SDK.Resources;
using System.Collections.Generic;

namespace DenunciaFiesp.Controllers
{
    public class DenunciaController : ApiController
    {
        private readonly ConversaRepositorio _repositorioConversas;

        public DenunciaController()
        {
            _repositorioConversas = new ConversaRepositorio();
        }

        [HttpPost]
        public HttpResponseMessage EnviarDados(Conversa conversa)
        {
            try
            {
                var grupoMensagens = new List<List<Mensagem>>();

                foreach (var item in conversa.Mensagens.Select(x => x.NomeContato).Distinct())
                {
                    grupoMensagens.Add(conversa.Mensagens.Where(x => x.NomeContato == item).ToList());
                }

                foreach (var mensagem in grupoMensagens)
                {
                    var contato = new Contato()
                    {
                        nome = mensagem.First().NomeContato,
                        telefone = mensagem.First().NomeContato
                    };

                    foreach (var item in mensagem)
                    {
                        var classeResultado = this.AnalisarPedofilia(item.Texto);

                        if ("pedofilia".Equals(classeResultado.class_name, StringComparison.InvariantCultureIgnoreCase))
                        {
                            contato.mensagens.Add(new MensagemChat()
                            {
                                dataEnvio = item.DataEnvio.Split(' ').First(),
                                horaEnvio = item.DataEnvio.Split(' ').Last(),
                                texto = item.Texto,
                                nivelPerigo = (float)classeResultado.confidence * 100
                            });
                        }
                    }

                    if (contato.mensagens.Any())
                    {
                        contato.qtdMsg = contato.mensagens.Count;
                        contato.nivelPerigo = contato.mensagens.Sum(x => x.nivelPerigo) / contato.mensagens.Count;

                        _repositorioConversas.Adicionar(contato);

                        EnviarPush(contato.nome);
                    }
                }

                return Request.CreateResponse(HttpStatusCode.OK, new { sucesso = true });
            }

            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new { sucesso = false });
            }
        }

        private Classes AnalisarPedofilia(string texto)
        {
            var client = new RestClient("https://gateway.watsonplatform.net/natural-language-classifier/api/v1/");
            client.Authenticator = new HttpBasicAuthenticator("0d6a4440-1c4e-444b-a495-7ffb37e5ae7c", "DrVmAevvWWb7");

            var request = new RestRequest("classifiers/{id}/classify", Method.GET);
            request.AddUrlSegment("id", "ad940ex207-nlc-494");
            request.AddQueryParameter("text", texto);

            IRestResponse<NLCResposta> response2 = client.Execute<NLCResposta>(request);

            return response2.Data.classes.First();
        }

        private void EnviarPush(string nome)
        {
            var client = new OneSignalClient("NGFjNmJiNjgtNDUwYi00NTEwLTgyMDYtZWEyYzM1NGRjMGNm");
            var options = new NotificationCreateOptions();
            options.AppId = new Guid("1fc34bfe-eae4-468c-ba2e-a758b27be571");
            options.IncludedSegments = new List<string> { "All" };
            options.Contents.Add(LanguageCodes.English, "Um novo pedófilo foi encontrado: " + nome);
            client.Notifications.Create(options);
        }
    }
}