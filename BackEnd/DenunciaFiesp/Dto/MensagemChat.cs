namespace DenunciaFiesp.Dto
{
    public class MensagemChat
    {
        public string texto { get; set; }

        public string dataEnvio { get; set; }

        public string horaEnvio { get; set; }
        
        public float nivelPerigo { get; set; }
    }
}