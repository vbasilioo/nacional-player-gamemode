/*
*
*	-= PAP INCLUDE =-
*	Protioso Arquivo Pessoal
*
*	Autor: Protioso ([VGS]Protioso_OC)
*  	Primeira versão: 6 de dezembro de 2009 - 1.0 (versão em uso)
*
*/

#include "PGD"


#define PAP_FORMATO_ARQUIVO_JOGADOR "WarLike/Usuarios/%s.txt" // %s é o nome do jogador, não o retire.
#define PAP_TAXA_PCOD_SENHA TAXA_MEDIANA // Taxa do PCOD (função do include PSF).
#define PAP_PREFIXO_PADRAO ":"

/*Lista de funções do sistema PAP -----------------------------------------------------------------------------||

native pap_JogadorRegistrado(playerid);
native pap_IniciarConta(playerid, senha[MAX_PCOD_CHAR]);
native pap_VerificarSenha(playerid, senha[MAX_PCOD_CHAR]);
native pap_MudarSenha(playerid, nova_senha[MAX_PCOD_CHAR]);
native pap_MudarNomeArquivoJogador(nome_anterior_jogador[], novo_nome_jogador[]);
native pap_CriarArquivo(playerid);
native pap_ApagarArquivo(playerid);
native pap_ArquivoExiste(playerid);
native pap_SalvarStr(playerid, chave[], valor[]);
native pap_SalvarInt(playerid, chave[], valor);
native pap_SalvarFloat(playerid, chave[], Float:valor);
native pap_SalvarBool(playerid, chave[], bool:valor);
native pap_CarregarStr(playerid, chave[]);
native pap_CarregarInt(playerid, chave[]);
native pap_CarregarFloat(playerid, chave[]);
native pap_CarregarBool(playerid, chave[]);
native pap_ArquivoJogador(playerid);

/------------------------------------------------------------------------------------------------------------||*/

#define pap_JogadorRegistrado pap_ArquivoExiste

stock pap_IniciarConta(playerid, senha[MAX_PCOD_CHAR])
{
	if(!IsPlayerConnected(playerid)) return 0;
	new senha_pcod[MAX_PCOD_CHAR_FINAL];
	senha_pcod = psf_PCODStr(senha, PAP_TAXA_PCOD_SENHA);
	pap_CriarArquivo(playerid);
	pap_SalvarStr(playerid, "Senha", senha_pcod);
	return 1;
}

stock pap_VerificarSenha(playerid, senha[MAX_PCOD_CHAR])
{
	if(!IsPlayerConnected(playerid) || !pap_JogadorRegistrado(playerid)) return 0;
	new senha_pcod[MAX_PCOD_CHAR_FINAL];
	senha_pcod = psf_PCODStr(senha, PAP_TAXA_PCOD_SENHA);
	if(!strcmp(senha_pcod, pap_CarregarStr(playerid, "Senha"), false)) return 1;
	return 0;
}

stock pap_MudarSenha(playerid, nova_senha[MAX_PCOD_CHAR])
{
	if(!IsPlayerConnected(playerid) || !pap_JogadorRegistrado(playerid)) return 0;
	new senha_pcod[MAX_PCOD_CHAR_FINAL];
	senha_pcod = psf_PCODStr(nova_senha, PAP_TAXA_PCOD_SENHA);
	pap_SalvarStr(playerid, "Senha", senha_pcod);
	return 1;
}

stock pap_MudarNomeArquivoJogador(nome_anterior_jogador[], novo_nome_jogador[])
{
	new
	    novo_nomef[64],
		nome_anteriorf[64];
		
	format(nome_anteriorf, sizeof(nome_anteriorf), PAP_FORMATO_ARQUIVO_JOGADOR, nome_anterior_jogador);
	format(novo_nomef, sizeof(novo_nomef), PAP_FORMATO_ARQUIVO_JOGADOR, novo_nome_jogador);
	if(!pgd_ArquivoExiste(nome_anteriorf) || pgd_ArquivoExiste(novo_nomef)) return 0;
	return pgd_RenomearArquivo(nome_anteriorf, novo_nomef);
}

stock pap_ApagarChave(playerid, chave[]) return pgd_ApagarChave(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO);

stock pap_CriarArquivo(playerid) return pgd_CriarArquivo(pap_ArquivoJogador(playerid));

stock pap_ApagarArquivo(playerid) return pgd_ApagarArquivo(pap_ArquivoJogador(playerid));

stock pap_ArquivoExiste(playerid) return pgd_ArquivoExiste(pap_ArquivoJogador(playerid));

stock pap_SalvarStr(playerid, chave[], valor[]) return pgd_EscreverStr(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO, valor);

stock pap_SalvarInt(playerid, chave[], valor) return pgd_EscreverInt(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO, valor);

stock pap_SalvarFloat(playerid, chave[], Float:valor) return pgd_EscreverFloat(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO, valor);

stock pap_SalvarBool(playerid, chave[], bool:valor) return pgd_EscreverBool(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO, valor);

stock pap_CarregarStr(playerid, chave[])
{
	new valor[MAX_VALOR_CHAR];
	valor = pgd_CarregarStr(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO);
	return valor;
}

stock pap_CarregarInt(playerid, chave[]) return pgd_CarregarInt(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO);

stock Float:pap_CarregarFloat(playerid, chave[]) return pgd_CarregarFloat(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO);

stock bool:pap_CarregarBool(playerid, chave[]) return pgd_CarregarBool(pap_ArquivoJogador(playerid), chave, PAP_PREFIXO_PADRAO);

stock pap_ArquivoJogador(playerid)
{
	new
	    nomearq[64],
		nomej[MAX_PLAYER_NAME];

	GetPlayerName(playerid, nomej, MAX_PLAYER_NAME);
	format(nomearq, sizeof(nomearq), PAP_FORMATO_ARQUIVO_JOGADOR, nomej);
	return nomearq;
}
