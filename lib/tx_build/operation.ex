defmodule Stellar.TxBuild.Operation do
  @moduledoc """
  `Operation` struct definition.
  """

  alias Stellar.TxBuild.{
    AccountMerge,
    BumpSequence,
    BeginSponsoringFutureReserves,
    ChangeTrust,
    ClaimClaimableBalance,
    Clawback,
    ClawbackClaimableBalance,
    CreateAccount,
    CreateClaimableBalance,
    CreatePassiveSellOffer,
    EndSponsoringFutureReserves,
    LiquidityPoolDeposit,
    LiquidityPoolWithdraw,
    ManageData,
    ManageSellOffer,
    ManageBuyOffer,
    OptionalAccount,
    Payment,
    PathPaymentStrictSend,
    PathPaymentStrictReceive,
    RevokeSponsorship,
    SetOptions,
    SetTrustlineFlags,
    InvokeHostFunction
  }

  alias StellarBase.XDR.Operation

  @behaviour Stellar.TxBuild.XDR

  @type operation ::
          AccountMerge.t()
          | BumpSequence.t()
          | BeginSponsoringFutureReserves.t()
          | ChangeTrust.t()
          | ClaimClaimableBalance.t()
          | Clawback.t()
          | ClawbackClaimableBalance.t()
          | CreateAccount.t()
          | CreateClaimableBalance.t()
          | CreatePassiveSellOffer.t()
          | EndSponsoringFutureReserves.t()
          | LiquidityPoolDeposit.t()
          | LiquidityPoolWithdraw.t()
          | ManageData.t()
          | ManageSellOffer.t()
          | ManageBuyOffer.t()
          | Payment.t()
          | PathPaymentStrictSend.t()
          | PathPaymentStrictReceive.t()
          | RevokeSponsorship.t()
          | SetOptions.t()
          | SetTrustlineFlags.t()
          | InvokeHostFunction.t()

  @type t :: %__MODULE__{body: operation(), source_account: OptionalAccount.t()}

  defstruct [:body, :source_account]

  @impl true
  def new(body, opts \\ [])

  def new(body, _opts) do
    case validate_operation(body) do
      :ok -> %__MODULE__{body: body, source_account: body.source_account}
      error -> error
    end
  end

  @impl true
  def to_xdr(%__MODULE__{body: %{__struct__: operation} = body, source_account: source_account}) do
    source_account = OptionalAccount.to_xdr(source_account)

    body
    |> operation.to_xdr()
    |> Operation.new(source_account)
  end

  @spec validate_operation(operation :: operation()) :: :ok | {:error, atom()}
  defp validate_operation(%{__struct__: op_type} = op_body) do
    op_types = [
      AccountMerge,
      BumpSequence,
      BeginSponsoringFutureReserves,
      ChangeTrust,
      ClaimClaimableBalance,
      Clawback,
      ClawbackClaimableBalance,
      CreateAccount,
      CreateClaimableBalance,
      CreatePassiveSellOffer,
      EndSponsoringFutureReserves,
      LiquidityPoolDeposit,
      LiquidityPoolWithdraw,
      ManageData,
      ManageBuyOffer,
      ManageSellOffer,
      Payment,
      PathPaymentStrictReceive,
      PathPaymentStrictSend,
      RevokeSponsorship,
      SetOptions,
      SetTrustlineFlags,
      InvokeHostFunction
    ]

    if op_type in op_types, do: :ok, else: {:error, [{:unknown_operation, op_body}]}
  end

  defp validate_operation(_operation), do: {:error, :invalid_operation}
end
